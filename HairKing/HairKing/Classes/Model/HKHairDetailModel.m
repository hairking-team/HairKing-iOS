//
//  HKHairModel.m
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHairDetailModel.h"

#define kHKHairDetailAPIURLPath (@"apphairDetail.html")

#define kHKDataKeyOfHairDetailPicCount (@"bigpicCount")
#define kHKDataKeyOfHairDetailPicInfo (@"hairPicInfo")
#define kHKDataKeyOfHairDetailPicInfoId (@"bigpicid")
#define kHKDataKeyOfHairDetailPicInfoUrl (@"bigpicurl")

@implementation HKHairDetailModel

@synthesize hid;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.api.delegate = self;
        self.hairModeldelegate = nil;
        self.hid = nil;
    }
    
    return self;
}

#pragma mark - fetch detail data
- (NSDictionary *)makeDataOfHairDetail:(NSDictionary *)detailData
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [self makeDataOfHairDetailPhotoList:[detailData objectForKey: kHKDataKeyOfHairDetailPicInfo]], @"photoList",
            [detailData objectForKey: kHKDataKeyOfHairDetailPicCount], @"photoListCount"
            , nil];
}
- (NSArray *)makeDataOfHairDetailPhotoList: (NSArray *)photoList
{
    NSMutableArray *photoListData = [[NSMutableArray alloc] init];
    
    if ([photoList count] > 0) {
        for (NSDictionary *data in photoList) {
            [photoListData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                      [data objectForKey:kHKDataKeyOfHairDetailPicInfoId], @"photoId",
                                      [data objectForKey:kHKDataKeyOfHairDetailPicInfoUrl], @"photoUrl"
                                      , nil]];
        }
    }
    
    return photoListData;
}

- (void)fetchDetailData
{
    if (self.hid) {
        NSString *urlPath = [NSString stringWithFormat: kHKHairDetailAPIURLPath];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.hid], @"hid", nil];
        
        [self.api requestUrl:urlPath withParams:params];
    }
}

- (void)didFinishedFetch: (NSDictionary *)hairDetailData
{
//    NSLog(@"HKHairDetailModel.m - didFinishedFetch:%@", hairDetailData);
    
    if (self.hairModeldelegate) {
        if ([self.hairModeldelegate respondsToSelector:@selector(HKHairDetailModel:didCompletionFetchDetailData:)]) {
            
            [self.hairModeldelegate HKHairDetailModel:self
                         didCompletionFetchDetailData:[self makeDataOfHairDetail:hairDetailData]];
        }
    }
}

# pragma mark - HKAPIDelegate
- (void)HKAPI:(HKAPI *)api didCompleteDownloadData:(NSDictionary *)data
{
    [self didFinishedFetch: data];
}

- (void)HKAPI:(HKAPI *)api didCompleteWithError:(NSString *)errorMessage
{
    NSLog(@"%@", errorMessage);
}

@end
