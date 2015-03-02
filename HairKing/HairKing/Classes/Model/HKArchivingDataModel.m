//
//  HKArchivingDataModel.m
//  HairKing
//
//  Created by Andy Lee on 15/2/28.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKAPIDefines.h"
#import "HKModelDefines.h"
#import "HKArchivingDataModel.h"

// user default token key
#define kUserTokenKey (@"kHKUserToken")

@interface HKArchivingDataModel()

@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation HKArchivingDataModel

@synthesize defaults = _defaults;
@synthesize token = _token;

- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (NSString *)token
{
    if (!_token) _token = [self.defaults objectForKey:kUserTokenKey];
    
    return _token;
}

- (void)updateToken:(NSString *)token
{
    _token = token;
    
    [self.defaults setObject:_token forKey:kUserTokenKey];
    
    [self.defaults synchronize];
}

- (NSUserDefaults *)defaults
{
    if (_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}

@end
