//
//  SDWebImageManager+AL.m
//  HairKing
//
//  Created by Andy Lee on 15/3/5.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "SDWebImageManager+AL.h"

@implementation SDWebImageManager (AL)

+ (void)downloadWithURL:(NSURL *)url
{
    // cmp不能为空
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}
@end