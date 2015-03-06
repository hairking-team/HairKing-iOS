//
//  BootViewController.h
//  HairKing
//
//  Created by Andy Lee on 15/2/13.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBFlowView.h"
#import "ZBWaterView.h"

#import "HKHairListModel.h"


@interface HKRootViewController : UIViewController<HKHairListModelDelegate, ZBWaterViewDatasource,ZBWaterViewDelegate>

- (instancetype)init;

@end