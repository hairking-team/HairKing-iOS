//
//  ALScrollPresenter.m
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SDWebImageManager+AL.h"
#import "ALScrollPresenter.h"
#import "ALPhoto.h"

#define kALPageViewTagOffset 1000
#define kALPageViewIndex(pageView) ([pageView tag] - kALPageViewTagOffset)

@interface ALScrollPresenter()
{
    UIScrollView *_scrollPresenterView;
    
    // 所有的图片view
    NSMutableSet *_visiblePageViews;
    NSMutableSet *_reusablePageViews;
}

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation ALScrollPresenter

@synthesize photos = _photos;

- (void)loadView
{    
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;

    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupScrollPresenter];
}

-(void)setupScrollPresenter
{
    CGRect frame = self.view.bounds;

    _scrollPresenterView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollPresenterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollPresenterView.pagingEnabled = YES;
    _scrollPresenterView.delegate = self;
    _scrollPresenterView.showsHorizontalScrollIndicator = NO;
    _scrollPresenterView.showsVerticalScrollIndicator = NO;
    _scrollPresenterView.backgroundColor = [UIColor clearColor];
    _scrollPresenterView.contentSize = CGSizeMake(frame.size.width * self.photos.count, 0);
    _scrollPresenterView.contentOffset = CGPointMake(_currentPageIndex * frame.size.width, 0);
    
    [self.view addSubview:_scrollPresenterView];
}

#pragma mark - synthesize property
- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

#pragma mark - setup
- (void)setupWithPhotoUrls:(NSArray *)urls
{
    [self setupWithPhotoUrls:urls atPageIndex: 0];
}

- (void)setupWithPhotoUrls:(NSArray *)urls atPageIndex:(NSInteger)pageIndex
{
    if ([urls count] < 1) {
        return;
    }
    
    _currentPageIndex = pageIndex;

    int index = 0;
    for (NSString *urlString in urls) {
        ALPhoto *photo = [[ALPhoto alloc] init];
        
        photo.index = index;
        photo.url = [NSURL URLWithString:urlString];
        photo.isFirstShow = index == _currentPageIndex;
        
        [self.photos addObject:photo];
        
        index++;
    }
    
    if (self.photos.count > 1) {
        _visiblePageViews = [NSMutableSet set];
        _reusablePageViews = [NSMutableSet set];
    }
}

- (void)show
{
    [self showViews];
}

-(void)animateToPageAtIndex:(int)index
{
    [_scrollPresenterView setContentOffset:CGPointMake(_scrollPresenterView.frame.size.width * index, _scrollPresenterView.contentOffset.y) animated:YES];
}

#pragma mark - private methods

#pragma mark - 显示页面
- (void)showViews
{
    if (self.photos.count == 1) {
        [self showPageViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _scrollPresenterView.bounds;
    
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= self.photos.count) firstIndex = (int)self.photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= self.photos.count) lastIndex = (int)self.photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger pageViewIndex;
    for (ALScrollPage *pageView in _visiblePageViews) {
        pageViewIndex = kALPageViewIndex(pageView);
        if (pageViewIndex < firstIndex || pageViewIndex > lastIndex) {
            [_reusablePageViews addObject:pageView];
            [pageView removeFromSuperview];
        }
    }
    
    [_visiblePageViews minusSet:_reusablePageViews];
    while (_reusablePageViews.count > 2) {
        [_reusablePageViews removeObject:[_reusablePageViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPageViewAtIndex:index]) {
            [self showPageViewAtIndex:(int)index];
        }
    }
}

#pragma mark - 清除所有页面
- (void)cleanupViews
{
    [[_scrollPresenterView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - 显示index这个页面
- (void)showPageViewAtIndex: (int)index
{
    ALScrollPage *pageView = [self dequeueReusablePageView];
    
    if (!pageView) { // 添加新的图片view
        pageView = [[ALScrollPage alloc] init];
        pageView.pageViewDelegate = self;
    }
    pageView.tag = kALPageViewTagOffset + index;
    
    // 调整当前页的frame
    CGRect bounds = _scrollPresenterView.bounds;
    CGRect pageViewFrame = bounds;
    pageViewFrame.origin.x = (bounds.size.width * index);
    
    ALPhoto *photo = self.photos[index];
    pageView.frame = pageViewFrame;
    pageView.photo = photo;
    
    [_visiblePageViews addObject:pageView];

    [_scrollPresenterView addSubview:pageView];
    
    [self loadNearIndex:index];
}

#pragma mark - 加载index页面的临近页面
- (void)loadNearIndex:(int)index
{
    if (index > 0) {
        ALPhoto *photo = self.photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < self.photos.count - 1) {
        ALPhoto *photo = self.photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark - 是否正在显示index这个页面
- (BOOL)isShowingPageViewAtIndex:(NSUInteger)index {
    for (ALScrollPage *pageView in _visiblePageViews) {
        if (kALPageViewIndex(pageView) == index) {
            return YES;
        }
    }
    
    return  NO;
}

#pragma mark 循环利用某个view
- (ALScrollPage *)dequeueReusablePageView
{
    ALScrollPage *pageView = [_reusablePageViews anyObject];
    if (pageView) {
        [_reusablePageViews removeObject:pageView];
    }
    return pageView;
}


#pragma mark - ALScrollPageDelegate
- (void)ALPageView:(ALScrollPage *)pageView finishLoadImageAtIndex:(int)index
{
    NSLog(@"ALScrollPresenter.m finish load image at index: %d", index);
}

- (void)ALPageView:(ALScrollPage *)pageView singleTapAtIndex:(int)index
{
    if (self.scrollPresenterDelegate) {
        if ([self.scrollPresenterDelegate respondsToSelector:@selector(ALScrollPresenter:singleTapOnPhotoAtIndex:)]) {
            [self.scrollPresenterDelegate ALScrollPresenter:self singleTapOnPhotoAtIndex:index];
        }
    }
    NSLog(@"ALScrollPresenter.m signle tap at page index: %d", index);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.photos.count == 1) {
        return;
    }
    
    [self showViews];
    
    _currentPageIndex = _scrollPresenterView.contentOffset.x / _scrollPresenterView.frame.size.width;
}
@end
