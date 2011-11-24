//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HomePage : CCLayer {
    
    CCSprite *witch;
    NSInteger witchEndPosX;
    NSInteger witchEndPosY;
	
}
+(id) scene;
-(void) moveWitch:(id)sender;
@end
