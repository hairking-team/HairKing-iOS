//
//  HKAPI.m
//  HairKing
//
//  Created by Andy Lee on 15/2/28.
//  Copyright (c) 2015年 Andy Lee. All rights reserved.
//

#import "HKAPIDefines.h"
#import "HKAPI.h"
#import "HKArchivingDataModel.h"

@interface HKAPI() <NSURLSessionDownloadDelegate>
{
    NSURLSession *inProcessSession;
}

@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) HKArchivingDataModel *archivingDataModel;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSURLSessionDownloadTask *apiTask;

@end

@implementation HKAPI

@synthesize apiUrl = _apiUrl;
@synthesize archivingDataModel = _archivingDataModel;
@synthesize token = _token;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.delegate = nil;
    }
    
    return self;
}

- (id)initWithDelegate:(id <HKAPIDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (NSString *)apiUrl
{
    if (!_apiUrl) _apiUrl = [NSString stringWithFormat:@"%@", kHKAPIUrl];
    
    return [_apiUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (HKArchivingDataModel *)archivingDataModel
{
    if (_archivingDataModel) {
        _archivingDataModel = [[HKArchivingDataModel alloc] init];
    }
    
    return _archivingDataModel;
}

- (NSString *)token
{
    if (!_token) {
        _token = self.archivingDataModel.token;
    }
    
    return _token;
}

- (void)requestUrl:(NSString *)urlString
{
    [self requestUrl:urlString withParams:nil];
}

- (void)requestUrl:(NSString *)urlString withParams:(NSDictionary *)params
{
    if(!inProcessSession) {
        inProcessSession = [self createSessionWithConfiguration:nil];
    }
    NSURL *url = [self makeRequestUrlByString:urlString withParams:params];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //    self.apiTask = [inProcessSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
    //        if (error) {
    //            NSLog(@"error = %@",error.localizedDescription);
    //        } else {
    //            NSLog(@"%@", location);
    //        }
    //    }];
    
    self.apiTask = [inProcessSession downloadTaskWithRequest:request];
    
    [self.apiTask resume];
}

// 生成请求地址
- (NSURL *)makeRequestUrlByString:(NSString *)urlString withParams:(NSDictionary *)params
{
    return [self makeRequestUrlByString:urlString withParams:params withToken:NO];
}

// 生成带token的请求地址
- (NSURL *)makeRequestUrlByString:(NSString *)urlString withParams:(NSDictionary *)params withToken:(BOOL)useToken
{
    NSString *url = [NSString stringWithFormat:@"%@?path=%@", self.apiUrl, urlString];
    
    if (useToken) {
        [url stringByAppendingString:[NSString stringWithFormat:@"&token=%@", self.token]];
    }
    
    if (params) {
        for (NSString *key in params) {
            if ([params[key] isKindOfClass:[NSString class]]) {
                NSString *value = params[key];
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
        }
    }
    
    if (kHKAPIDebug) {
        NSLog(@"NODAPI.m - requestUrl: %@", url);
    }
    
    return [NSURL URLWithString:url];
}

// 创建自定义配置的session
- (NSURLSession *)createSessionWithConfiguration:(NSURLSessionConfiguration *)config
{
    NSURLSessionConfiguration *sessionConfig = config ? config : [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    session.sessionDescription = @"in-process NSURLSession";
    
    return session;
}

#pragma mark parseDownloadFile
- (void)parseDownloadFileFromPath:(NSURL *)filePath
{
    NSError *fileError;
    NSError *jsonError;
    //    文件读取类型
    //    enum {
    //        NSDataReadingMappedIfSafe = 1UL << 0, // 映射到虚拟内存上 如果安全的话
    //        NSDataReadingUncached = 1UL << 1, // 不使用虚拟内存 针对一次性读取的文件使用此类型将提高一定的性能
    //        NSDataReadingMappedAlways = 1UL << 3, // 始终映射到内存是
    //    };
    //    typedef NSUInteger NSDataReadingOptions;
    
    //    JSON 读取类型
    //    enum {
    //        NSJSONReadingMutableContainers = (1UL << 0), // 返回的容器是可变类型的 (Array和Dictionary)
    //        NSJSONReadingMutableLeaves = (1UL << 1), // 返回的NSString是可变类型的
    //        NSJSONReadingAllowFragments = (1UL << 2) // 允许顶层的界面不是NSArray或NSDictionary
    //    };
    //    typedef NSUInteger NSJSONReadingOptions;
    
    NSMutableDictionary *resultData = [NSJSONSerialization
                                       JSONObjectWithData:[NSData dataWithContentsOfURL:filePath
                                                                                options:NSDataReadingUncached error:&fileError]
                                       options:NSJSONReadingMutableContainers
                                       error:&jsonError];
    
    [self selectorDelegateMethodWithData:resultData];
}

- (void)selectorDelegateMethodWithData:(NSMutableDictionary *)requestData
{
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(HKAPIDelegate)]) {
        
//        NSString *status = [requestData objectForKey:kNODAPIRequestStatusKey];
//        
//        if ([status isEqualToString: kHKAPIRequestStatusSuccessValue]) { // 请求接口数据状态成功
//            if ([self.delegate respondsToSelector:@selector(NODAPI:didFinishDownloadingToData:)]) {
//                NSDictionary *data = [requestData objectForKey:kNODAPIRequestDataKey];
//                [self.delegate NODAPI:self didFinishDownloadingToData:data];
//            }
//        } else if ([status isEqualToString:kNODAPIRequestStatusFailValue]) { // 请求接口数据状态失败
//            
//            NSString *errorCode = [requestData objectForKey:kNODAPIRequestErrorCodeKey];
//            NSString *errorMessage = [requestData objectForKey:kNODAPIRequestErrorMessageKey];
//            
//            if ([self.delegate respondsToSelector:@selector(NODAPI:didCompleteWithErrorCode:errorMessage:)]) {
//                [self.delegate NODAPI:self didCompleteWithErrorCode:errorCode errorMessage:errorMessage];
//            }
//        }
    }
}

#pragma mark NSURLSessionDownloadDelegate
// 下载成功
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    NSError *error;
    
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseDownloadFileFromPath:destinationPath];
        });
    } else if(kHKAPIDebug) {
        NSLog(@"Couldn't copy the downloaded file");
    }
    
    self.apiTask = nil;
    
}

//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

//
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

//
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Leave this for now
}

@end