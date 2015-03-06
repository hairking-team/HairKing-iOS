//
//  HKHairModel.m
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKHairModel.h"

@implementation HKHairModel

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self) {
        self.hid = [data objectForKey: @"hid"];
        self.smallpic = [data objectForKey: @"smallpic"];
        self.photo = nil;
    }
    
    return self;
}

@end
