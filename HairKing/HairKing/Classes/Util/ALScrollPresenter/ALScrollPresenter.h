//
//  ALScrollPresenter.h
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALScrollPage.h"

@protocol ALScrollPresenterDelegate;

@interface ALScrollPresenter : UIViewController  <UIScrollViewDelegate, ALPageViewDelegate>

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, weak) id<ALScrollPresenterDelegate> scrollPresenterDelegate;
- (void)animateToPageAtIndex:(int)index;

- (void)setupWithPhotoUrls:(NSArray *)urls;
- (void)setupWithPhotoUrls:(NSArray *)urls atPageIndex: (NSInteger)pageIndex;

- (void)show;

@end

@protocol ALScrollPresenterDelegate <NSObject>

- (void)ALScrollPresenter:(ALScrollPresenter *)alScrollPresenter singleTapOnPhotoAtIndex:(int)index;

@end