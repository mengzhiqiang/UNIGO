//
//  HttpEngine.h
//  SmartDevice
//
//  Created by singelet on 16/6/12.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**  网络请求错误预留参数  现在传空
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 */

typedef void (^HttpSuccessBlock)(id responseObject);
typedef void (^HttpFailureBlock)(NSError *error);
typedef void (^HttpProgressBlock)(CGFloat progress);

typedef void (^HttpTaskBlock)(id responseObject);

typedef NS_ENUM(NSInteger, HttpUpLoadFileType) {
    HttpUpLoadFileTypeJPEGImage = 1 << 1,
    HttpUpLoadFileTypePNGImage = 1 << 2,
    HttpUpLoadFileTypeMP4Vedio = 1 << 3,
    
};

typedef NS_ENUM(NSInteger, HttpRequestType) {
    HttpRequestTypePost = 1 << 1,
    HttpRequestTypeGet = 1 << 2,
    HttpRequestTypeDelete = 1 << 3,
    HttpRequestTypePut = 1 << 4,
    HttpRequestTypePatch = 1 << 5
};



@interface HttpEngine : NSObject

/**
 *  Http 发送一个POST请求
 *
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestPostWithURL:(NSString *)url
                                      params:(NSDictionary *)params
                                     isToken:(BOOL)isToken
                                 errorDomain:(NSString *)errorDomain
                                 errorString:(NSString *)errorString
                                     success:(HttpSuccessBlock)success
                                     failure:(HttpFailureBlock)failure;



/**
 *  Http 发送一个GET请求
 *
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestGetWithURL:(NSString *)url
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure;

/**
 *  Http 发送一个DELETE请求
 *
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestDeleteWithURL:(NSString *)url
                                        params:(NSDictionary *)params
                                       isToken:(BOOL)isToken
                                   errorDomain:(NSString *)errorDomain
                                   errorString:(NSString *)errorString
                                       success:(HttpSuccessBlock)success
                                       failure:(HttpFailureBlock)failure;

/**
 *  Http 发送一个PUT请求
 *
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestPutWithURL:(NSString *)url
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure;

/**
 *  Http 发送一个PATCH请求
 *
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestPatchWithURL:(NSString *)url
                                       params:(NSDictionary *)params
                                      isToken:(BOOL)isToken
                                  errorDomain:(NSString *)errorDomain
                                  errorString:(NSString *)errorString
                                      success:(HttpSuccessBlock)success
                                      failure:(HttpFailureBlock)failure;


/**
 *  Http 发送一个网络请求
 *
 *  @param requestType 请求类型
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)httpRequestWithResquestType:(HttpRequestType)requestType
                                                  url:(NSString *)url
                                               params:(NSDictionary *)params
                                              isToken:(BOOL)isToken
                                          errorDomain:(NSString *)errorDomain
                                          errorString:(NSString *)errorString
                                              success:(HttpSuccessBlock)success
                                              failure:(HttpFailureBlock)failure;


#pragma mark - Refresh Token
/*
    刷新token
 */
+ (NSURLSessionDataTask *)refreshTokenWihtSuccess:(HttpSuccessBlock)success
                                          failure:(HttpFailureBlock)failure;


/**
 *  Http 发送一个网络请求 上传图片
 *
 *  @param Image       图片或视频 二进制 Data
 *  @imageSuffix       图片后缀
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param success     请求成功后的回调
 *  @param pregress    上传大小回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)httpRequestWithResquestImagePath:(NSData*)imagedata
                                               imageSuffix:(NSString *)imageSuffix
                                                       url:(NSString *)url
                                                    params:(NSDictionary *)params
                                                   isToken:(BOOL)isToken
                                               errorDomain:(NSString *)errorDomain
                                               errorString:(NSString *)errorString
                                                   success:(HttpProgressBlock)progress
                                                   success:(HttpSuccessBlock)success
                                                   failure:(HttpFailureBlock)failure;

/**
 *  文件上传
 *
 *  @param files       要上传的 NSData
 *  @param uploadType  上传的文件类型
 *  @param url         请求路径
 *  @param params      请求参数
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param progress    上传进度回调
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 *
 *  @return NSURLSessionDataTask 用来取消任务
 */
+ (NSURLSessionDataTask *)httpUploadWithFile:(NSData *)file
                                  uploadType:(HttpUpLoadFileType)uploadType
                                         url:(NSString *)url
                                      params:(NSDictionary *)params
                                     isToken:(BOOL)isToken
                                 errorDomain:(NSString *)errorDomain
                                 errorString:(NSString *)errorString
                                     success:(HttpProgressBlock)progress
                                     success:(HttpSuccessBlock)success
                                     failure:(HttpFailureBlock)failure;

/**
 *  Http 发送一个GET请求 上传图片
 *
 *  @param url         请求路径
 *  @headImage         上传的图片
 *  @param params      请求参数
 *  @imageSuffix       图片后缀
 *  @param isToken     是否需要token
 *  @param errorDomain 错误域名
 *  @param errorString 错误字符串
 *  @param progress    上传进度回调
 *  @param success     请求成功后的回调
 *  @param failure     请求失败后的回调
 */

+ (NSURLSessionDataTask *)requestGetWithURL:(NSString *)url
                                  headImage:(UIImage *)headImage
                                     params:(NSDictionary *)params
                                    isToken:(BOOL)isToken
                                imageSuffix:(NSString *)imageSuffix
                                errorDomain:(NSString *)errorDomain
                                errorString:(NSString *)errorString
                                    success:(HttpProgressBlock)progressCount
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure;



/**
 *  取消网络请求
 */
+ (void)cancelNetworkRequest;

/**
 *  检测当前网络状态
 */
+ (void)checkAFNetworkStatus;


#pragma mark - Http DOWNLOAD UPNLOAD
//下载
+ (void)httpDownLoad;

@end
