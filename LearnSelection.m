//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//
#import "LearnSelection.h"
#import "HomePage.h"
#import "AppDelegate.h"
#import "LearnInterface.h"
#import "GameStatus.h"
//#import "SharedFunctions.h"

#define MENU_ITEM_SIZE 60
@implementation LearnSelection
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LearnSelection *layer = [LearnSelection node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

-(void) displayMenuInGrid:(CCMenu *)menu{
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    NSInteger xPos=-70;
    NSInteger yPos=winSize.height-40;
    NSInteger itemPerRow = 2;
    NSInteger xPadding = 500;
    NSInteger yPadding = 100;
    NSInteger loop=1;   
    for (CCMenuItem* menuItem in menu.children){
        menuItem.position = ccp(xPos,yPos);
        xPos+=xPadding;
        if(loop%itemPerRow == 0){
            xPos=-70;
            yPos-=yPadding;
        }  
        loop++;
    }
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

        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lessonsInfo" ofType:@"plist"];
        
        nameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        CCMenu *learnSelectionM = [CCMenu menuWithItems: nil];
        learnSelectionM.position=ccp(winSize.width/2,winSize.height/2);
        
        for (NSInteger i=0; i<12; i++) {                
        
            NSString* gameName = [[nameDict objectForKey:@"LessonName"] objectAtIndex:i];
            CCLabelBMFont *gameLabel= [CCLabelBMFont labelWithString:gameName fntFile:@"Rumpel80.fnt"];
            
            CCMenuItemLabel *learnItem = [CCMenuItemLabel itemWithLabel:gameLabel target:self selector:@selector(displayLearnGame:)];
            
            learnItem.tag = i;
            [learnSelectionM addChild:learnItem];
        }
        
        [self displayMenuInGrid:learnSelectionM];
        learnSelectionM.position=ccp(winSize.width/2-150,-50);
        [self addChild:learnSelectionM];        
	}
	return self;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

-(void)displayLearnGame:(CCMenuItem *) menuItem {
    NSString *gName = [[nameDict objectForKey:@"LessonName"] objectAtIndex:menuItem.tag];
    [[GameStatus sharedGameStatus]setLessonName:gName];
    [[CCDirector sharedDirector] replaceScene:[LearnInterface scene]];
       
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    /*[CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
	*/// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [nameDict release];
	[super dealloc];
}

@end
