//
//  HKHairModel.h
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKModel.h"

@protocol HKHairDetailModelDetelage;

@interface HKHairDetailModel : HKModel <HKAPIDelegate>

@property (strong, nonatomic) id<HKHairDetailModelDetelage> hairModeldelegate;
@property (strong, nonatomic) NSString *hid;

- (instancetype)init;
- (void)fetchDetailData;

@end

@protocol HKHairDetailModelDetelage <NSObject>

// 数据加载成功
- (void)HKHairDetailModel:(HKHairDetailModel *)hairModel didCompletionFetchDetailData: (NSDictionary *)hairDetailData;

// 数据加载失败

@end
