//
//  HttpEngine.m
//  SmartDevice
//
//  Created by singelet on 16/6/12.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "HttpEngine.h"
#import "AFNetworking.h"
#import "HttpRequestToken.h"
#import "Define.h"
#import "NSData+zh_JSON.h"
#import "CheckNetwordStatus.h"
#import "UIViewController+Extension.h"
#import "AppDelegate+Notification.h"
#import "AFAccountEngine.h"

@implementation HttpEngine

#pragma mark - POST Request
+ (NSURLSessionDataTask *)requestPostWithURL:(NSString *)url
                                      params:(NSDictionary *)params
                                     isToken:(BOOL)isToken
                                 errorDomain:(NSString *)errorDomain
                                 errorString:(NSString *)errorString
                                     success:(HttpSuccessBlock)success
                                     failure:(HttpFailureBlock)failure
{
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        [self handleNoNetwordWithFailure:failure];
        return nil;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (isToken) {
        if ([HttpRequestToken analysisToken:token]) {
            [self refreshTokenWihtSuccess:^(id responseObject) {
                [self postWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            } failure:failure];
            return nil;
        }
        else {
           return [self postWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
        }
    }
    else {
      return [self postWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
    }
}

+ (NSURLSessionDataTask *)postWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              isToken:(BOOL)isToken
                          errorDomain:(NSString *)errorDomain
                          errorString:(NSString *)errorString
                              success:(HttpSuccessBlock)success
                              failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:isToken];
    NSURLSessionDataTask *sessionDataTask = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
    }];
    return sessionDataTask;
}

#pragma mark - GET Request
+ (NSURLSessionDataTask *)requestGetWithURL:(NSString *)url
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure
{
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        [self handleNoNetwordWithFailure:failure];
        return nil;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (isToken) {
        if ([HttpRequestToken analysisToken:token]) {
            [self refreshTokenWihtSuccess:^(id responseObject) {
                [self getWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            } failure:failure];
            return nil;
        }
        else {
           return [self getWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
        }
    }
    else {
       return [self getWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
    }
}

+ (NSURLSessionDataTask *)getWithURL:(NSString *)url
                              params:(NSDictionary *)params
                             isToken:(BOOL)isToken
                         errorDomain:(NSString *)errorDomain
                         errorString:(NSString *)errorString
                             success:(HttpSuccessBlock)success
                             failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:isToken];
    NSURLSessionDataTask *sessionDataTask = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
         [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
    }];
    return sessionDataTask;
}

#pragma mark - DELETE Request
+ (NSURLSessionDataTask *)requestDeleteWithURL:(NSString *)url
                                        params:(NSDictionary *)params
                                       isToken:(BOOL)isToken
                                   errorDomain:(NSString *)errorDomain
                                   errorString:(NSString *)errorString
                                       success:(HttpSuccessBlock)success
                                       failure:(HttpFailureBlock)failure
{
    if (![CheckNetwordStatus sharedInstance].isNetword) {
         [self handleNoNetwordWithFailure:failure];
        return nil;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (isToken) {
        if ([HttpRequestToken analysisToken:token]) {
            [self refreshTokenWihtSuccess:^(id responseObject) {
                [self deleteWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            } failure:failure];
            return nil;
        }
        else {
            return [self deleteWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
        }
    }
    else {
        return [self deleteWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
    }
}

+ (NSURLSessionDataTask *)deleteWithURL:(NSString *)url
               params:(NSDictionary *)params
              isToken:(BOOL)isToken
          errorDomain:(NSString *)errorDomain
          errorString:(NSString *)errorString
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:isToken];
    NSURLSessionDataTask *sessionDataTask = [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
    }];
    return sessionDataTask;
}

#pragma mark - PUT Request
+ (NSURLSessionDataTask *)requestPutWithURL:(NSString *)url
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure
{
    if (![CheckNetwordStatus sharedInstance].isNetword) {
         [self handleNoNetwordWithFailure:failure];
        return nil;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (isToken) {
        if ([HttpRequestToken analysisToken:token]) {
            [self refreshTokenWihtSuccess:^(id responseObject) {
                [self putWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            } failure:failure];
            return nil;
        }
        else {
           return [self putWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
        }
    }
    else {
        return [self putWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
    }
}

+ (NSURLSessionDataTask *)putWithURL:(NSString *)url
                              params:(NSDictionary *)params
                             isToken:(BOOL)isToken
                         errorDomain:(NSString *)errorDomain
                         errorString:(NSString *)errorString
                             success:(HttpSuccessBlock)success
                             failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:isToken];
    NSURLSessionDataTask *sessionDataTask = [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
    }];
    return sessionDataTask;
}


#pragma mark - PATCH Request
+ (NSURLSessionDataTask *)requestPatchWithURL:(NSString *)url
                                       params:(NSDictionary *)params
                                      isToken:(BOOL)isToken
                                  errorDomain:(NSString *)errorDomain
                                  errorString:(NSString *)errorString
                                      success:(HttpSuccessBlock)success
                                      failure:(HttpFailureBlock)failure
{
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        [self handleNoNetwordWithFailure:failure];
        return nil;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (isToken) {
        if ([HttpRequestToken analysisToken:token]) {
            [self refreshTokenWihtSuccess:^(id responseObject) {
                [self patchWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            } failure:failure];
            return nil;
        }
        else {
            return [self patchWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
        }
    }
    else {
        return [self patchWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
    }
}

+ (NSURLSessionDataTask *)patchWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               isToken:(BOOL)isToken
                           errorDomain:(NSString *)errorDomain
                           errorString:(NSString *)errorString
                               success:(HttpSuccessBlock)success
                               failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:isToken];
    NSURLSessionDataTask *sessionDataTask = [manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
    }];
    return sessionDataTask;
}


#pragma mark - HTTP Request
+ (NSURLSessionDataTask *)httpRequestWithResquestType:(HttpRequestType)requestType
                                                  url:(NSString *)url
                                               params:(NSDictionary *)params
                                              isToken:(BOOL)isToken
                                          errorDomain:(NSString *)errorDomain
                                          errorString:(NSString *)errorString
                                              success:(HttpSuccessBlock)success
                                              failure:(HttpFailureBlock)failure
{
    switch ((NSInteger)requestType) {
        case HttpRequestTypePost:
           return [self requestPostWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            break;
        case HttpRequestTypeGet:
           return [self requestGetWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            break;
        case HttpRequestTypeDelete:
            return [self requestDeleteWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            break;
        case HttpRequestTypePut:
            return [self requestPutWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            break;
        case HttpRequestTypePatch:
             return [self requestPatchWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:success failure:failure];
            break;
    }
    return nil;
}

#pragma mark - Common Operations
+ (void)handleResponse:(id)responseObject errorDomain:(NSString *)errorDomain errorString:(NSString *)errorString success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *JSONDic = (NSDictionary *)responseObject;
    !success ?  : success(JSONDic);
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //    if ([responseObject isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *JSONDic = (NSDictionary *)responseObject;
//        !success ?  : success(JSONDic);
//    }
//    else {
//        NSMutableDictionary *userInfo = @{@"message" : @"网络有点小问题\n请稍后", @"status_code" : @"100"}.mutableCopy;
//        NSString *errorDomainValue = @"状态码不为200";
//        if (errorDomain.length > 0) {
//            errorDomainValue = errorDomain;
//        }
//        NSError *error = [NSError errorWithDomain:errorDomainValue code:100 userInfo:userInfo];
//        !failure ? :failure(error);
//    }
}

+ (void)handleErrorUserInfo:(NSDictionary *)userInfo errorDomain:(NSString *)errorDomain errorString:(NSString *)errorString failure:(void (^)(NSError *))failure
{
    id object = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *errorDic = [NSData zh_JSONFromData:object];
    if (errorDic) {
        NSString *errorDomainValue = [NSString stringWithFormat:@"状态码为,%@",errorDic[@"status_code"]];
        NSError *error = [NSError errorWithDomain:errorDomainValue code:[errorDic[@"status_code"] integerValue] userInfo:errorDic];
        !failure ? :failure(error);
    }
    else {
        NSMutableDictionary *userInfo = @{@"message" : @"当前网络不可用，请检查手机的网络设置", @"status_code" : @"100"}.mutableCopy;
        NSString *errorDomainValue = @"状态码不为200";
        if (errorDomain.length > 0) {
            errorDomainValue = errorDomain;
        }
        NSError *error = [NSError errorWithDomain:errorDomainValue code:100 userInfo:userInfo];
        !failure ? :failure(error);
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}

+ (void)handleNoNetwordWithFailure:(void (^)(NSError *))failure
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleErrorUserInfo:nil errorDomain:nil errorString:nil failure:failure];
    });
}

#pragma mark - AFHTTPSessionManager Init
+ (AFHTTPSessionManager *)httpSessionManagerWithIsToken:(BOOL)isToken
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    
//    self.session.securityPolicy.allowInvalidCertificates = TRUE;

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer * respons = [AFJSONResponseSerializer serializer];
    respons.removesKeysWithNullValues = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer=respons;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUUID *deviceUUID = [UIDevice currentDevice].identifierForVendor;
    NSString *deviceId = [deviceUUID UUIDString];
    [manager.requestSerializer setValue:deviceId == nil ? @"" : deviceId forHTTPHeaderField:@"device_id"];
    [manager.requestSerializer setValue:version == nil ? @"" : version forHTTPHeaderField:@"version_id"];

//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//申明请求数据的类型
    manager.requestSerializer.timeoutInterval = 20.0f;
//    [manager.requestSerializer setValue:@"application/vnd.robot.v1+json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8;" @"application/json", @"text/html",@"text/json", @"text/javascript",   forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效了，然后就是参数要求是json，怎么设。。
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    
 
    if (isToken) {
       AFAccount* account = [AFAccountEngine  getAccount];
        NSString * string =[NSString stringWithFormat:@"%@:%@:%d",login_appID ,token,account.identifier];
        NSString * stringBase = [NSString base64EncodeString:string];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d %@",account.identifier ,stringBase] forHTTPHeaderField:@"authentication"];
    }
    
    return manager;
}

#pragma mark - Refresh Token
static int refreshTokening = 0 ;
+ (NSURLSessionDataTask *)refreshTokenWihtSuccess:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure
{
    if (refreshTokening==1) {  //如果正在刷新token则返回空
        return nil;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    
    if (token==nil) {
        [AppDelegate postSwitchRootViewControllerNotificationWithIsLogin:YES]; return nil;

    }
    NSString *path = [API_HOST stringByAppendingString:@"/m/token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token == nil ? @"" : token;
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithIsToken:YES];
    manager.requestSerializer.timeoutInterval = 20.0f;
    
    refreshTokening = 1 ;
    NSURLSessionDataTask *sessionDataTask = [manager PUT:path parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSONDic = (NSDictionary *)responseObject;
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //            [userDefaults setObject:[JSONDic objectForKey:@"token"] forKey:kSmartDeviceLoginTokenKey];
        //            [userDefaults synchronize];
        refreshTokening = 0 ;

        [HttpRequestToken saveToken:JSONDic[@"token"]];
        !success ?  : success(JSONDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        refreshTokening = 0 ;

        id object = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                
        NSDictionary *errorDic = [NSData zh_JSONFromData:object];
        NSInteger code=[[errorDic objectForKey:@"status_code"] integerValue];
        NSString *message =[errorDic objectForKey:@"message"];
        if (code == 401 && [message isEqualToString:@"token_expired"] ) {
            if (token) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"SaveTokenForText"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SaveTokenForText"];
            }
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"token刷新后端返回异常错误code=%ld message=%@ token==%@",(long)code,message,token] forKey:@"SaveTokenForText"];
        }
        if ([message isEqualToString:@"token_expired"] ||  [message isEqualToString:@"token_invalid"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
            NSLog(@"==刷新token失败==%@===errorDic==%@",token,errorDic);

            [AppDelegate postSwitchRootViewControllerNotificationWithIsLogin:YES]; return ;
        }
   
        
        [self handleErrorUserInfo:error.userInfo errorDomain:nil errorString:nil failure:failure];
    }];
    return sessionDataTask;
}


+ (void)cancelNetworkRequest
{
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [manager invalidateSessionCancelingTasks:YES];
    
    /**
     取消请求：两种取消请求方式
     
     manager还可以发请求
     // 取消之前的所有请求
     [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
     
     2.manager 再也不可用发请求了
     [manager invalidateSessionCancelingTasks:YES];
     */
}

/*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
 typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
 AFNetworkReachabilityStatusUnknown          = -1,      未知
 AFNetworkReachabilityStatusNotReachable     = 0,       无网络
 AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
 AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
 };
 */
+ (void)checkAFNetworkStatus
{
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];

        //这里是监测到网络改变的block
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"===============网络变化了===========");
            
            switch (status) {
                    //            case AFNetworkReachabilityStatusUnknown:
                    //                break;
                case AFNetworkReachabilityStatusNotReachable:
                    [CheckNetwordStatus sharedInstance].isNetword = NO;
                    [CheckNetwordStatus sharedInstance].networdType = NetworkStatusNotReachable ;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [CheckNetwordStatus sharedInstance].isNetword = YES;
                    [CheckNetwordStatus sharedInstance].networdType = NetworkStatusReachableViaWWAN ;
                    
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [CheckNetwordStatus sharedInstance].isNetword = YES;
                    [CheckNetwordStatus sharedInstance].networdType = NetworkStatusReachableViaWiFi ;
                    break;
                default:
                    break;
            }
        }] ;
    
}


#pragma mark - Http DOWNLOAD UPLOAD
//下载
+ (void)httpDownLoad
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //创建URL地址
    NSURL *url = [NSURL URLWithString:@""];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL URLWithString:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成调用的方法
        NSLog(@"%@--%@",response,filePath);
    }];
    
    [task resume];
    
}

+ (void)httpUpLoad
{
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    [AFHTTPSessionManager manager].securityPolicy = securityPolicy;
    
}

//===================  图片上传 ==============================

+ (NSURLSessionDataTask *)httpRequestWithResquestImagePath:(NSData*)imagedata
                                               imageSuffix:(NSString *)imageSuffix
                                                       url:(NSString *)url
                                                    params:(NSDictionary *)params
                                                   isToken:(BOOL)isToken
                                               errorDomain:(NSString *)errorDomain
                                               errorString:(NSString *)errorString
                                                   success:(HttpProgressBlock)progress
                                                   success:(HttpSuccessBlock)success
                                                   failure:(HttpFailureBlock)failure
{
    imageSuffix = [imageSuffix lowercaseString];
    NSDictionary *dic_tion=[self imageFileAppendPartWithFormData:params withImagePath:imageSuffix];
    NSString * mineType = [NSString stringWithFormat:@"image/%@",imageSuffix];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[params objectForKey:@"host"] parameters:dic_tion constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /* 上传图片 */
        [formData appendPartWithFileData:imagedata name:@"file" fileName:[dic_tion  objectForKey:@"name"] mimeType:mineType];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      !progress ?  : progress(uploadProgress.fractionCompleted);
                      NSLog(@"progress ============!!!!!!!!!");
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
                          
                      }
                  }];
    
    [uploadTask resume];
    return uploadTask;
}

+ (NSURLSessionDataTask *)httpUploadWithFile:(NSData *)file
                                  uploadType:(HttpUpLoadFileType)uploadType
                                         url:(NSString *)url
                                      params:(NSDictionary *)params
                                     isToken:(BOOL)isToken
                                 errorDomain:(NSString *)errorDomain
                                 errorString:(NSString *)errorString
                                     success:(HttpProgressBlock)progress
                                     success:(HttpSuccessBlock)success
                                     failure:(HttpFailureBlock)failure
{
    //文件后缀
    NSString *fileSuffix;
    NSString *mineType;
    if (uploadType == HttpUpLoadFileTypeJPEGImage) {
        fileSuffix = @"jpeg";
        mineType = [NSString stringWithFormat:@"image/%@",fileSuffix];
    }else if(uploadType == HttpUpLoadFileTypePNGImage) {
        fileSuffix = @"png";
        mineType = [NSString stringWithFormat:@"video/%@",fileSuffix];
    }else if(uploadType == HttpUpLoadFileTypeMP4Vedio) {
        fileSuffix = @"mp4";
        mineType = [NSString stringWithFormat:@"video/%@",fileSuffix];
    }
    
    NSDictionary *dic_tion=[self imageFileAppendPartWithFormData:params withImagePath:fileSuffix];
    NSLog(@"你上传的文件名是 ============== %@",dic_tion[@"name"]);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[params objectForKey:@"host"] parameters:dic_tion constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /* 上传图片 */
        //        [formData appendPartWithFormData:imagedata name:@"file"];
        [formData appendPartWithFileData:file name:@"file" fileName:[dic_tion objectForKey:@"name"] mimeType:mineType];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                              // This is not called back on the main queue.
                                              // You are responsible for dispatching to the main queue for UI updates
                                              !progress ?  : progress(uploadProgress.fractionCompleted);
                                              
                                          }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              if (error) {
                                                  NSLog(@"Error: %@", error);
                                                  [self handleErrorUserInfo:error.userInfo errorDomain:errorDomain errorString:errorString failure:failure];
                                              } else {
                                                  NSLog(@"%@ %@", response, responseObject);
                                                  [self handleResponse:responseObject errorDomain:errorDomain errorString:errorString success:success failure:failure];
                                                  
                                              }
                                          }];
    
    [uploadTask resume];
    
    return uploadTask;
}
+ (NSURLSessionDataTask *)requestGetWithURL:(NSString *)url
                                  headImage:(UIImage *)headImage
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                imageSuffix:(NSString *)imageSuffix
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpProgressBlock)progressCount
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure{
    
    NSURLSessionDataTask *task;
    
    [self requestGetWithURL:url params:params isToken:isToken errorDomain:errorDomain errorString:errorString success:^(id responseObject) {
        
        NSData *imgData;
        if ([imageSuffix isEqualToString:@"PNG"] || [imageSuffix isEqualToString:@"png"]) {
            imgData = UIImagePNGRepresentation(headImage);
        } else {
            imgData = UIImageJPEGRepresentation(headImage, 1);
        }
        
        [self httpRequestWithResquestImagePath:imgData imageSuffix:imageSuffix url:responseObject  params:responseObject isToken:NO errorDomain:nil errorString:nil success:^(CGFloat progress) {
            progressCount(progress);
        } success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            failure(error);
        }];
        
    } failure:^(NSError *error) {
        failure(error);
        
    }];
    return task;
}

+(NSDictionary*)imageFileAppendPartWithFormData:(NSDictionary*)Diction withImagePath:(NSString*)imageSuffix{
    
    NSMutableDictionary * data_Dic=[[NSMutableDictionary alloc]init];
    
    [data_Dic setObject:[NSString stringWithFormat:@"%@%@.%@",[Diction objectForKey:@"dir"],[Diction objectForKey:@"filename"],imageSuffix] forKey:@"key"];
    [data_Dic setObject:[Diction objectForKey:@"policy"]  forKey:@"policy"];
    [data_Dic setObject:[Diction objectForKey:@"accessid"]  forKey:@"OSSAccessKeyId"];
    [data_Dic setObject:@"200"  forKey:@"success_action_status"];
    [data_Dic setObject:[Diction objectForKey:@"callback"]  forKey:@"callback"];
    [data_Dic setObject:[Diction objectForKey:@"signature"]  forKey:@"signature"];
    [data_Dic setObject:[NSString stringWithFormat:@"%@.%@",[Diction objectForKey:@"filename"],imageSuffix]  forKey:@"name"];

    
    return data_Dic;
}




@end
