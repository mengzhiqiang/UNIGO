//
//  AFPhotoAlbumHelper.m
//  AFJiaJiaMob
//
//  Created by singelet on 2016/12/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFPhotoAlbumHelper.h"
#import "CheckNetwordStatus.h"
#import "AFAlertViewHelper.h"
#import "LCActionSheet.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation AFPhotoAlbumHelper

#pragma mark - AFPickerOperationViewDelegate
+ (void)checkNetworkIfAllowUpload:(PhotoUploadNetworkCallBack)callBack
{
    if ([CheckNetwordStatus sharedInstance].isNetword) {
        NSLog(@"目前有网络");
        if ([CheckNetwordStatus sharedInstance].networdType == NetworkStatusReachableViaWiFi) {
            callBack(YES);
        }
        else if ([CheckNetwordStatus sharedInstance].networdType == NetworkStatusReachableViaWWAN) {
            UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [AFAlertViewHelper alertViewWithTitle:@"温馨提示" message:@"当前不是连接 Wi-Fi 网络,上传文件可能会产生流量费用。" delegate:rootController cancelTitle:@"上传" otherTitle:@"取消" clickBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    callBack(NO);
                }
                else {
                    callBack(YES);
                }
            }];
        }
    }
    else {
        [AFAlertViewHelper alertViewWithTitle:@"温馨提示" message:@"抱歉，你当前没有连接网络,请检查网络设置。" delegate:nil cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
            NSLog(@"buttonIndex");
            callBack(NO);
        }];
    }
}


+ (void)checkSystemPermissionWithCount:(NSInteger)count isTtile:(BOOL)isTitle callBack:(void(^)(NSInteger index))callBack
{
    NSString *title;
    if (isTitle) {
        title = [NSString stringWithFormat:@"已储存 %lu 项",(long)count];
    }
    else {
        title = nil;
    }
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:title buttonTitles:@[@"选取照片",@"拍照"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            //判断状态，请求权限。有权限再打开控制器
            if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        !callBack? : callBack(0);
                    }
                    else {
                        [AFAlertViewHelper alertViewWithTitle:@"无法获取相册权限" message:nil delegate:nil cancelTitle:@"取消" otherTitle:@"设置" clickBlock:^(NSInteger buttonIndex) {
                            //跳入当前App设置界面,
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }
                        }];
                    }
                }];
            }
            else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
                !callBack? : callBack(0);
            }
            else {
                [AFAlertViewHelper alertViewWithTitle:@"无法获取相册权限" message:nil delegate:nil cancelTitle:@"取消" otherTitle:@"设置" clickBlock:^(NSInteger buttonIndex) {
                    //跳入当前App设置界面,
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
            }
        }
        else if(buttonIndex == 1) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            //判断状态，请求权限。有权限再打开控制器
            if (authStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                    if (granted) {
                        !callBack? : callBack(1);
                    }
                    else {
                    }
                }];
            }
            else if (authStatus == AVAuthorizationStatusAuthorized){
                !callBack? : callBack(1);
            }
            else {
                [AFAlertViewHelper alertViewWithTitle:@"无法获取相机权限" message:nil delegate:nil cancelTitle:@"取消" otherTitle:@"设置" clickBlock:^(NSInteger buttonIndex) {
                    //跳入当前App设置界面,
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
            }
        }
    }];
    if (isTitle) {
        [sheet show];
    }
    else {
         [sheet showWithColor:[UIColor HexString:@"2c2c2c"]];
    }
}


+ (void)checkSystempPhotoAlbumPermissionWithCallBack:(void(^)(NSInteger index))callBack
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                !callBack? : callBack(0);
            }
            else {
                [AFAlertViewHelper alertViewWithTitle:@"无法获取相册权限" message:nil delegate:nil cancelTitle:@"取消" otherTitle:@"设置" clickBlock:^(NSInteger buttonIndex) {
                    //跳入当前App设置界面,
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }else{
                        !callBack? : callBack(10);
                        
                    }
                }];
            }
        }];
    }
    else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        !callBack? : callBack(0);
    }
    else {
        [AFAlertViewHelper alertViewWithTitle:@"无法获取相册权限" message:nil delegate:nil cancelTitle:@"取消" otherTitle:@"设置" clickBlock:^(NSInteger buttonIndex) {
            //跳入当前App设置界面,
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }else{
                !callBack? : callBack(10);

            }
        }];
    }

}

@end
