//
//  HKDetailViewController.h
//  HairKing
//
//  Created by Andy Lee on 15/3/3.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKHairDetailModel.h"
#import "ALScrollPresenter.h"

@interface HKDetailViewController : UIViewController <HKHairDetailModelDetelage, ALScrollPresenterDelegate>

- (instancetype)initWithHid:(NSString *)hid;

@end