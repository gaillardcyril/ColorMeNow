//
//  GameSelection.m
//  ColorMeNow
//
//  Created by Cyril Gaillard on 22/05/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "GameSelection.h"
#import "HomePage.h"
#import "PlayingInterface.h"
#import "FinalScene.h"

#import "ColorMeNowIAPHelper.h"
#import "GameStatus.h"



@implementation GameSelection
@synthesize emitter;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameSelection *layer = [GameSelection node];
	
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
        
        winSize = [[CCDirector sharedDirector] winSize];
         freeGames = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:6],[NSNumber numberWithInt:9],[NSNumber numberWithInt:11],nil];
        [freeGames retain];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        CCMenuItem *itemBackArrow = [CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage:@"backArrow.png" target: self selector: @selector(goBackHome:)];
        
		CCMenu *backHomeMenu = [CCMenu menuWithItems:itemBackArrow, nil];
		backHomeMenu.position = ccp([itemBackArrow contentSize].width/2,winSize.height-[itemBackArrow contentSize].height/2);
		[self addChild:backHomeMenu z:2];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        CCSpriteBatchNode *backgroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"Shelf.pvr.ccz"];
        [self addChild:backgroundBatch];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Shelf.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"SelectionShelf.jpg"];
        background.scale=1.17;
        [backgroundBatch addChild:background];
        background.position = ccp(winSize.width/2,winSize.height/2);
                                
        
        CCSpriteBatchNode *spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"characters.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"characters.plist"];
        
        gameSelection = [CCMenu menuWithItems: nil];
        gameSelection.position=ccp(winSize.width/2,winSize.height/2);
         
    
        gamePurchased = [[GameStatus sharedGameStatus] gamePurchased];
        frameOffset=[[[GameStatus sharedGameStatus] gameOffset] intValue];
        
        NSInteger thumbWidth;
        NSString *thumbFrameName;
        
        for (NSInteger i=1; i<=12; i++) {
            
            NSString *gameName = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameName"] objectAtIndex:i+frameOffset-1];
            
            thumbFrameName = [NSString stringWithFormat:@"%@.png",gameName];
            
            CCSprite *gameThumb = [CCSprite spriteWithSpriteFrameName:thumbFrameName];
    
            NSNumber *displayRatio =[NSNumber numberWithFloat:[[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"DisplayRatio"]objectAtIndex:i-1+frameOffset]floatValue]];
            
            gameThumb.scale = [displayRatio floatValue];
            
            thumbWidth = [gameThumb contentSize].width*gameThumb.scale;
            [gameThumb setContentSize:CGSizeMake(thumbWidth,330)];
            
            CCMenuItemSprite *gameThumbItem = [CCMenuItemSprite itemFromNormalSprite:gameThumb selectedSprite:nil target:self selector:@selector(displayGame:)];
            
            gameThumbItem.tag = i;
            if (!gamePurchased && ![freeGames containsObject:[NSNumber numberWithInt:i-1]]) {
                NSString *buttonName = [[[GameStatus sharedGameStatus]gameType]stringByAppendingString:@"BuyButton.png"];
                CCSprite *buyButt=[CCSprite spriteWithSpriteFrameName:buttonName];
                buyButt.scale=0.65;
                [gameThumbItem addChild:buyButt z:99];
                buyButt.position = ccp(thumbWidth/2,115);
            }
              
            
            [gameSelection addChild:gameThumbItem];
        }
        
        emitter = [CCParticleSystemQuad particleWithFile:@"flower.plist"];
        emitter.visible=NO;
        [self addChild: emitter z:999];
        
        [self displayMenuInGrid:gameSelection];
        
         [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
          
        NSRange contentRange = NSMakeRange([[[GameStatus sharedGameStatus] gameOffset] intValue], 12);
        NSArray *gameCompleted = [[[[GameStatus sharedGameStatus] gameStatusList]objectForKey:@"GameCompleted"] subarrayWithRange:contentRange];
        //CCLOG(@"The array is %@",gameCompleted);
        NSInteger sum=0;
        for (NSNumber *item in gameCompleted) {
            sum+=[item intValue];
        }
        if (sum==6 && ![[GameStatus sharedGameStatus] endScenePlayed]) {
            gameSelection.isTouchEnabled=NO;
            [self performSelector:@selector(showFinalScene) withObject:nil afterDelay:4.0f];
        }
	}
	return self;
}


-(void) showFinalScene{
    [[GameStatus sharedGameStatus] updateEndScenePlayed];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[FinalScene scene] withColor:ccc3(0,0,0)] ];

}
-(void) displayMenuInGrid:(CCMenu *)menu{
    
    NSInteger xPos=160;
    NSInteger yPos=winSize.height-80;
    NSInteger itemPerRow = 4;
    NSInteger xPadding = 250;
    NSInteger yPadding = 250;
        
    for (CCMenuItem* menuItem in menu.children){
        menuItem.position = ccp(xPos,yPos);
        xPos+=xPadding;
        if(menuItem.tag%itemPerRow == 0){
            xPos=120;
            yPos-=yPadding;
        }
     
    CCSprite *spiderWeb = [CCSprite spriteWithFile:@"SpiderWeb.png"];
        spiderWeb.scale=0.65;
    spiderWeb.position = ccp([menuItem contentSize].width/2,[menuItem contentSize].height/2-40);
        
    NSInteger currentItemPreviousStatus  =[[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompletedPrevious"] objectAtIndex:menuItem.tag-1+frameOffset] intValue];
    NSInteger currentItemCurrentStatus = [[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"] objectAtIndex:menuItem.tag-1+frameOffset] intValue];
               
    if ([[GameStatus sharedGameStatus] firstTimePlayed]){
        gameSelection.isTouchEnabled=NO;
    spiderWeb.scale=0.1;
    [menuItem addChild:spiderWeb];
    [spiderWeb runAction:[CCScaleTo actionWithDuration:3.5 scale:0.65]];
}
                
        else if (!currentItemCurrentStatus && !currentItemPreviousStatus ) {
            [menuItem addChild:spiderWeb];
        }
        else if(currentItemCurrentStatus && !currentItemPreviousStatus){
            [menuItem addChild:spiderWeb]; 
            emitter.visible=YES;
            emitter.position = [menu getChildByTag:menuItem.tag].position;
            [spiderWeb runAction:[CCFadeOut actionWithDuration:2]];
            [[SimpleAudioEngine sharedEngine] playEffect:@"MagicZing.mp3"];
            NSMutableArray *tempGameStatus = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompletedPrevious"]]; 
            
           [tempGameStatus replaceObjectAtIndex:(menuItem.tag-1+frameOffset) withObject:[NSNumber numberWithInt:1]]; 
            
            [[[GameStatus sharedGameStatus] gameStatusList] setObject:tempGameStatus forKey:@"GameCompletedPrevious"];

            [[GameStatus sharedGameStatus] updatePListFile ];
            [tempGameStatus release];                        
        }
    }
    menu.position=ccp(0,-20);
    [self addChild:menu];
    if ([[GameStatus sharedGameStatus]firstTimePlayed]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"swish2.mp3" pitch:1 pan:0 gain:0.3];
        [self performSelector:@selector(playMinaTapWeb) withObject:nil afterDelay:4.5];
        [self playOhNoSound ];
        
    }
}

-(void)playOhNoSound{
    NSString *ohNoStr = [@"ohNo" stringByAppendingFormat:@"%@.mp3",[[GameStatus sharedGameStatus]gameType]];
    //CCLOG(@"The string is %@",ohNoStr);
    [[SimpleAudioEngine sharedEngine] playEffect:ohNoStr ];
    
}
-(void)playMinaTapWeb{
    [[SimpleAudioEngine sharedEngine] playEffect:@"TapWeb.mp3"];
    gameSelection.isTouchEnabled=YES;
}

-(void)displayGame:(CCMenuItem *) menuItem {
    
    if (!gamePurchased && ![freeGames containsObject:[NSNumber numberWithInt:menuItem.tag-1]]) {
        if (![[[ColorMeNowIAPHelper sharedHelper] buyRequestInProgress] intValue]) {
            [self buyAllCharacters];
        }
    }
    else{
        [[GameStatus sharedGameStatus]setGameName:[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameName"]objectAtIndex:(menuItem.tag-1+frameOffset)]];
        [[GameStatus sharedGameStatus]setGameIndex:[NSNumber numberWithInt:menuItem.tag-1+frameOffset]];
        [[CCDirector sharedDirector] replaceScene:[PlayingInterface scene]];        
    }
}

-(void)buyAllCharacters {
    
    if ([[ColorMeNowIAPHelper sharedHelper].productsRqstSuccessFul  intValue]) {
        SKProduct *product; 
        if ([[[GameStatus sharedGameStatus] gameType] isEqualToString:@"Boys"]) {
            product = [[ColorMeNowIAPHelper sharedHelper].products objectAtIndex:0];
        }
        else{
            product = [[ColorMeNowIAPHelper sharedHelper].products objectAtIndex:1];
        }
        [[ColorMeNowIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    } 
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Store Connection Error" 
                                                        message:@"Cannot connect to the App Store"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
    [freeGames release];
    //CCLOG(@"calling dealloc");
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
}

@end

