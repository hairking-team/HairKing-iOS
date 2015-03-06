//
//  ALScrollPage.h
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALPhoto.h"

@class ALScrollPresenter, ALPhoto, ALScrollPage;

@protocol ALPageViewDelegate <NSObject>

// 图片加载成功
- (void)ALPageView:(ALScrollPage *)pageView finishLoadImageAtIndex:(int)index;

// 图片单击
- (void)ALPageView:(ALScrollPage *)pageView singleTapAtIndex:(int)index;

@end

@interface ALScrollPage : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) ALPhoto *photo;
@property (nonatomic, weak) id<ALPageViewDelegate> pageViewDelegate;

@end
