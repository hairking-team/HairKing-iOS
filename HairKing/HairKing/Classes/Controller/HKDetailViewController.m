//
//  HKDetailViewController.m
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKDetailViewController.h"

@interface HKDetailViewController()
{
    NSString *_hid;
    
    ALScrollPresenter *_alScrollPresenter;
}

@property (strong, nonatomic) NSMutableArray *detailData;
@property (strong, nonatomic) HKHairDetailModel *detailModel;

@end

@implementation HKDetailViewController

@synthesize detailData = _detailData;
@synthesize detailModel = _detailModel;

- (instancetype)initWithHid:(NSString *)hid
{
    self = [super init];
    
    if (self) {
        _hid = hid;
        _alScrollPresenter = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:74 green:190 blue:205 alpha:1.0]];

    [self fetchDetailData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - synthesize property
- (NSMutableArray *)detailData
{
    if (!_detailData) {
        _detailData = [[NSMutableArray alloc] init];
    }
    
    return _detailData;
}
- (void)setDetailData:(NSArray *)detailData
{
    [self.detailData addObjectsFromArray:detailData];
    [self updateDetailView];
}

- (HKHairDetailModel *)detailModel
{
    if (!_detailModel) {
        _detailModel = [[HKHairDetailModel alloc] init];
        _detailModel.hairModeldelegate = self;
        _detailModel.hid = _hid;
    }
    
    return _detailModel;
}

#pragma mark - detail view
- (void)updateDetailView
{
    if ([self.detailData count] == 0) {
        return;
    }

    NSMutableArray *photoUrls = [[NSMutableArray alloc] init];
    for (NSDictionary *data in self.detailData) {
        NSString *urlString = [data objectForKey:@"photoUrl"];
        
        [photoUrls addObject:urlString];
    }
    
    if (_alScrollPresenter) {
        [_alScrollPresenter.view removeFromSuperview];
    } else {
        _alScrollPresenter = [[ALScrollPresenter alloc] init];
        _alScrollPresenter.scrollPresenterDelegate = self;
    }
    
    [_alScrollPresenter setupWithPhotoUrls:photoUrls];
    [self.view addSubview:_alScrollPresenter.view];
    
    [_alScrollPresenter showViews];
}

#pragma mark - fetch data
-(void)fetchDetailData
{
    NSLog(@"HKDetailViewController.m fetchDetailData");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.detailModel fetchDetailData];
    });
}

#pragma mark - Model Delegate
- (void)HKHairDetailModel:(HKHairDetailModel *)hairModel didCompletionFetchDetailData:(NSDictionary *)hairDetailData
{
    self.detailData = [hairDetailData objectForKey:@"photoList"];
//    NSLog(@"HKDetailViewController.m - HKHairDetailModel:%@", hairDetailData);
}

#pragma mark - ALScrollPresenter Delegate
- (void)ALScrollPresenter:(ALScrollPresenter *)alScrollPresenter singleTapOnPhotoAtIndex:(int)index
{
    NSLog(@"single tap on index: %d", index);
}

@end
