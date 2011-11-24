//
//  MultiLayerScene.m
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "GameStatus.h"

@implementation GameStatus
@synthesize gameStatusList,statusPlistPath;
@synthesize gameName,gameType,gameIndex,gameOffset,firstTimePlayedStr;


static GameStatus *sharedGameStatus;

+(GameStatus*) sharedGameStatus
{
	@synchronized(self)
	{
		if (!sharedGameStatus)
		{
			sharedGameStatus = [[GameStatus alloc] init];
            
		}
		return sharedGameStatus;
	}
	
}
-(BOOL) firstTimePlayed{
    firstTimePlayedStr = [gameType stringByAppendingString:@"1stTimePlayed"];
    if ([[gameStatusList objectForKey:firstTimePlayedStr] intValue]) {
        return YES;
    }
    return NO;

}
-(BOOL) gamePurchased{
    NSString *purchaseStr = [gameType stringByAppendingString:@"Purchased"];
    
    if ([[ gameStatusList objectForKey:purchaseStr]intValue]) {
        return YES;
    }
    return NO;
}


-(void)updateEndScenePlayed{
    NSString *endScenePlayedStr = [gameType stringByAppendingString:@"EndScenePlayed"];
    [gameStatusList setObject:[NSNumber numberWithInt:1] forKey:endScenePlayedStr];
    [self updatePListFile];
}
-(BOOL)endScenePlayed{
    NSString *endScenePlayedStr = [gameType stringByAppendingString:@"EndScenePlayed"];
    return [[gameStatusList objectForKey:endScenePlayedStr] intValue];

}
-(void)updatePListFile{
    [gameStatusList writeToFile:statusPlistPath atomically:YES];
}
-(void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
