//
//  InAppRageIAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ColorMeNowIAPHelper.h"

@implementation ColorMeNowIAPHelper

static ColorMeNowIAPHelper * _sharedHelper;

+ (ColorMeNowIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[ColorMeNowIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
        @"com.voiladesign.colormenow.monsters",
        @"com.voiladesign.colormenow.princesses", 
        nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
