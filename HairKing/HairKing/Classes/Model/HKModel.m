//
//  HKModel.m
//  HairKing
//
//  Created by Andy Lee on 15/2/28.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKModel.h"

@implementation HKModel

@synthesize api = _api;

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.delegate = nil;
    }
    
    return self;
}

- (HKAPI *)api
{
    if (!_api) {
        _api = [[HKAPI alloc] initWithDelegate:self];
    }

    return _api;
}

@end
