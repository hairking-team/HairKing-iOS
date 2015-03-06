//
//  ALPhotoLoadingView.m
//  HairKing
//
//  Created by Andy Lee on 15/3/4.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ALPhotoLoadingView.h"
#import "ALPhotoProgressView.h"

@interface ALPhotoLoadingView()
{
    UILabel *_failureLabel;
    ALPhotoProgressView *_progressView;
}

@end

@implementation ALPhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showFailure:(BOOL)show
{
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        _failureLabel.textAlignment = NSTextAlignmentCenter;
        _failureLabel.center = self.center;
        _failureLabel.text = @"下载图片失败";
        _failureLabel.font = [UIFont boldSystemFontOfSize:20];
        _failureLabel.textColor = [UIColor blackColor];
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
    _failureLabel.hidden=!show;
}

- (void)showLoading
{
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
        _progressView = [[ALPhotoProgressView alloc] init];
        _progressView.bounds = CGRectMake( 0, 0, 60, 60);
        _progressView.center = self.center;
    }
    _progressView.progress = kALMinProgress;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}

@end
