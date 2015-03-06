//
//  HKHairListModel.h
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKHairModel.h"


@protocol HKHairListModelDelegate;

@interface HKHairListModel : HKHairModel <HKAPIDelegate>

@property (nonatomic, strong) id<HKHairListModelDelegate> hairListModeldelegate;

- (void)fetchHairListAtPage:(int)pageNumber;

@end


@protocol HKHairListModelDelegate <NSObject>

// 数据加载成功
- (void)HKHairListModel:(HKHairListModel *)hairListModel didCompletionFetchHairList:(NSArray *)hairList;

// 数据加载失败

@end