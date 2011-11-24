//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "CreditsPage.h"

#define MENU_ITEM_SIZE 60
@implementation CreditsPage
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsPage *layer = [CreditsPage node];
	
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

        CCLabelTTF *credits = [CCLabelTTF labelWithString:@"Programming, Game Design:\nCyril Gaillard" dimensions:CGSizeMake(400,200) alignment:UITextAlignmentCenter fontName:@"Rumpelstiltskin" fontSize:39];
        credits.position = ccp(winSize.width/2+100,winSize.height/2+30);
        [self addChild:credits z:3];
         credits =[CCLabelTTF labelWithString:@"Voice, Creative Consultant:\n Mina Mokhtarani" dimensions:CGSizeMake(400,200) alignment:UITextAlignmentCenter fontName:@"Rumpelstiltskin" fontSize:39];
        credits.position = ccp(winSize.width/2+100,winSize.height/2-100);
        [self addChild:credits z:3];
        credits =[CCLabelTTF labelWithString:@"Dedicated to my lovely\nnieces A. and C. " dimensions:CGSizeMake(400,200) alignment:UITextAlignmentCenter fontName:@"Rumpelstiltskin" fontSize:39];
        credits.position = ccp(winSize.width/2+100,winSize.height/2-220);
        [self addChild:credits z:3];
        
        CCSprite *cocos2d = [CCSprite spriteWithSpriteFrameName:@"cocos2d.png"];
        cocos2d.position =ccp(winSize.width-60,60);
        [spritesNode addChild:cocos2d z:3];
		
	}
	return self;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

	[super dealloc];
}

@end
