//
//  RootViewController.m
//  ColorMeNow
//
//  Created by Cyril Gaillard on 16/05/11.
//  Copyright Voila Design 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "ColorMeNowIAPHelper.h"
#import "Reachability.h"
#import "GameStatus.h"
#import "GameSelection.h"

@implementation RootViewController
@synthesize pListContent;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
 }
-(void)timeout:(id)sender{
    CCLOG(@"cannot connect to the app store");
    [[ColorMeNowIAPHelper sharedHelper]setProductsRqstSuccessFul:[NSNumber numberWithInt:0]];
}

 
- (void)viewWillAppear:(BOOL)animated {
    
    
    [self copyStatusFile];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    NSString *statusPlistPath = [documentsDirectory stringByAppendingPathComponent:@"GamesStatus.plist"];
    pListContent = [[NSMutableDictionary alloc] initWithContentsOfFile:statusPlistPath];
    [[GameStatus sharedGameStatus]setStatusPlistPath:statusPlistPath];
    [[GameStatus sharedGameStatus]setGameStatusList:pListContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        CCLOG(@"No internet connection!");        
    } else {        
        if ([ColorMeNowIAPHelper sharedHelper].products == nil) {            
            [[ColorMeNowIAPHelper sharedHelper] requestProducts];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }        
    }
}

- (void)updateInterfaceWithReachability: (Reachability*) curReach {
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *productIdentifier = (NSString *) notification.object;
    CCLOG(@"Purchased: %@", productIdentifier);
    if ([productIdentifier isEqualToString:@"com.voiladesign.colormenow.princesses" ]) {
        [[[GameStatus sharedGameStatus] gameStatusList]setObject:[NSNumber numberWithInt:1] forKey:@"GirlsPurchased"];
        [[GameStatus sharedGameStatus] updatePListFile];
    }
    else if([productIdentifier isEqualToString:@"com.voiladesign.colormenow.monsters" ]){
        [[[GameStatus sharedGameStatus] gameStatusList]setObject:[NSNumber numberWithInt:1] forKey:@"BoysPurchased"];
        [[GameStatus sharedGameStatus] updatePListFile];
    }
    [[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CCLOG(@"the products %@",[ColorMeNowIAPHelper sharedHelper].products);
    
}
- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}


- (void) copyStatusFile{
    
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"GamesStatus.plist"];
 
    
    NSString *pListName = @"GamesStatus";
    NSString *path = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
    
    success = [fileManager fileExistsAtPath:filePath];
    if (success) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        boysPurchased=0;
        girlsPurchased=0;
        boysPurchased=[[tempDict objectForKey:@"BoysPurchased"] intValue];
        girlsPurchased = [[tempDict objectForKey:@"GirlsPurchased"] intValue];
        if ([[tempDict objectForKey:@"gameVersion"] intValue]==1) {
            //NSLog(@"file wasn't copied, right version");
          return;   
        }
        else{
            //NSLog(@"file will be copied, wrong version");
            [fileManager removeItemAtPath:filePath error:NULL];
        }
       
        [tempDict release];
    }
    
        
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];

    if (!success) {
        //NSLog(@"file was not copied, error");
    }
    else{
        
        //NSLog(@"file was copied");
        NSMutableDictionary *newFileDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if (boysPurchased == 1) {
            [newFileDict setValue:[NSNumber numberWithInt:1] forKey:@"BoysPurchased"];
        }
        if (girlsPurchased == 1) {
            [newFileDict setValue:[NSNumber numberWithInt:1] forKey:@"GirlsPurchased"];
        }
        [newFileDict writeToFile:filePath atomically:YES];
        [newFileDict release];

    }
    
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [pListContent release];
}


@end

