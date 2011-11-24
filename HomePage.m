//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "GameSelection.h"
#import "AppDelegate.h"
#import "SettingsPage.h"
#import "CreditsPage.h"
#import "SimpleAudioEngine.h"
#import "FinalScene.h"
#import "LearnSelection.h"
#import "PlayingInterface.h"
#import "GameStatus.h"


#define MENU_ITEM_SIZE 60
@implementation HomePage

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HomePage *layer = [HomePage node];
	
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
		[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
        
        
        if(
           getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
           ) {
            NSLog(@"--------------------------------------->NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
        }

        
        CCSpriteBatchNode *spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"hpBG.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hpBG.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"defaultBG.jpg"];
        background.scale=1.024;
        [spritesNode addChild:background];
        background.position = ccp(winSize.width/2,winSize.height/2);

        CCSprite *gameHeader = [CCSprite spriteWithFile:@"gameHeader.png"];
        gameHeader.scale=1.0;
        gameHeader.position = ccp(winSize.width/2,winSize.height-[gameHeader contentSize].height+100);
        [self addChild:gameHeader];
        
        CCMenuItem *settingsItem = [CCMenuItemImage itemFromNormalImage:@"menuSettings.png" selectedImage:@"menuSettingsS.png"  target:self selector:@selector(showSettingsPage:)];
        
        CCMenuItem *creditsItem = [CCMenuItemImage itemFromNormalImage:@"menuCredits.png" selectedImage:@"menuCreditsS.png"  target:self selector:@selector(showCreditsPage:)];
        CCMenuItem *rateMeItem = [CCMenuItemImage itemFromNormalImage:@"menuRateMe.png" selectedImage:@"menuRateMeS.png"  target:self selector:@selector(showCreditsPage:)];
        
        CCMenu *settingsMenu = [CCMenu menuWithItems:settingsItem,rateMeItem,creditsItem, nil];
        settingsMenu.position = ccp(700,110);
        [settingsMenu alignItemsHorizontallyWithPadding:0];
        [self addChild:settingsMenu z:3];
        
        
        CCMenuItem *girlsItem = [CCMenuItemImage itemFromNormalImage:@"menuPrincesses.png" selectedImage:@"menuPrincessesS.png" target:self selector:@selector(displayGameSelection:)];
        
        girlsItem.tag=0;
        
        CCMenuItem *boysItem = [CCMenuItemImage itemFromNormalImage:@"menuMonsters.png" selectedImage:@"menuMonstersS.png" target:self selector:@selector(displayGameSelection:)];
        boysItem.tag=1;
        
        CCMenuItem *learnItem = [CCMenuItemImage itemFromNormalImage:@"menuLearn.png" selectedImage:@"menuLearnS.png" target:self selector:@selector(displayGameSelection:)];
        
        learnItem.tag=2;
        
        CCMenu *genderChoiceMenu = [CCMenu menuWithItems:learnItem,girlsItem,boysItem, nil];
        genderChoiceMenu.position = ccp(600,winSize.height/2);
        
        [self addChild:genderChoiceMenu z:99];
        [genderChoiceMenu alignItemsVerticallyWithPadding:0];
        
        
        
        witch = [CCSprite spriteWithSpriteFrameName:@"witch.png"];
        //witch = [CCSprite spriteWithSpriteFrameName:@"witch.png"];
        witch.position = ccp(-100,winSize.height/2);
        //witch.scaleX=-1;
        [spritesNode addChild:witch];
                
        witchEndPosX = -100;

        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Scarywind.mp3" loop:YES];
        [CDAudioManager sharedManager].backgroundMusic.volume =0.1f;
        [self moveWitch:nil];
        [self schedule:@selector(moveWitch:) interval:4];
        		
	}
	return self;
}

-(void) moveWitch:(id)sender{
    witch.scaleX*=-1;
    if (witchEndPosX==-100) {
         witchEndPosX = 1200;
    }
    else{
        witchEndPosX = -100;
    }
    
    witchEndPosY = arc4random()%1024;
    [[SimpleAudioEngine sharedEngine] playEffect:@"WitchNoise.mp3"];
    [witch runAction:[CCMoveTo actionWithDuration:3 position:ccp(witchEndPosX,witchEndPosY)]];
}

-(void)displayGameSelection:(CCMenuItem *) menuItem {
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    if (menuItem.tag==0) {
        [[GameStatus sharedGameStatus]setGameType:@"Girls"];
        [[GameStatus sharedGameStatus]setGameOffset:[NSNumber numberWithInt:0]];
        [[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
    }
    else if (menuItem.tag==1){
        [[GameStatus sharedGameStatus]setGameType:@"Boys"];
        [[GameStatus sharedGameStatus]setGameOffset:[NSNumber numberWithInt:12]];
        [[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
    }
    else if (menuItem.tag==2){
        [[CCDirector sharedDirector] replaceScene:[LearnSelection scene]];
    }
    
    
}

-(void)showSettingsPage:(CCMenuItem *) menuItem {
    
    [[CCDirector sharedDirector] replaceScene:[SettingsPage scene]];

}

-(void)showCreditsPage:(CCMenuItem *) menuItem {
    
    [[CCDirector sharedDirector]replaceScene:[CreditsPage scene]];
    //[[CCDirector sharedDirector] replaceScene:[FinalScene scene]];
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
    [CCTextureCache purgeSharedTextureCache];
	[super dealloc];
}

@end
