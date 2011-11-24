//
//  AppDelegate.h
//  ColorMeNow
//
//  Created by Cyril Gaillard on 16/05/11.
//  Copyright Voila Design 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end


@interface NSString(RandomLetter)
- (NSString *)randomLetter;
@end

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end



