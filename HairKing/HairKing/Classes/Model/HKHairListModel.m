//
//  HKHairListModel.m
//  HairKing
//
//  Created by Andy Lee on 15/3/2.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKHairListModel.h"

#define kHKHairListAPIURLPath (@"apphairlist.html")
#define kHKDataKeyOfHairList (@"hairInfo")

@interface HKHairListModel()
{
    
}

@property (strong, nonatomic) NSMutableArray *hairList;

@end


@implementation HKHairListModel

@synthesize hairList = _hairList;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.api.delegate = self;
        self.hairListModeldelegate = nil;
    }
    
    return self;
}

- (NSMutableArray *)hairList
{
    if (!_hairList) {
        _hairList = [[NSMutableArray alloc] init];
    }
    
    return _hairList;
}

- (void)setHairList:(NSMutableArray *)hairList
{
    _hairList = hairList;
    
    if (self.hairListModeldelegate) {
        if ([self.hairListModeldelegate respondsToSelector:@selector(HKHairListModel:didCompletionFetchHairList:)]) {
            [self.hairListModeldelegate HKHairListModel:self didCompletionFetchHairList:_hairList];
        }
    }
}

// 请求发型数据
- (void)fetchHairListAtPage:(int)pageNumber
{
    if (pageNumber < 1) pageNumber = 1;
    
    NSString *urlPath = [NSString stringWithFormat: kHKHairListAPIURLPath];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageNumber], @"page", nil];
    
    [self.api requestUrl:urlPath withParams:params];
}

// 更新发型数据
- (void)updateHairList:(NSArray *)hairListArray
{
    if ([hairListArray count] > 0) {
        NSMutableArray *hairList = [[NSMutableArray alloc] init];
        
        for (id hair in hairListArray) {
            if ([hair isKindOfClass:[NSDictionary class]]) {
                HKHairModel *hairModel = [[HKHairModel alloc] initWithData: hair];
                [hairList addObject:hairModel];
            }
        }
        
        self.hairList = hairList;
    }
}

// 完成数据请求
- (void)didFinishedFetch: (NSArray *)hairListArray
{
    [self updateHairList:hairListArray];
}

# pragma mark - HKAPIDelegate
- (void)HKAPI:(HKAPI *)api didCompleteDownloadData:(NSDictionary *)data
{
    [self didFinishedFetch:[data objectForKey:kHKDataKeyOfHairList]];
}

- (void)HKAPI:(HKAPI *)api didCompleteWithError:(NSString *)errorMessage
{
    NSLog(@"%@", errorMessage);
}
@end
