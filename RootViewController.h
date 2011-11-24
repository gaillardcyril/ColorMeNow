//
//  RootViewController.h
//  ColorMeNow
//
//  Created by Cyril Gaillard on 16/05/11.
//  Copyright Voila Design 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
    NSMutableDictionary *pListContent;
    NSInteger boysPurchased;
    NSInteger girlsPurchased;

}
- (void) copyStatusFile;
@property(nonatomic, retain)NSMutableDictionary *pListContent;
@end
