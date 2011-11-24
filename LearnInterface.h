//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@interface LearnInterface: CCLayer {
	
    NSInteger totalItems;
    NSString *gameName;
    CGSize size;
    NSInteger idxToDisplay;
    NSInteger gameNumber;
    CCSpriteBatchNode *levelBatch;
    CCMenu *itemBrowser;
    CCLabelBMFont *nameOfItem;
    CCScrollLayer *scrollLayer;
    NSMutableArray* itemNameArray;
}
+(id) scene;
@property (nonatomic, retain)CCSpriteBatchNode *levelBatch;

@end
