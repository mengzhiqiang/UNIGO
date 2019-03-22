//
//  AFPhotoAlbumHelper.h
//  AFJiaJiaMob
//
//  Created by singelet on 2016/12/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

//检查上传网络状态回调
typedef void(^PhotoUploadNetworkCallBack)(BOOL allow);

@interface AFPhotoAlbumHelper : NSObject

+ (void)checkNetworkIfAllowUpload:(PhotoUploadNetworkCallBack)callBack;

+ (void)checkSystemPermissionWithCount:(NSInteger)count isTtile:(BOOL)isTitle callBack:(void(^)(NSInteger index))callBack;

+ (void)checkSystempPhotoAlbumPermissionWithCallBack:(void(^)(NSInteger index))callBack;

@end
