//
//  NETworking.m
//  ALPHA
//
//  Created by teelab2 on 14-5-15.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//


#import "CommonVariable.h"
#import "AFNetworking.h"

#define FONT_URL [NSURL URLWithString:@"http://oss-smartDevice-image.oss-cn-shenzhen.aliyuncs.com"] //测试
//#define FONT_URL [NSURL URLWithString:@"http://official-smartDevice-image.oss-cn-shenzhen.aliyuncs.com"] //生产

#define COMMON_UHEAD @"\\U0000"

static CommonVariable *commVari = nil;
@implementation CommonVariable{
    BOOL downFont;
    BOOL downString;
    NSString *fontVersion;
}


- (id)init{
    if (self = [super init]) {
        _isLogin = NO;
        _unification = [[Unification alloc]init];
        _LoadImage_Array=[[NSMutableArray alloc]init];
//        _userInfoStr = nil;
        
        
        
        for (int i=0; i<59; i++) {
            [_LoadImage_Array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"2X00%d.png",i+1]]];
        }
        
    }
    return self;
}



/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareCommonVariable{
    if (!commVari) {
        commVari = [[CommonVariable alloc] init];
    }
    return commVari;
}


/**************************************************************
 ** 功能:     更新全局数据
 ** 参数:     newdic 后台返回更新数据
 ** 返回:     nil  直接保存到plist文件
 **************************************************************/
-(void)UpdateGlobalData:(NSDictionary*)NewDIc{

    
    [[CommonVariable shareCommonVariable] setIS_SystemInit:YES];
    
    
    NSString *fileName = [[NewDIc objectForKey:@"font"] objectForKey:@"text"];
    NSString *version = [[NewDIc objectForKey:@"font"] objectForKey:@"value"];
    NSString *perVer = [[NSUserDefaults standardUserDefaults] objectForKey:@"shapeIcon"];
    if ([version compare:perVer options:NSNumericSearch] == NSOrderedDescending) {
        fontVersion = version;
        [self downloadImage:[FONT_URL URLByAppendingPathComponent:fileName] andFilename:fileName];
        [self downloadFontString:[FONT_URL URLByAppendingPathComponent:[fileName stringByAppendingString:@".txt"]] andFilename:[fileName stringByAppendingString:@".txt"]];
    }
    
    return;
    
    
}


/**************************************************************
 ** 功能:     下载字体对应的字符
 ** 参数:     URL  路径    fileName   文件名
 ** 返回:     nil  保存到手机
 **************************************************************/
-(void)downloadFontString:(NSURL *)URL andFilename:(NSString *)fileName{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:@"shape.txt"];
        
        [self backupFontFile:documentsDirectoryURL.path];
        
        return documentsDirectoryURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if (error == nil) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:filePath.path]) {
                NSLog(@"has");
                [self delBackupFontFile:filePath.path]; //删除备份的数据
                NSError *aError = nil;
                NSString *shapeString = [[NSString alloc] initWithContentsOfFile:filePath.path encoding:NSUTF8StringEncoding error:&aError];
                if (shapeString) {
                    NSArray *shapeArr = [shapeString componentsSeparatedByString:@","];
                    [[NSUserDefaults standardUserDefaults] setObject:shapeArr forKey:@"shapeString"];
                    downString = YES;
                    if (downFont && downString) {
                        [[NSUserDefaults standardUserDefaults] setObject:fontVersion forKey:@"shapeIcon"];
                    }
                }
            }
        }else{
            [self reverFontFile:filePath.path];
        }
        
        
        
    }];
    [downloadTask resume];
}

/**************************************************************
 ** 功能:     下载字体文件
 ** 参数:     URL  路径    fileName   文件名
 ** 返回:     nil  保存到手机
 **************************************************************/
-(void)downloadImage:(NSURL *)URL andFilename:(NSString *)fileName{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *downURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:@"shape.ttf"];
        [self backupFontFile:downURL.path];
        
        return downURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if (error == nil) {
            [self delBackupFontFile:filePath.path];
            downFont = YES;
            if (downFont && downString) {
                [[NSUserDefaults standardUserDefaults] setObject:fontVersion forKey:@"shapeIcon"];
            }
        }else{
            [self reverFontFile:filePath.path];
        }
        
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        
//        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"shape" ofType:@"ttf"];
//        
//        if ([fileManager fileExistsAtPath:filePath1]) {
//            NSLog(@"has");
//            NSError *aError = nil;
//            BOOL isReplace = [fileManager replaceItemAtURL:[NSURL URLWithString:filePath1] withItemAtURL:filePath backupItemName:nil options:NSFileManagerItemReplacementWithoutDeletingBackupItem resultingItemURL:nil error:&aError];
//            if (isReplace) {
//                NSLog(@"has dele");
//            }
//        }
        
    }];
    [downloadTask resume];
}


/**************************************************************
 ** 功能:     备份字体文件
 ** 参数:     需要备份的文件路径
 ** 返回:
 **************************************************************/
-(void)backupFontFile:(NSString *)filePath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager moveItemAtPath:filePath toPath:[filePath stringByAppendingString:@".bak"] error:&error];
    }
}

/**************************************************************
 ** 功能:     删除备份字体文件
 ** 参数:     备份文件路径
 ** 返回:
 **************************************************************/
-(void)delBackupFontFile:(NSString *)filePath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[filePath stringByAppendingString:@".bak"]]) {
        NSError *error;
        [fileManager removeItemAtPath:[filePath stringByAppendingString:@".bak"] error:&error];
    }
}


/**************************************************************
 ** 功能:     恢复备份的字体文件
 ** 参数:     需要恢复的文件路径
 ** 返回:
 **************************************************************/
-(void)reverFontFile:(NSString *)filePath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[filePath stringByAppendingString:@".bak"]]) {
        NSError *error;
        [fileManager moveItemAtPath:[filePath stringByAppendingString:@".bak"] toPath:filePath error:&error];
    }
}


/**************************************************************
 ** 功能:     设置网络通
 ** 参数:
 ** 返回:
 **************************************************************/
-(void)loadNewNetWorkIsYes{

    _isNetword=YES;
    
}



@end
