//
//  ALPhotoLoadingView.h
//  HairKing
//
//  Created by Andy Lee on 15/3/4.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kALMinProgress 0.0001

@interface ALPhotoLoadingView : UIView

@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure:(BOOL)show;

@end
