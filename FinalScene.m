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
#import "SimpleAudioEngine.h"

#define MENU_ITEM_SIZE 60
@implementation FinalScene
@synthesize  witch;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	FinalScene *layer = [FinalScene node];
	
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
		winSize = [[CCDirector sharedDirector] winSize];
		
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

        oldBG = [CCSprite spriteWithFile:@"oldBG.jpg"];
        oldBG.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:oldBG z:0 tag:0];
        
        oldTree = [CCSprite spriteWithFile:@"oldTree.png"];
        oldTree.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:oldTree z:1 tag:1];
        
        oldCastle = [CCSprite spriteWithFile:@"oldCastle.png"];
        oldCastle.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:oldCastle z:2 tag:2];
        
       
        
        witch = [CCSprite spriteWithFile:@"witch.png"];
        witch.position = ccp(-100,winSize.height/2);
        witch.scaleX=-1;
        [self addChild:witch z:5];
        //[self moveWitch];

        id witchSeq = [CCSequence actions:[CCCallFuncND actionWithTarget:self
        selector:@selector(moveWitch) data:nil],[CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(killWitch) data:nil], nil];
        
        id backgroundSeq= [CCSequence actions:[CCCallFuncND actionWithTarget:self
        selector:@selector(changeBackground) data:nil],[CCDelayTime actionWithDuration:3],[CCCallFuncND actionWithTarget:self selector:@selector(changeTrees) data:nil],[CCDelayTime actionWithDuration:3],[CCCallFuncND actionWithTarget:self selector:@selector(changeCastle) data:nil], nil ];
        
        [self runAction:[CCSequence actions:witchSeq,[CCDelayTime actionWithDuration:3.0],backgroundSeq,[CCDelayTime actionWithDuration:3], [CCCallFuncND actionWithTarget:self selector:@selector(addBackMenu) data:nil],nil]];
        
       
        

        }
	return self;
}

-(void) moveWitch{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"WitchNoise.mp3"];
    [witch runAction:[CCMoveTo actionWithDuration:2 position:ccp(600,winSize.height/2+200)]];
}

-(void) killWitch{
    [[SimpleAudioEngine sharedEngine] playEffect:@"poof.mp3"];
    [witch runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
    //CCParticleSmoke *witchExplosion= [CCParticleSmoke node];
    CCParticleSmoke *witchExplosion=[CCParticleSmoke node];
    witchExplosion.position=witch.position;
    witchExplosion.scale=4.0;
    witchExplosion.duration = 0.5f;
    witchExplosion.visible=YES;
    [self addChild:witchExplosion z:99];
    
}

-(void)changeBackground{
    //[[SimpleAudioEngine sharedEngine] playEffect:@"yeahYouWon.mp3"];
    [oldBG runAction:[CCFadeTo actionWithDuration:2 opacity:0]];
    CCSprite *newBG = [CCSprite spriteWithFile:@"newBG.jpg"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"birdsNoWater.mp3"];
    newBG.position=oldBG.position;
    CCParticleSystem *explosionSun = [CCParticleExplosion node];
    explosionSun.position=ccp(900,650);
    explosionSun.scale=1;
    explosionSun.life=1;
    [self addChild:explosionSun z:999];
    [[SimpleAudioEngine sharedEngine] playEffect:@"MagicZing.mp3" pitch:1 pan:0 gain:1];
    newBG.opacity=0;
    [self addChild:newBG z:0];
    [newBG runAction:[CCFadeTo actionWithDuration:2 opacity:250]];
    
}
-(void)changeTrees{
    [oldTree runAction:[CCFadeTo actionWithDuration:2 opacity:0]];
    CCSprite *newTree = [CCSprite spriteWithFile:@"newTree.png"];
    newTree.position=oldTree.position;
    [[SimpleAudioEngine sharedEngine] playEffect:@"MagicZing.mp3"];
    newTree.opacity=0;
    CCParticleExplosion* explosion = [CCParticleExplosion node];
    CCParticleExplosion* explosion2 = [CCParticleExplosion node];
    explosion.position=ccp(100,300);
    explosion2.position=ccp(950,300);
    [self addChild:explosion];
    [self addChild:explosion2];
    
    [self addChild:newTree z:3];
    [newTree runAction:[CCFadeTo actionWithDuration:2 opacity:250]];
}
-(void)changeCastle{
    [oldCastle runAction:[CCFadeTo actionWithDuration:2 opacity:0]];
    CCSprite *newCastle = [CCSprite spriteWithFile:@"newCastle.png"];
    newCastle.position=oldCastle.position;
    [[SimpleAudioEngine sharedEngine] playEffect:@"MagicZing.mp3" ];
    newCastle.opacity=0;
    CCParticleSystem *explosionCastle =[CCParticleExplosion node];
    explosionCastle.position=ccp(winSize.width/2,winSize.height/2);
    explosionCastle.scale=4;
    [self addChild:explosionCastle];
    [self addChild:newCastle z:1];
    [newCastle runAction:[CCFadeTo actionWithDuration:4 opacity:250]];
}

-(void)addBackMenu{
    CCMenuItem *itemBackArrow = [CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage:@"backArrow.png" target: self selector: @selector(goHomePage)];
    
    NSInteger arrowWidth = [itemBackArrow contentSize].width;
    NSInteger arrowHeight = [itemBackArrow contentSize].height;
    CCMenu *backHomeMenu = [CCMenu menuWithItems:itemBackArrow, nil];
    backHomeMenu.position = ccp(arrowWidth/2,winSize.height-arrowHeight/2);
    [self addChild:backHomeMenu z:6];

}

-(void)goHomePage
{
    [[CCDirector sharedDirector ] replaceScene:[HomePage scene]];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{   [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

	[super dealloc];
}

@end
