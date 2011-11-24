//
//  GameSelection.h
//  ColorMeNow
//
//  Created by Cyril Gaillard on 22/05/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameSelection : CCLayer {    
    NSInteger frameOffset;
    CCParticleSystemQuad *emitter;
    BOOL gamePurchased;
    NSString *gameT;
    ALuint swishEffect;
    CCMenu *gameSelection;
    CGSize winSize;
    NSArray *freeGames;
}

+(id) scene;
-(void) displayMenuInGrid:(CCMenu *)menu;
-(void)playOhNoSound;
-(void)buyAllCharacters;
@property (nonatomic, retain) CCParticleSystemQuad *emitter;
@end
