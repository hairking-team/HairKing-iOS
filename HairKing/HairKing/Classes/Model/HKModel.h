//
//  HKModel.h
//  HairKing
//
//  Created by Andy Lee on 15/2/28.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKAPI.h"
#import "HKAPIDefines.h"
#import "HKModelDefines.h"

@interface HKModel : NSObject <HKAPIDelegate>

@property (nonatomic, strong) HKAPI *api;
@property (nonatomic, strong) id delegate;

@end
