//
//  ALScrollPage.m
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Sizes.h"

#import "ALScrollPage.h"
#import "ALPhotoLoadingView.h"

#define AL_SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface ALScrollPage()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    ALPhotoLoadingView *_photoLoadingView;
    UIImage *_placeholderImage;
}

@end

@implementation ALScrollPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[ALPhotoLoadingView alloc] init];
        
        _placeholderImage = [UIImage imageNamed:@"ALPlaceHolder.png"];
        
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听事件
        // 单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        // 双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(ALPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

- (void)showImage
{
    if (_photo.isFirstShow) { // 首次显示
        
        __weak ALScrollPage *pageView = self;
        __weak ALPhoto *photo = _photo;
        __weak ALPhotoLoadingView *loading = _photoLoadingView;
        
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];

        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > kALMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            photo.image = image;
            [self adjustFrame];
            [pageView photoDidFinishLoadWithImage:image];
        }];
        
    } else {
        [self photoStartLoad];
    }
    
    // 调整frame参数
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        __weak ALScrollPage *pageView = self;
        __weak ALPhotoLoadingView *loading = _photoLoadingView;
        
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > kALMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [pageView photoDidFinishLoadWithImage:image];
        }];
    }
}


#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if (self.pageViewDelegate) {
            if ([self.pageViewDelegate respondsToSelector:@selector(ALPageView:finishLoadImageAtIndex:)]) {
                [self.pageViewDelegate ALPageView:self finishLoadImageAtIndex:_photo.index];
            }
        }
    } else {
        [self addSubview:_photoLoadingView];
        BOOL isShowFailure=YES;
        if([[_photo.url absoluteString] isEqualToString:@""]){
            isShowFailure=NO;
        }
        [_photoLoadingView showFailure:isShowFailure];
    }
    
    [self adjustFrame];
}

- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;

    // 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    if (minScale >= 1) {
        minScale = 0.8;
    }
    
    CGFloat maxScale = 2.0;

    if ([self isScrollEnabled]) {
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
        self.zoomScale = minScale;
        self.bouncesZoom = YES;
    } else {
        self.maximumZoomScale = minScale;
        self.minimumZoomScale = minScale;
        self.zoomScale = minScale;
        self.bouncesZoom = NO;
    }

    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);

    // 宽大
    if ( imageWidth <= imageHeight &&  imageHeight <  boundsHeight ) {
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0) * minScale;
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
    }else{
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0);
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0);
    }
    
    if (_photo.isFirstShow) { // 第一次显示的图片
        _photo.isFirstShow = NO; // 已经显示过了
        [self photoStartLoad];
        
        // 动画展示
//        _imageView.frame = CGRectMake(AL_SCREEN_SIZE.width/2, AL_SCREEN_SIZE.height/2, 0.0, 0.0);
//        [UIView animateWithDuration:0.3  animations:^{
//            _imageView.frame = imageFrame;
//        } completion:^(BOOL finished) {
//            [self photoStartLoad];
//        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark -  监听事件
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    
    if (self.pageViewDelegate) {
        if ([self.pageViewDelegate respondsToSelector:@selector(ALPageView:singleTapAtIndex:)]) {
            [self.pageViewDelegate ALPageView:self singleTapAtIndex:_photo.index];
        }       
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];

    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
