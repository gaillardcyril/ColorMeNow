//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"

@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;
@synthesize _hudView, productsRqstSuccessFul,buyRequestInProgress;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                //NSLog(@"Previously purchased: %@", productIdentifier);
            }
            //NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
        productsRqstSuccessFul = [NSNumber numberWithInt:0];
        
    }
    return self;
}

- (void)requestProducts {
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"cant do it mate");
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results...");   
    self.products = response.products;
    self.request = nil;    
    productsRqstSuccessFul=[NSNumber numberWithInt:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {    
    // TODO: Record the transaction on the server side...    
}

- (void)provideContent:(NSString *)productIdentifier {
    
    //NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"completeTransaction...");
    buyRequestInProgress=[NSNumber numberWithInt:0];
    [self removeProgressIndicator];
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    [self removeProgressIndicator];
    
    buyRequestInProgress=[NSNumber numberWithInt:0];
    //CCLOG(@"transaction cancelled.buyRequestInProgress %d",[buyRequestInProgress intValue]);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        //NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        //CCLOG(@"No internet connection!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" 
                                                        message:@"Cannot connect to the Internet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

    } else {
    buyRequestInProgress=[NSNumber numberWithInt:1];
    //NSLog(@"Buying %@...", productIdentifier);
    [self addProgressIndicator:nil];
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

- (void) addProgressIndicator:(id)sender {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(winSize.width/2-80, winSize.height/2-100,170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;
    
    UIActivityIndicatorView * _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    [_hudView addSubview:_activityIndicatorView];
    [_activityIndicatorView release];
    
    UILabel *_captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 30)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    [_captionLabel setFont:[UIFont fontWithName:@"Arial" size:30.0f]];
    _captionLabel.textAlignment = UITextAlignmentCenter;
    _captionLabel.text = @"Buying...";
    [_hudView addSubview:_captionLabel];
    [_captionLabel release];
    [[[CCDirector sharedDirector] openGLView] addSubview:_hudView];
    [_hudView release];
    [_activityIndicatorView startAnimating];
    
}
-(void) removeProgressIndicator{
    [_hudView removeFromSuperview];
}


- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

@end
