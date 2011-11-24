//
//  HelloWorldLayer.h
//  ColorMeNow
//
//  Created by Cyril Gaillard on 16/05/11.
//  Copyright Voila Design 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <iAd/iad.h>
#import "RootViewController.h"

// HelloWorldLayer


@interface PlayingInterface : CCLayer<ADBannerViewDelegate>
{
    NSMutableArray *spriteArray;
    NSMutableArray *frameNameArray;
    NSInteger numberOfIterations;
    NSDictionary *spriteCoordinates;
    //NSMutableDictionary *gameStatus;
    CCMenu *lettersMenu;
    NSString* statusPlistPath;
    NSInteger score;
   // NSInteger frameOffset;
    CCParticleSystemQuad *emitter;
    CGSize winSize;
    CCSprite *answerSigns;
    NSString *fxName;
    NSArray *alphabet;
    NSArray *numbers;
    NSArray *colors;
    NSArray *colorsSounds;
    NSArray *shapes;
    NSArray *weather;
    
    NSMutableArray *pickedIndexes;
    NSMutableArray *pickedRdmIdx;
    NSMutableArray *animals;
    NSMutableArray *fishes;
    NSMutableArray *insects;
    NSMutableArray *instruments;
    NSMutableArray *sports;
    NSMutableArray *transports;
    NSInteger idxGame;    
    ADBannerView *adView;
    BOOL adViewPresent;

    NSInteger idxCorrectAns;
    NSInteger randomIdx;
    CCNode *instructionsLayer;
    CCLayerColor *pauseLayer;
    CCMenu *rstGameMenu;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)startPlaying;
-(void) gameEnded;
-(void) addBannerView;
-(void)placeLetters:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex withGameType:(NSInteger)gameType;
-(void)placeNumbers:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex;
-(void)placeColors:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex;
-(void)placeShapes:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex;
-(void)placeWeather:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex;
-(void)saySignInstructions;
-(void)sayRepInstructions;
-(void) removeInstrLayer;
-(void)fillArray:(NSMutableArray *)array withString:(NSString *)lessonName itemCount:(NSInteger)count;
-(void)placeLessonItem:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex withArray:(NSMutableArray *)lessonArray;
@property(nonatomic, retain) NSMutableArray *pickedIndexes;
@property(nonatomic, retain) NSMutableArray *pickedRdmIdx;

@end
