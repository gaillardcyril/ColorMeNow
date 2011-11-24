//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FinalScene: CCLayer {
    NSString* statusPlistPath;
    CCSprite *witch;
    CGSize winSize;
    CCSprite *oldBG;
    CCSprite *oldTree;
    CCSprite *oldCastle;
    CCParticleSystemQuad *emitter;
	
}
+(id) scene;
-(void) moveWitch;
-(void)changeBackground;
-(void)changeTrees;
-(void)changeCastle;
-(void)addBackMenu;
@property(nonatomic,retain) CCSprite *witch;


@end
