//
//  HKAPI.h
//  HairKing
//
//  Created by Andy Lee on 15/2/28.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HKAPIDelegate;

@interface HKAPI : NSObject

@property (nonatomic, strong) id<HKAPIDelegate> delegate;

- (id)initWithDelegate:(id <HKAPIDelegate>)delegate;

- (void)requestUrl:(NSString *)urlString;
- (void)requestUrl:(NSString *)urlString withParams:(NSDictionary *) params;

@end

@protocol HKAPIDelegate <NSObject>

@optional
// 接口数据请求成功
- (void)HKAPI:(HKAPI *)api didCompleteDownloadData:(NSDictionary *)data;

// 接口请求失败
- (void)HKAPI:(HKAPI *)api didCompleteWithError: (NSString *)errorMessage;

@end