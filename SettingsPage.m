//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "FinalScene.h"
#import "SettingsPage.h"
#import "GameStatus.h"

#define MENU_ITEM_SIZE 60
@implementation SettingsPage
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsPage *layer = [SettingsPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // ask director the the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
        
        CCSpriteBatchNode *spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"hpBG.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hpBG.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"defaultBG.jpg"];
        [spritesNode addChild:background];
        background.scale=1.024;
        background.position = ccp(winSize.width/2,winSize.height/2);
        
            
        CCMenuItem *itemBackArrow = [CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage:@"backArrow.png" target: self selector: @selector(goBackHome:)];
        NSInteger arrowWidth = [itemBackArrow contentSize].width;
        NSInteger arrowHeight = [itemBackArrow contentSize].height;
		CCMenu *backHomeMenu = [CCMenu menuWithItems:itemBackArrow, nil];
		backHomeMenu.position = ccp(arrowWidth/2,winSize.height-arrowHeight/2);
		[self addChild:backHomeMenu z:2];

        
        CCMenuItem *resetItem = [CCMenuItemImage itemFromNormalImage:@"menuReset.png" selectedImage:@"menuResetS.png"  target:self selector:@selector(resetAllGames:)];
        
        CCMenuItem *playScene = [CCMenuItemImage itemFromNormalImage:@"replayScene.png" selectedImage:@"replaySceneS.png"  target:self selector:@selector(showFinalScene)];
        
        CCMenu *settingsMenu = [CCMenu menuWithItems:resetItem,nil];
        settingsMenu.position = ccp(700,500);

        NSArray *gameCompleted = [[[GameStatus sharedGameStatus] gameStatusList]objectForKey:@"GameCompleted"];
        //CCLOG(@"The array is %@",gameCompleted);
        NSInteger sum=0;
        for (NSNumber *item in gameCompleted) {
            sum+=[item intValue];
        }
        if (sum>=6 ) {
            [settingsMenu addChild:playScene];
        
        } 
        [settingsMenu alignItemsVertically];
        [self addChild:settingsMenu z:3];
		
	}
	return self;
}


-(void) showFinalScene{
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[FinalScene scene] withColor:ccc3(0,0,0)] ];
    
}
-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}
-(void)resetAllGames:(CCMenuItem *) menuItem {
    
    NSMutableArray *gameCompleted =[[NSMutableArray alloc ] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"] ];
    
    NSMutableArray *gameCompletedP = [[NSMutableArray alloc ] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompletedPrevious"] ]; 
    
    
    //CCLOG(@"the gameCompleted  before  is %@",gameCompleted);
    for (NSInteger i=0; i<[gameCompleted count];i++)
    {
        [gameCompleted replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
        [gameCompletedP replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }

    [[[GameStatus sharedGameStatus] gameStatusList] setObject:gameCompleted forKey:@"GameCompleted"];
    [[[GameStatus sharedGameStatus] gameStatusList] setObject:gameCompletedP forKey:@"GameCompletedPrevious"];
    [[[GameStatus sharedGameStatus] gameStatusList] setObject:[NSNumber numberWithInt:1] forKey:@"Girls1stTimePlayed"];
    [[[GameStatus sharedGameStatus] gameStatusList] setObject:[NSNumber numberWithInt:1] forKey:@"Boys1stTimePlayed"];
    //CCLOG(@"the gameCompleted  after  is %@",gameCompleted);
    
    [[GameStatus sharedGameStatus] updatePListFile];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HomePage scene] withColor:ccc3(0,0,0)]];
    [gameCompleted release];
    [gameCompletedP release];
   
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
    //[[CCTextureCache sharedTextureCache] removeAllTextures];
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

	[super dealloc];
}

@end
