//
//  BootViewController.m
//  HairKing
//
//  Created by Andy Lee on 15/2/13.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKRootViewController.h"
#import "HKDetailViewController.h"

@interface HKRootViewController() {
    int _pageNumber;
    ZBWaterView *_waterView;
}

@property (nonatomic, strong) HKHairModel *hairModel;
@property (nonatomic, strong) HKHairListModel *hairListModel;
@property (nonatomic, strong) ZBWaterView *hairListView;

@property (nonatomic, strong) NSMutableArray *hairList;

@end

@implementation HKRootViewController

@synthesize hairModel = _hairModel;
@synthesize hairListModel = _hairListModel;
@synthesize hairListView = _hairListView;

@synthesize hairList = _hairList;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _pageNumber = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchMoreHairListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - synthesize property;

- (HKHairModel *)hairModel
{
    if (!_hairModel) {
        _hairModel = [[HKHairModel alloc] init];
    }
    
    return _hairModel;
}
- (HKHairListModel *)hairListModel
{
    if (!_hairListModel) {
        _hairListModel = [[HKHairListModel alloc] init];
        _hairListModel.hairListModeldelegate = self;
    }
    
    return _hairListModel;
}

- (ZBWaterView *)hairListView
{
    if (!_hairListView) {
        _hairListView = [[ZBWaterView alloc]  initWithFrame:self.view.frame];
        
        // 设置委托
        _hairListView.waterDataSource = self;
        _hairListView.waterDelegate = self;
        
        _hairListView.isDataEnd = NO;
        
        [self.view addSubview:_hairListView];
    }
    
    return _hairListView;
}

- (NSMutableArray *)hairList
{
    if (!_hairList) {
        _hairList = [[NSMutableArray alloc] init];
    }
    
    return _hairList;
}

- (void)appendHairList:(NSArray *)hairListArray
{
    if ([hairListArray count] > 0) {
        [self.hairList addObjectsFromArray:hairListArray];
        [self updateHairListView];
    } else {
        self.hairListView.isDataEnd = YES;
    }
}

#pragma mark - load hairlist data

- (void)fetchMoreHairListData
{
    _pageNumber++;
    [self fetchHairListDataAtPage:_pageNumber];
}

- (void)fetchHairListDataAtPage: (int)pageNumber
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"fetch page number: %i", pageNumber);
        [NSThread sleepForTimeInterval: 2.0];
        
        [self.hairListModel fetchHairListAtPage:pageNumber];
    });
}

#pragma mark - water view
- (void)updateHairListView
{
    for (HKHairModel *hair in self.hairList) {
        hair.photo = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:hair.smallpic]]];
    }
    [self.hairListView endLoadMore];
    [self.hairListView reloadData];
}

#pragma mark - model delegate
- (void)HKHairListModel:(HKHairListModel *)hairListModel didCompletionFetchHairList:(NSArray *)hairList
{
//    NSLog(@"HKHairListModel - Completed fetch hair list, length: %ld", [hairList count]);
    [self appendHairList:hairList];
}

#pragma mark - ZBWaterViewDatasource
- (NSInteger)numberOfFlowViewInWaterView:(ZBWaterView *)waterView
{
    return [self.hairList count];
}

- (CustomWaterInfo *)infoOfWaterView:(ZBWaterView*)waterView
{
    CustomWaterInfo *info = [[CustomWaterInfo alloc] init];
    
    info.topMargin = 0;
    info.leftMargin = 0;
    info.bottomMargin = 0;
    info.rightMargin = 0;
    info.horizonPadding = 0;
    info.veticalPadding = 0;
    info.numOfColumn = 2;
    
    return info;
}

- (ZBFlowView *)waterView:(ZBWaterView *)waterView flowViewAtIndex:(NSInteger)index
{

    HKHairModel *hair = [self.hairList objectAtIndex:index];
    
    ZBFlowView *flowView = [waterView dequeueReusableCellWithIdentifier:@"cell"];
    if (flowView == nil) {
        flowView = [[ZBFlowView alloc] initWithFrame:CGRectZero];
        flowView.reuseIdentifier = @"cell";
    }
    
    flowView.index = index;
    [flowView addSubview:[[UIImageView alloc] initWithImage:hair.photo]];
    
    return flowView;
}

- (CGFloat)waterView:(ZBWaterView *)waterView heightOfFlowViewAtIndex:(NSInteger)index
{
    HKHairModel *hair = [self.hairList objectAtIndex:index];
    return hair.photo.size.height;
}

#pragma mark - ZBWaterViewDelegate
- (void)needLoadMoreByWaterView:(ZBWaterView *)waterView;
{
    [self fetchMoreHairListData];
}

- (void)phoneWaterViewDidScroll:(ZBWaterView *)waterView
{
    
}

- (void)waterView:(ZBWaterView *)waterView didSelectAtIndex:(NSInteger)index
{
    HKHairModel *hairModel = [self.hairList objectAtIndex:index];
    if (hairModel) {
        HKDetailViewController *detailViewController = [[HKDetailViewController alloc]initWithHid:hairModel.hid];
       
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
