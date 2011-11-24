//
//  MultiLayerScene.h
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Using an enum to define tag values has the upside that you can select

// Class forwards: if a class is used in a header file only to define a member variable or return value,
// then it's more effective to use the @class keyword rather than #import the class header file.
// When projects grow large this helps to reduce the time it takes to compile the project.

@interface GameStatus : NSObject 
{
	NSMutableDictionary *gameStatusList;
    NSString* statusPlistPath;
    NSString *gameName;
    NSString *gameType;
    NSString *lessonName;
    NSNumber *gameIndex;
    NSNumber *gameOffset;
    NSString *firstTimePlayedStr;

}

// Accessor methods to access the various layers of this scene
+(GameStatus*) sharedGameStatus;
-(void)updatePListFile;
-(BOOL) gamePurchased;
-(BOOL) firstTimePlayed;
-(void)updateEndScenePlayed;
-(BOOL)endScenePlayed;
@property (nonatomic,retain) NSMutableDictionary *gameStatusList;
@property (nonatomic,retain) NSString* statusPlistPath;
@property (nonatomic,retain) NSString *gameName;
@property (nonatomic,retain) NSString *gameType;
@property (nonatomic,retain) NSString *lessonName;
@property (nonatomic,retain) NSNumber *gameIndex;
@property (nonatomic,retain) NSNumber *gameOffset;
@property (nonatomic,retain) NSString *firstTimePlayedStr;


@end
