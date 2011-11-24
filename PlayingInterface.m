//
//  HelloWorldLayer.m
//  ColorMeNow
//
//  Created by Cyril Gaillard on 16/05/11.
//  Copyright Voila Design 2011. All rights reserved.
//

// Import the interfaces
#import "PlayingInterface.h"
#import "GameSelection.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "GameStatus.h"

@implementation PlayingInterface
@synthesize pickedIndexes, pickedRdmIdx;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayingInterface *layer = [PlayingInterface node];
	
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
	if( (self=[super init])) {
		
		// ask director the the window size
		winSize = [[CCDirector sharedDirector] winSize];
        
              
  alphabet = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
        [alphabet retain];
  numbers = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
        [numbers retain];  
  colors = [NSArray arrayWithObjects:@"000000",@"A37F46",@"1631A3",@"33FF3D",@"BCBCBC",@"B4E9FC",@"FCD24C",@"FCC8D2",@"FF0000",@"FFFFFF",@"FFFF00",nil];
        [colors retain];
  colorsSounds =[NSArray arrayWithObjects:@"black.mp3",@"brown.mp3", @"darkblue.mp3",@"green.mp3",@"gray.mp3",@"lightblue.mp3",@"orange.mp3",@"pink.mp3",@"red.mp3",@"white.mp3",@"yellow.mp3",nil];
        [colorsSounds retain];
   shapes = [NSArray arrayWithObjects:@"circle",@"rectangle",@"square",@"triangle",@"star",@"polygon",@"diamond",@"heart",nil];
  [shapes retain];
    weather = [NSArray arrayWithObjects:@"drizzle",@"moon",@"rainbow",@"rainshower",@"snow",@"sun",@"thunderstorm",@"tornado",@"wind",nil];
        [weather retain];
        
        animals = [[NSMutableArray alloc] init];
        [self fillArray:animals withString:@"Animals" itemCount:14];
        fishes = [[NSMutableArray alloc] init];
        [self fillArray:fishes withString:@"Fishes" itemCount:11];
        insects = [[NSMutableArray alloc] init];
        [self fillArray:insects withString:@"Insects" itemCount:11];
        instruments = [[NSMutableArray alloc] init];
        [self fillArray:instruments withString:@"Instruments" itemCount:10];
        sports = [[NSMutableArray alloc] init];
        [self fillArray:sports withString:@"Sports" itemCount:10];
        transports= [[NSMutableArray alloc] init];
        [self fillArray:transports withString:@"Transports" itemCount:13];
        pickedIndexes = [[NSMutableArray alloc] init]; 
        pickedRdmIdx = [[NSMutableArray alloc] init];
            
        NSString *gameN= [[NSString alloc]initWithString:[[GameStatus sharedGameStatus] gameName]]; 
        
        idxGame = [[[GameStatus sharedGameStatus] gameIndex] intValue];
        //CCLOG(@"the game index is %d",idxGame);
        
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
        //Display the Background
        NSString *bgName = [gameN stringByAppendingString:@"BG.jpg"];

        /*CCSpriteBatchNode *backgroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"hpBG.pvr.ccz"];
        [self addChild:backgroundBatch];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hpBG.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"defaultBG.jpg"];
        [backgroundBatch addChild:background];*/
        CCSprite *background = [CCSprite spriteWithFile:bgName];
        background.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:background];
        //Display the reset button 
        CCMenuItem *itemRstButton = [CCMenuItemImage itemFromNormalImage:@"PauseButton.png" selectedImage:nil target: self selector: @selector(showPausePage:)];
        
        NSInteger buttonWidth = [itemRstButton contentSize].width;
        NSInteger buttonHeight = [itemRstButton contentSize].height;
		rstGameMenu = [CCMenu menuWithItems:itemRstButton, nil];
        
        //The reset button is flushed to top left corner 
		rstGameMenu.position = ccp(winSize.width-buttonWidth/2,winSize.height-buttonHeight/2);
		[self addChild:rstGameMenu z:2];
                
        //Display the reset button 
        CCMenuItem *repeatButton = [CCMenuItemImage itemFromNormalImage:@"Repeat.png" selectedImage:nil target: self selector: @selector(playMinaSound)];
        
        buttonWidth = [repeatButton contentSize].width;
        buttonHeight = [repeatButton contentSize].height;
		CCMenu *repeatMenu = [CCMenu menuWithItems:repeatButton, nil];
        
        //The reset button is flushed to top left corner 
		repeatMenu.position = ccp(winSize.width-buttonWidth/2,buttonHeight/2+60);
		[self addChild:repeatMenu z:50];
                
        answerSigns = [CCSprite spriteWithFile:@"AnswerBoard.png"];
        CCSprite *nameSign = [CCSprite spriteWithFile:@"nameSign.png"];
        nameSign.position = ccp(winSize.width/2,winSize.height-[nameSign contentSize].height/2);
        [self addChild:nameSign];
        
        NSString *pListName = [gameN stringByAppendingString: @"Coord"];
        //Read the plist containing the coordinates of all the body parts
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
        spriteCoordinates = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        //Read the name of the game from the singleton 
        
        //CCLOG(@"the name of the game is %@",gameN);
        CCLabelTTF *gameNLabel = [CCLabelTTF labelWithString:gameN fontName:@"Rumpelstiltskin" fontSize:78];
        gameNLabel.position = ccp(winSize.width/2+25,winSize.height-80);
        gameNLabel.opacity=120;
        gameNLabel.color=ccc3(0,0,0);
        [self addChild:gameNLabel z:0];
        
        /*Change the pixel format to match the spritesheet one*/
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        /*Load the spritesheet*/
        NSString *batchName = [gameN stringByAppendingString:@".pvr.ccz"];
        CCSpriteBatchNode *spritesNode = [CCSpriteBatchNode batchNodeWithFile:batchName];
        [self addChild:spritesNode];
        pListName = [gameN stringByAppendingString:@".plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:pListName];
        
        /* Initialize the nsmutable array*/
        spriteArray = [[NSMutableArray alloc] init];
        frameNameArray = [[NSMutableArray alloc] init ];
        
        /*Load the star explosion and make it invisible*/
        NSString *emitterName;
        NSString *gameT = [[GameStatus sharedGameStatus] gameType];
        if ([gameT isEqualToString:@"Boys"]) {
            emitterName = @"cloud.plist";
            fxName=@"poof.mp3";
        }
        else{
            emitterName = @"flower.plist";
            fxName=@"MagicZing.mp3";
        }
        
        emitter = [CCParticleSystemQuad particleWithFile:emitterName];
        
        emitter.visible = NO;
        [self addChild: emitter z:30];
 
        /* place on the interface all the body parts*/
        for (NSInteger i=0; i<[[spriteCoordinates objectForKey:@"Xcoordinates"]count]; i++) {
            NSString *frameName = [[spriteCoordinates objectForKey:@"FrameName"]objectAtIndex:i];
    
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:frameName];
            sprite.tag=i;
            CGFloat spriteXPos = [[[spriteCoordinates objectForKey:@"Xcoordinates"]objectAtIndex:i]floatValue];
            CGFloat spriteYPos = [[[spriteCoordinates objectForKey:@"Ycoordinates"]objectAtIndex:i]floatValue];
            sprite.position=ccp(spriteXPos,spriteYPos);            
            [spriteArray addObject:sprite ];                        
        }
        NSInteger i=0;
        for (CCSprite *tempSprite in spriteArray){
            if (i==0) {

                if ([gameN isEqualToString:@"Bella"])
                    [spritesNode addChild:tempSprite];
                else
                    [spritesNode addChild:tempSprite z:10];
            }
            else
                [spritesNode addChild:tempSprite];
            i++;
        } 
        [gameN release];                       
        adViewPresent=NO; 
        /*shuffle the array so the right answer is not always at the same spot*/
        /*Initialize the number of iterations*/
        numberOfIterations = 1;
        /*Initialize the score*/
        score = 0; 
        self.isTouchEnabled=NO;
        
        if ([[GameStatus sharedGameStatus]firstTimePlayed]){
            instructionsLayer =[CCNode node];
            [self addChild:instructionsLayer z:200];
            rstGameMenu.isTouchEnabled=NO;
            /*If 1st time played, say the instructions*/
            [self runAction:[CCSequence actions:[CCCallFuncN actionWithTarget:self selector:@selector(saySignInstructions)],[CCDelayTime actionWithDuration:3],[CCCallFuncN actionWithTarget:self
        selector:@selector(sayRepInstructions)],[CCDelayTime actionWithDuration:2.5],[CCCallFuncN actionWithTarget:self
        selector:@selector(sayPushStart)], nil]];
            /*Update the plist file*/
            [[[GameStatus sharedGameStatus] gameStatusList] setObject:[NSNumber numberWithInt:0] forKey:[[GameStatus sharedGameStatus] firstTimePlayedStr]];            
            [[GameStatus sharedGameStatus] updatePListFile];            
        }
        else{
            [self startPlaying];
        }
}
	return self;
}


-(void)fillArray:(NSMutableArray *)array withString:(NSString *)lessonName itemCount:(NSInteger)count{
    
    for(NSInteger i=0;i<count;i++){
        NSString *lessonItem = [NSString stringWithFormat:@"%@%02d",lessonName,i];
        [array addObject:lessonItem];
    }
}
-(void)saySignInstructions{
    id flashingSprite = [CCSequence actions:
                         [CCFadeOut actionWithDuration: 0.4],					 
                         [CCFadeIn actionWithDuration: 0.4],					  
                         nil];

    [[SimpleAudioEngine sharedEngine] playEffect:@"listenToMe.mp3"];
    CCSprite *instrSign=[CCSprite spriteWithFile:@"instructionsSign.png"];
    instrSign.position=ccp(100,winSize.height/2);
    [instructionsLayer addChild:instrSign];
    [instrSign runAction:[CCRepeat actionWithAction:flashingSprite times:4]];
}

-(void)sayRepInstructions{
    id flashingSprite = [CCSequence actions:
                         [CCFadeOut actionWithDuration: 0.4],					 
                         [CCFadeIn actionWithDuration: 0.4],					  
                         nil];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"TapRepeat.mp3"];
    CCSprite *instrSign=[CCSprite spriteWithFile:@"instructionsRepeat.png"];
    instrSign.position=ccp(winSize.width-200,250);
    [instructionsLayer addChild:instrSign];
    [instrSign runAction:[CCRepeat actionWithAction:flashingSprite times:4]];

}
-(void)sayPushStart{
    id flashingSprite = [CCSequence actions:
                         [CCFadeOut actionWithDuration: 0.4],					 
                         [CCFadeIn actionWithDuration: 0.4],					  
                         nil];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"TapHereToStart.mp3"];
    CCMenuItemImage *instrSign=[CCMenuItemImage itemFromNormalImage:@"instructionsStart.png" selectedImage:nil  target: self selector: @selector(removeInstrLayer)];
    CCMenu *startMenu = [CCMenu menuWithItems:instrSign, nil]; 
    startMenu.position=ccp(winSize.width/2,winSize.height/2);
    [instructionsLayer addChild:startMenu z:200];
    [startMenu runAction:[CCRepeat actionWithAction:flashingSprite times:4]];
}

-(void) removeInstrLayer{
    [self removeChild:instructionsLayer cleanup:YES];
    [self startPlaying];
}

-(void)onEnter{
    [super onEnter];
    NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    //NSLog(@"the country is %@",countryCode);
    NSString *bgMusic = [[[[GameStatus sharedGameStatus] gameStatusList ] objectForKey:@"BGSound"] objectAtIndex:idxGame];    
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:bgMusic];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.1f;

    NSString *purchaseStr = [[[GameStatus sharedGameStatus]gameType] stringByAppendingString:@"Purchased"];
    
    if (![[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:purchaseStr]intValue] ) {
        if ([countryCode isEqualToString:@"US"] && !adViewPresent) {
            [self addBannerView];
        }
    }
    else{
        if (adViewPresent) {
            [adView removeFromSuperview];
            adViewPresent=NO;
        }
        
    }
}

-(void) addBannerView{
    adViewPresent=YES;
    adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
    adView.delegate=self;
    adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape,ADBannerContentSizeIdentifierLandscape, nil];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [[[CCDirector sharedDirector]openGLView]addSubview:adView];
    CGSize windowSize =[[CCDirector sharedDirector]winSize];
    adView.center = CGPointMake(windowSize.width/2,windowSize.height-34 );
    adView.hidden=YES;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    adView.hidden=NO;
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    adView.hidden=YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    [[UIApplication sharedApplication]setStatusBarOrientation:[[CCDirector sharedDirector]deviceOrientation]];
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}    

-(void)startPlaying
{
    rstGameMenu.isTouchEnabled=YES;
    /*we need to remove the three letters from the screen for the next iterations*/
    if (numberOfIterations > 1)
    {
        [self removeChild:lettersMenu cleanup:YES];
        lettersMenu=nil;
    }
    /*Condition on the number of iterations. */
    if (numberOfIterations < [[spriteCoordinates objectForKey:@"Xcoordinates"]count]) {
    //if (numberOfIterations < 3){
        lettersMenu = [CCMenu menuWithItems:nil];
        randomIdx = floor(arc4random()%3);
        //randomIdx=0;
        /*Pick 3 letters randomly*/
        for (NSInteger i=0; i<3; i++) {
            
            CCMenuItem *ansSign = [CCMenuItemImage itemFromNormalImage:@"AnswerBoard.png" selectedImage:nil target:self selector:@selector(colorSprite:)];
            switch (idxGame) {
                case 0:
                case 12:    
                    //CCLOG(@"I am case 0 or 6");
                    [self placeLetters:ansSign withIndex:i withGameType:0];
                    break;
                case 1:
                case 13:    
                    //CCLOG(@"I am case 0 or 6");
                    [self placeNumbers:ansSign withIndex:i];
                    break;    
                case 2:
                case 14:
                    //CCLOG(@"I am case 2 or 7");
                    [self placeLetters:ansSign withIndex:i withGameType:1];
                    break;
                case 3:
                case 15:
                    [self placeColors:ansSign withIndex:i];
                    break;
                case 4:
                case 16:
                    [self placeShapes:ansSign withIndex:i];
                    break;
                case 5:
                case 17:
                    [self placeWeather:ansSign withIndex:i];
                    break;
                case 6:
                case 18:
                    [self placeLessonItem:ansSign withIndex:i withArray:animals];
                    break;
                    
                case 7:
                case 19:
                    [self placeLessonItem:ansSign withIndex:i withArray:transports];
                    break;
   
                case 8:
                case 20:
                    [self placeLessonItem:ansSign withIndex:i withArray:insects];
                    break;

                case 9:
                case 21:
                    [self placeLessonItem:ansSign withIndex:i withArray:sports];
                    break;
                    
                case 10:
                case 22:
                    [self placeLessonItem:ansSign withIndex:i withArray:instruments];
                    break;

                case 11:
                case 23:
                    [self placeLessonItem:ansSign withIndex:i withArray:fishes];
                    break;
                    
                    
                default:
                    break;
            }

            ansSign.tag = i;
            /*Place the letter on the screen*/
             [lettersMenu addChild:ansSign];
            
        }
        [pickedRdmIdx removeAllObjects];
        lettersMenu.position=ccp(-300,winSize.height/2+20);
        [lettersMenu alignItemsVertically];
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
        [self addChild:lettersMenu];
        
        [lettersMenu runAction:[CCSequence actions:[CCMoveBy actionWithDuration:2 position:ccp(400,0 )],[CCCallFuncN actionWithTarget:self selector:@selector(playMinaSound)],nil]];
        lettersMenu.isTouchEnabled=YES;
    }
    else{
        [self gameEnded];
    }    
}


-(void) playMinaSound{
    NSString *soundToPlay;
    switch (idxGame) {
        case 0:
        case 12:    
            //CCLog(@"debug");
            soundToPlay = [[alphabet objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"] ;
        
            break;
        case 1:
        case 13:    
            soundToPlay = [[numbers objectAtIndex:idxCorrectAns]stringByAppendingString:@".mp3"];
            break;    
        case 2:
        case 14:
             soundToPlay = [[alphabet objectAtIndex:idxCorrectAns]stringByAppendingString:@".mp3"];
            
            break;
        case 3:
        case 15:
            soundToPlay = [colorsSounds objectAtIndex:idxCorrectAns];
            break;
        case 4:
        case 16:
            soundToPlay = [[shapes objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break;
        case 5:
        case 17:
           soundToPlay = [[weather objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break;
        case 6:
        case 18:
            soundToPlay = [[animals objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break; 
        case 7:
        case 19:
            soundToPlay = [[transports objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break;
        case 8:
        case 20:
            soundToPlay = [[insects objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break;
        case 9:
        case 21:
            soundToPlay = [[sports objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break; 
        case 10:
        case 22:
            soundToPlay = [[instruments objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break; 
        case 11:
        case 23:
            soundToPlay = [[fishes  objectAtIndex:idxCorrectAns] stringByAppendingString:@".mp3"];
            break;     
        default:
            soundToPlay = @"4.mp3";
            break;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:soundToPlay];

}

-(void)placeNumbers:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex{
    CCLabelTTF *letterStr;
    //NSInteger idxCorrectAns;
    NSInteger idxWrongAns;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([numbers count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        letterStr = [CCLabelTTF labelWithString:[numbers objectAtIndex:idxCorrectAns] fontName:@"Rumpelstiltskin" fontSize:150];               
    }
    else{
        do {
            idxWrongAns = arc4random()%([numbers count]);
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        letterStr = [CCLabelTTF labelWithString:[numbers objectAtIndex:idxWrongAns] fontName:@"Rumpelstiltskin" fontSize:150];        
    }    
    letterStr.position=ccp([gameMenuItem contentSize].width/2+40,[gameMenuItem contentSize].height/2-10);
    letterStr.color=ccc3(0,0,0);
    if ([pickedIndexes count] >= ([numbers count]-2))[pickedIndexes removeAllObjects];
    [gameMenuItem addChild:letterStr];  
}

-(void)placeColors:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex{
    CCSprite *colorSign=[CCSprite spriteWithFile:@"whiteBoard.png"];
    //NSInteger idxCorrectAns;
    NSInteger idxWrongAns;
    NSString *colorToDisplay;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([colors count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        colorToDisplay= [colors objectAtIndex:idxCorrectAns];       
    }
    else{
        do {
            idxWrongAns = arc4random()%([colors count]);
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        colorToDisplay= [colors objectAtIndex:idxWrongAns];
    }    
    colorSign.position=ccp([gameMenuItem contentSize].width/2+45,[gameMenuItem contentSize].height/2+7);
    
    NSScanner *scanner;
    unsigned int bytes;        
    scanner = [NSScanner scannerWithString: colorToDisplay];
    [scanner scanHexInt: &bytes];        
    GLubyte r	= bytes >> 16 & 0xFF;
    GLubyte g	= bytes >> 8 & 0xFF;
    GLubyte b	= bytes & 0xFF;
    
    colorSign.color=ccc3(r,g,b);
    if ([pickedIndexes count] >= ([colors count]-2))[pickedIndexes removeAllObjects];
    [gameMenuItem addChild:colorSign];
}
-(void)placeShapes:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex{
    
    //NSInteger idxCorrectAns;
    NSInteger idxWrongAns;
    NSString *shapeToDisplay;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([shapes count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        shapeToDisplay= [[shapes objectAtIndex:idxCorrectAns]stringByAppendingString:@".png"];       
    }
    else{
        do {
            idxWrongAns = arc4random()%([shapes count]);
            CCLOG(@"picking wrong answer");
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        shapeToDisplay= [[shapes objectAtIndex:idxWrongAns] stringByAppendingString:@".png"];
    } 
    CCSprite *shapeSign = [CCSprite spriteWithFile:shapeToDisplay];
    shapeSign.position=ccp([gameMenuItem contentSize].width/2+45,[gameMenuItem contentSize].height/2+5);
    if ([pickedIndexes count] >= ([shapes count]-2))[pickedIndexes removeAllObjects];
    
    [gameMenuItem addChild:shapeSign];
}

-(void)placeWeather:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex{
    
    //NSInteger idxCorrectAns;
    NSInteger idxWrongAns;
    NSString *shapeToDisplay;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([weather count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        shapeToDisplay= [[weather objectAtIndex:idxCorrectAns] stringByAppendingString:@".png"];       
    }
    else{
        do {
            idxWrongAns = arc4random()%([weather count]);
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        shapeToDisplay= [[weather objectAtIndex:idxWrongAns] stringByAppendingString:@".png"];
    } 
    CCSprite *shapeSign = [CCSprite spriteWithFile:shapeToDisplay];
    shapeSign.position=ccp([gameMenuItem contentSize].width/2+45,[gameMenuItem contentSize].height/2+5);
    if ([pickedIndexes count] >= ([weather count]-2))[pickedIndexes removeAllObjects];
    
    [gameMenuItem addChild:shapeSign];
}

-(void)placeLessonItem:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex withArray:(NSMutableArray *)lessonArray{
    
    //NSInteger idxCorrectAns;
    NSInteger idxWrongAns;
    NSString *shapeToDisplay;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([lessonArray count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        shapeToDisplay= [[lessonArray objectAtIndex:idxCorrectAns] stringByAppendingString:@".png"]; 
        //NSLog(@"the shape to display is %@",shapeToDisplay);
    }
    else{
        do {
            idxWrongAns = arc4random()%([lessonArray count]);
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        shapeToDisplay= [[lessonArray objectAtIndex:idxWrongAns] stringByAppendingString:@".png"];
        //NSLog(@"the shape to display is %@",shapeToDisplay);
    } 
    CCSprite *shapeSign = [CCSprite spriteWithFile:shapeToDisplay];
    shapeSign.position=ccp([gameMenuItem contentSize].width/2+45,[gameMenuItem contentSize].height/2+5);
    if ([pickedIndexes count] >= ([lessonArray count]-2))[pickedIndexes removeAllObjects];
    
    [gameMenuItem addChild:shapeSign];
}

-(void)placeLetters:(CCMenuItem *)gameMenuItem withIndex:(NSInteger)itemIndex withGameType:(NSInteger)gameType{
    CCLabelTTF *letterStr;
    
    NSInteger idxWrongAns;
    if (itemIndex==randomIdx){
        do {
            idxCorrectAns = arc4random()%([alphabet count]);
        }while ([pickedIndexes containsObject:[NSNumber numberWithInt:idxCorrectAns]]||
                [pickedRdmIdx containsObject:[NSNumber numberWithInt:idxCorrectAns]]);
        [pickedIndexes addObject:[NSNumber numberWithInt:idxCorrectAns]];
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxCorrectAns]];
        NSString *letterPicked = [alphabet objectAtIndex:idxCorrectAns];
        if (gameType) {
            letterStr = [CCLabelTTF labelWithString:letterPicked fontName:@"Rumpelstiltskin" fontSize:140];
        }
        else{
        letterStr = [CCLabelTTF labelWithString:[letterPicked lowercaseString] fontName:@"Rumpelstiltskin" fontSize:140];
        }        
    }
    else{
        do {
            idxWrongAns = arc4random()%([alphabet count]);
        }while ([pickedRdmIdx containsObject:[NSNumber numberWithInt:idxWrongAns]]);
        [pickedRdmIdx addObject:[NSNumber numberWithInt:idxWrongAns]];
        if (gameType) {
        letterStr = [CCLabelTTF labelWithString:[alphabet objectAtIndex:idxWrongAns] fontName:@"Rumpelstiltskin" fontSize:140];
        }
        else{
            letterStr = [CCLabelTTF labelWithString:[[alphabet objectAtIndex:idxWrongAns]lowercaseString] fontName:@"Rumpelstiltskin" fontSize:140];
        }
        
    }
    if (gameType){
        letterStr.position=ccp([gameMenuItem contentSize].width/2+40,[gameMenuItem contentSize].height/2-10);}
    else{
        letterStr.position=ccp([gameMenuItem contentSize].width/2+40,[gameMenuItem contentSize].height/2+10);
    }
    letterStr.color=ccc3(0,0,0);
    if ([pickedIndexes count] >= [alphabet count])[pickedIndexes removeAllObjects];
    [gameMenuItem addChild:letterStr];

}
-(void) gameEnded
{
    [self removeChild:lettersMenu cleanup:YES];
    NSInteger numberOfQsts = [[spriteCoordinates objectForKey:@"Xcoordinates"]count];
    NSInteger ratio  = floor(100*(float)score/(float)numberOfQsts);
    //CCLOG(@"the score is %d ratio is %d and number %d",score, ratio,numberOfQsts);
    if (ratio > 75){
        NSMutableArray *tempGameStatus = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"]];
        NSInteger idxGameStatus = [[[GameStatus sharedGameStatus] gameIndex] intValue];
        
        //CCLOG(@"the index is %d",idxGameStatus);
        [tempGameStatus replaceObjectAtIndex:idxGameStatus withObject:[NSNumber numberWithInt:1]];
        //CCLOG(@"the array is %@ and the index is %d",tempGameStatus,idxGameStatus);
        [[[GameStatus sharedGameStatus] gameStatusList] setObject:tempGameStatus forKey:@"GameCompleted"];
        [[GameStatus sharedGameStatus] updatePListFile];
        [tempGameStatus release];
        
    }
    else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"ohohTry.mp3" pitch:1.0f pan:0.0f gain:0.7f ];
    }
    [self performSelector:@selector(showSelectionPage) withObject:nil afterDelay:3.0f];
}

-(void)colorSprite:(CCMenuItem *) menuItem {
    lettersMenu.isTouchEnabled=NO;
    if(menuItem.tag == randomIdx){
        //CCLOG(@"the current score is %d", score);
        CCSprite *spriteToColor = [spriteArray objectAtIndex:numberOfIterations];
        NSString *frameColor = [[spriteCoordinates objectForKey:@"FrameColor"] objectAtIndex:numberOfIterations];
        //NSLog(@"index is %d and color String %@",numberOfIterations,frameColor);
        emitter.visible=YES;
        emitter.position = spriteToColor.position;
        [emitter resetSystem];
        
        NSScanner *scanner;
        unsigned int bytes;        
        scanner = [NSScanner scannerWithString: frameColor];
        [scanner scanHexInt: &bytes];        
        GLubyte r	= bytes >> 16 & 0xFF;
        GLubyte g	= bytes >> 8 & 0xFF;
        GLubyte b	= bytes & 0xFF;
        
        score++;
        [spriteToColor runAction:[CCTintTo actionWithDuration:1 red:r green:g blue:b]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:fxName];
    }
    else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"wrongAnswer.mp3"];
    }
    numberOfIterations++;
    [lettersMenu runAction:[CCSequence actions:[CCMoveBy actionWithDuration:1 position:ccp(-400,0 )],[CCCallFuncN actionWithTarget:self selector:@selector(startPlaying)],nil]];
}

- (void) showPausePage: (CCMenuItem *) menuItem
{	
    CGSize size= [[CCDirector sharedDirector] winSize];
    rstGameMenu.isTouchEnabled=NO;
    lettersMenu.isTouchEnabled=NO;
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
    pauseLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 200)];
    [self addChild:pauseLayer z:99];
	//[[CCDirector sharedDirector] pushScene:[PausePage scene]];
    CCMenuItemImage *menuItemResetGame =[CCMenuItemImage itemFromNormalImage:@"resetButton.png" selectedImage: @"resetButton.png" target:self selector:@selector(resetGame:)];
    
    CCMenuItemImage *menuItemLevelSelGame =[CCMenuItemImage itemFromNormalImage:@"levelSelButton.png" selectedImage: @"levelSelButton.png" target:self selector:@selector(showSelectionPage)];
    
    CCMenuItemImage *menuItemContinueGame =[CCMenuItemImage itemFromNormalImage:@"continueButton.png" selectedImage: @"continueButton.png" target:self selector:@selector(discardPausePage:)];
    
    CCMenu *pausePageMenu = [CCMenu menuWithItems:menuItemResetGame,menuItemLevelSelGame,menuItemContinueGame, nil];
    [pausePageMenu alignItemsHorizontallyWithPadding:20 ];
    pausePageMenu.position = ccp(size.width/2,size.height/2);
    
    
    [pauseLayer addChild:pausePageMenu z:3];
	
}

- (void) discardPausePage: (CCMenuItem *) menuItem
{	
    rstGameMenu.isTouchEnabled=YES;
    lettersMenu.isTouchEnabled=YES;
	[pauseLayer removeFromParentAndCleanup:YES];
}
- (void) resetGame: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene:[PlayingInterface scene]];
}

-(void) showSelectionPage 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

-(void ) onExit
{
    if (adViewPresent) {
        [adView removeFromSuperview];
        [adView release];
        adViewPresent=NO;
    }
    //CCLOG(@"calling onExit play interface");
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [super onExit];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{   
    
    [alphabet release];
    [animals release];
    [sports release];
    [fishes release];
    [insects release];
    [instruments release];
    [transports release];
    [numbers release];
    [shapes release];
    [colors release];
    [weather release];
    [colorsSounds release];
    [pickedIndexes release];
    [pickedRdmIdx release];
    [statusPlistPath release];
    [spriteArray release];
    [frameNameArray release];
    [spriteCoordinates release];
    [CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
	[super dealloc];
}
@end
