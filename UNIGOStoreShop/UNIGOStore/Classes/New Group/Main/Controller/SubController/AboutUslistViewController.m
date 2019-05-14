//
//  AboutUslistViewController.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/5/18.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AboutUslistViewController.h"
#import "FeedbackViewController.h"

#import "DeviceTableViewCell.h"
#import "WKwebViewController.h"
#import "UIViewController+navigationBar.h"
#import "AFCustomImageAlertView.h"
#import "AFAccountEngine.h"
#import "LCActionSheet.h"

@interface AboutUslistViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  AFCustomImageAlertView * alertImageView;

@end

@implementation AboutUslistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headLabel.text = @"设置";
    self.automaticallyAdjustsScrollViewInsets = NO;   ////scrollview 下移20像素的问题

    _rootTableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-100);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle=UITableViewCellAccessoryNone;
    _rootTableView.backgroundColor= PersonBackGroundColor;
    self.view.backgroundColor=PersonBackGroundColor;

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];

    NSString *OldVersionID = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *DisplayName = [infoDic objectForKey:@"CFBundleDisplayName"];

    _jfjVersionLabel.text=[NSString stringWithFormat:@"%@ V%@",DisplayName,OldVersionID];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     if (section ==0) {
        return 3 ;
     }
    return  1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DeviceTableViewCell";
    
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.backgroundColor=[UIColor clearColor];
    
    //*****************图片*****************************//
    
    cell.headImageView.hidden=NO;
    cell.pushNextLabel.text=@"";
    cell.titleNameLabel.frame = CGRectMake(18, 15, 100, 20);
//    if (indexPath.section==0) {
//        cell.titleNameLabel.text = @"账号与安全";
//
//    }
//    else if (indexPath.section == 2) {
//        cell.titleNameLabel.text = @"清除缓存";
//        cell.pushNextLabel.text  = [NSString stringWithFormat:@"%.2fM",[self getFilePath]];
//
//    }else
    if (indexPath.section == 0)  {
        NSArray  *arr_titile  = @[@"清除缓存",@"去评分",@"用户协议"];
        cell.titleNameLabel.text=[arr_titile  objectAtIndex:indexPath.row];
        cell.lineLabel1.hidden = NO;
        cell.pushTagImageView.hidden= NO;
        if (indexPath.row==0) {
        cell.pushNextLabel.text  = [NSString stringWithFormat:@"%.2fM",[self getFilePath]];

        }

    }else{
//        cell.titleNameLabel.text = @"退出登录";
//        cell.pushTagImageView.hidden = YES;
//        cell.titleNameLabel.frame = CGRectMake(0, 0,SCREEN_WIDTH , cell.height);
//        cell.titleNameLabel.textAlignment = NSTextAlignmentCenter ;
//        cell.titleNameLabel.textColor = [UIColor redColor];
//        cell.titleNameLabel.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
    return  178;
    }
    return 20 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        _headRootView.frame = CGRectMake(0, 0, ScreenH, 178);
        return _headRootView;
    }
    
    return nil;
    
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"===%ld",(long)indexPath.row);
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    {
                        [self clearCache];

                    }
                    break;
                case 1:
                {
                    ////跳转AppStore 评论页
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1462755665&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];

                }
                    break;
                case 2:
                {
                    WKwebViewController *cwb = [[WKwebViewController alloc]init];
                    cwb.headTitle = @"用户协议";
                    cwb.webUrl = WEBURL_Agreement;
                    [self.navigationController pushViewController:cwb animated:YES];
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 1:
            [self showActionSheetViewTelphoe];
            break;
        default:
            break;
    }
}

- (void)showActionSheetViewTelphoe {
    
    __weak typeof (self) myself = self;
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确认退出登录吗？" buttonTitles:@[@"退出登录"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 0) {
            [myself logout];
        }
        NSLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
    }];
    [sheet show];
    
}
/*退出登录*/
- (void)logout {
    
    //   [UIHelper alertWithTitle:@"确定要退出登录吗" andMSG:nil delegate:self andTag:102];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASS_WORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceUseInfornKey];
    
//    [[CommonVariable shareCommonVariable]setUserInfoo:nil];
//    //退出网易云信
//    [[AFNIMEngine sharedInstance] logoutNIMSDK];
 
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[AFAccountEngine sharedInstance] setCurrentAccount:nil];
    
}

#pragma mark  跳转到qq
//- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
//
//    ////跳转AppStore 评论页
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1095903275&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
//    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"619273426",@"126ebffc0ceb54899d9cebd7e8a150d095be7588ce4497cbc7f36807da8bb11b"];     ////QQ群
//    if (key) {
//        urlStr = @"mqq://im/chat?chat_type=wpa&uin=3422431057&version=1&src_type=web";   /// qq号
//    }
//    NSURL *url = [NSURL URLWithString:urlStr];
//    if([[UIApplication sharedApplication] canOpenURL:url]){
//        [[UIApplication sharedApplication] openURL:url];
//        return YES;
//    }
//    else return NO;
//}


/*
 
 清除缓存
 
 */
-(void)clearCache{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       //                       NSString *cachPath0 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       //
                       //                       NSArray *files0 = [[NSFileManager defaultManager] subpathsAtPath:cachPath0];
                       //                       NSLog(@"files :%lu",(unsigned long)[files0 count]);
                       //                       for (NSString *p in files0) {
                       //
                       //                           NSLog(@"NSDocumentDirectory-->files :%@",p);
                       //
                       //                           if ([p isEqualToString:@""] || [p rangeOfString:kJiaJiaMobBabiesRobotsInformation].location != NSNotFound|| [p rangeOfString:kJiaJiaMobBabiesInformation].location != NSNotFound|| [p rangeOfString:kJiaJiaMobAccountInformation].location != NSNotFound || [p rangeOfString:kJiaJiaMobPhotoFileName].location != NSNotFound) {
                       //                               NSLog(@"NSDocumentDirectory-不删除的文件->files :%@",p);
                       //                               continue;
                       //                           }
                       //                           NSError *error;
                       //                           NSString *path = [cachPath0 stringByAppendingPathComponent:p];
                       //                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                       //                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                       //                           }
                       //                       }
                       /*
                        聊天暂时不给删除
                        */
                       //                       [AFChatRecordEngine removeNIMChatRecord]; ///删除聊天记录
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSLog(@"NSCachesDirectory--->files :%@",p);
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       
                       //                       NSFileManager *fileManager=[NSFileManager defaultManager];
                       //                       if ([fileManager fileExistsAtPath:cachPath]) {
                       //                           NSArray *fileNames = [fileManager subpathsAtPath:cachPath];
                       //                           for (NSString *fileName in fileNames) {
                       //                               NSString *absolutePath = [cachPath stringByAppendingPathComponent:fileName];
                       //                               [fileManager removeItemAtPath:absolutePath error:nil];
                       //                           }
                       //                       }
                       
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
}

#pragma mark 统计缓存
///////统计缓存数据大小
-(float)getFilePath{
    //文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    unsigned long long cacheFolderSize = 0;
    
    //缓存路径
    //    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *cacheDir = [cachePaths objectAtIndex:0];
    //    NSArray *cacheFileList;
    //    NSEnumerator *cacheEnumerator;
    //    NSString *cacheFilePath;
    //    unsigned long long cacheFolderSize1 = 0;
    
    //    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    //    cacheEnumerator = [cacheFileList objectEnumerator];
    //    while (cacheFilePath = [cacheEnumerator nextObject]) {
    //
    //        if ([cacheFilePath rangeOfString:kJiaJiaMobBabiesRobotsInformation].location != NSNotFound|| [cacheFilePath rangeOfString:kJiaJiaMobBabiesInformation].location != NSNotFound|| [cacheFilePath rangeOfString:kJiaJiaMobAccountInformation].location != NSNotFound ||[cacheFilePath rangeOfString:kAFPhotoDatabaseSubPath].location != NSNotFound || [cacheFilePath rangeOfString:kAFPhotoTempUploadFilesSubPath].location != NSNotFound) {
    //            continue;
    //        }
    //
    //        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
    //        cacheFolderSize += [cacheFileAttributes fileSize];
    //    }
    
    //单位MB
    /*  另一种计数方法  */
    //
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    //    NSLog(@"NSCachesDirectory==files :%lu",(unsigned long)[files count]);
    for (NSString *p in files) {
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        cacheFolderSize += [cacheFileAttributes fileSize];
    }
    
    
    return (float)cacheFolderSize/1024/1024;
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    [_rootTableView reloadData];
    [UIHelper showUpMessage:@"清理完成" withColor:BackGreenGColor_Nav];
    
}

/* 二维码 关注*/
-(void)weixinNumber{
    if (!_alertImageView) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AFCustomImageAlertView" owner:self options:nil];
        //得到第一个UIView
        _alertImageView = [nib objectAtIndex:0];
        [_alertImageView setFrame:self.view.bounds];
        [self.view addSubview:_alertImageView];
        
    }
    _alertImageView.hidden=NO;
    [_alertImageView alertViewOfImage:[UIImage imageNamed:@"img_code"] title:@"奥睿智能科技" subtitle:@"微信公众号：Auric_2016" buttonTitle:@"保存二维码"];
    _alertImageView.backEnterWechatBlock = ^(){
        NSURL *url = [NSURL URLWithString:@"weixin://qr/"];
        [[UIApplication sharedApplication] openURL:url];
    };
}


@end
