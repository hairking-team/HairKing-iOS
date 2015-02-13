//
//  BootViewController.m
//  HairKing
//
//  Created by Andy Lee on 15/2/13.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "BootViewController.h"

@implementation BootViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Boot View Did Load.");
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    NSLog(@"view did appear");
}


@end
