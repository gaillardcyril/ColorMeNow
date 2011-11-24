//
//  IAPHelper.h
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StoreKit/StoreKit.h"
#import "Reachability.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
    UIActivityIndicatorView *activityView;
    UIView* _hudView;
    NSNumber *productsRqstSuccessFul;
    NSNumber *buyRequestInProgress;
    
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;
@property (retain) UIView* _hudView;
@property (retain) NSNumber *productsRqstSuccessFul;
@property (retain) NSNumber *buyRequestInProgress;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;
- (void) addProgressIndicator:(id)sender;
- (void) removeProgressIndicator;

@end
