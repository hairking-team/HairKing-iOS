//
//  ALPhoto.h
//  HairKing
//
//  Created by Andy Lee on 15/3/4.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALPhoto : NSObject

@property (nonatomic, assign) int index; // 索引
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, assign) BOOL isFirstShow;

@end
