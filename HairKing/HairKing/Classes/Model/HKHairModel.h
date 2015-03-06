//
//  HKHairModel.h
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKModel.h"

@interface HKHairModel : HKModel

@property (strong, nonatomic) NSString *hid;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSString *smallpic;

- (instancetype)initWithData:(NSDictionary *)data;

@end
