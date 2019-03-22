//
//  AdvertisingView.m
//  SmartDevice
//
//  Created by zhiqiang meng on 2018/7/20.
//  Copyright © 2018年 TeeLab. All rights reserved.
//

#import "AdvertisingView.h"
//#import "WKwebViewController.h"
#import "UIViewController+Extension.h"

static int imageTime ;

@interface AdvertisingView()

/** 广告图的显示时间*/
@property (nonatomic, assign) NSInteger ADShowTime;

/** 图片路径*/
@property (nonatomic, copy) NSString *imgFilePath;

/** 图片对应的url地址*/
@property (nonatomic, copy) NSString *imgLinkUrl;

/** 广告图的有效时间*/
@property (nonatomic, copy) NSString *imgDeadline;

@end

@implementation AdvertisingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addAdvertisingImageView];
    }
    
    return self;
}
/*
 启动之后添加广告
 */
-(void)addAdvertisingImageView{
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    _imangeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    /* 获取 云端广告信息 根据时间显示*/
    NSData *adData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADInformation"];
    if (adData.length<1) {
        [self   updateAdvertisingInformation];
        return;
    }
    NSDictionary * diction = [NSData zh_JSONFromData:adData ];
    NSLog(@"====diciton==%@",diction);

    BOOL isShowAD = [self checkProductDate:[diction objectForKey:@"started_at"] withEndDate:[diction objectForKey:@"ended_at"]];

    if (isShowAD) {
        NSString *filePath = [AdvertisingView documentAchiverHomeMetadPath:@""]; // 保存文件的名称
        NSData *data=[NSData dataWithContentsOfFile:filePath options:0 error:NULL];//从FileName中读取出数据
        if (data) {
            _imangeView.image = [UIImage imageWithData:data];
        }
    }else{
        return ;
    }
    
    [window addSubview:_imangeView];
    [window bringSubviewToFront:_imangeView];
    _imangeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushWebPageVC:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_imangeView addGestureRecognizer:tapGestureRecognizer];
    
//    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = _imangeView.bounds;
//    [btn addTarget:self action:@selector(pushWebPageVC:) forControlEvents:UIControlEventTouchUpInside];
//    [_imangeView addSubview:btn];
    
    
    _TimeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _TimeButton.frame = CGRectMake(SCREEN_WIDTH-58-17,(iPhoneX?50:25), 58, 20);
    [_TimeButton setTitle:@"3 跳过" forState:UIControlStateNormal];
    _TimeButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
    [_TimeButton draCirlywithColor:nil andRadius:_TimeButton.height/2];
    
    _TimeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_TimeButton addTarget:self action:@selector(hidden:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_TimeButton];
    _TimeButton.userInteractionEnabled = YES;
    imageTime = 3;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hiddenImageView:) userInfo:nil repeats:YES];

}
-(void)hiddenImageView:(NSTimer*)timer{
    
    imageTime--;
    [_TimeButton setTitle:[NSString stringWithFormat:@"%d 跳过",imageTime] forState:UIControlStateNormal];
    if (imageTime<0) {
        [self hidden:nil];
        [timer invalidate];
        timer = nil;

    }
}

-(void)pushWebPageVC:(UIGestureRecognizer*)gesture{
    
    NSString *url =  [[NSUserDefaults standardUserDefaults] objectForKey:@"adUrl"];
    NSLog(@"==pushWebPageVC==%@",url);
    if ([NSString judgeIsEmptyWithString:url]) {
        return ;
    }
    
    [self hidden:nil];
    [_imangeView removeGestureRecognizer:gesture];
    
//    WKwebViewController* findVC = [[WKwebViewController alloc]init];
//    findVC.webUrl = url;
//    [[UIViewController getCurrentController].navigationController pushViewController:findVC animated:YES];
}

-(void)hidden:(UIButton*)sender{
    NSLog(@"===隐藏==");
    _imangeView.hidden = YES;
    [_imangeView removeFromSuperview];
    
    _TimeButton.hidden = YES;
    [_TimeButton removeFromSuperview];

    [self updateAdvertisingInformation];

}

/**
 *  下载新的图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName imgLinkUrl:(NSString *)imgLinkUrl imgDeadline:(NSDictionary *)adDiction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self documentAchiverHomeMetadPath:imageName]; // 保存文件的名称
        
        BOOL saveSuccess = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        if (saveSuccess) {
            
            // 保存成功
            //判断保存下来的图片名字和本地沙盒中存在的图片是否一致，如果不一致，说明图片有更新，此时先删除沙盒中的旧图片，如果一致说明是删除缓存后再次下载，这时不需要进行删除操作，否则找不到已保存的图片
            if (![imageName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"adImageName"] ]) {
                [self deleteOldImage];
            }
            if ([NSString judgeIsEmptyWithString:imgLinkUrl] ) {
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"adUrl"];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:imgLinkUrl forKey:@"adUrl"];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:@"adImageName"];
            NSData *data = [NSData zh_dataFromJSON:adDiction] ;
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ADInformation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            NSLog(@"保存失败");
        }
        
    });
}
/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:@"adImageName"];
    
    if (imageName) {
        
        NSString *filePath = [self documentAchiverHomeMetadPath:imageName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"adImageName"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"adUrl"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"adDeadline"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

//沙盒目录下的存储目录，分类数据存储位置
+ (NSString *)documentAchiverHomeMetadPath:(NSString*)imageName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:@"adVertisingImage"];
}
-(void)updateAdvertisingInformation{
    
    NSString *pathUrl = [NSString stringWithFormat:@"%@",[API_HOST stringByAppendingString:jett_AD_splash]];
//    __weak typeof (self)  weakSelf = self;
    
    [HttpEngine requestGetWithURL:pathUrl params:@{@"platform":@"ios"} isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        NSArray * array = [(NSDictionary*)responseObject objectForKey:@"data"];
        if (array.count<1) {
            return ;
        }
        int x = arc4random() % array.count;
        
        NSDictionary* diction = [array objectAtIndex:x];
        NSLog(@"responseObject广告==");
        NSString * imageString = [[diction objectForKey:@"image_url"] objectForKey:@"medium"];
        if (iPhoneX) {
            imageString = [[diction objectForKey:@"image_url"] objectForKey:@"large"];
        }
        [AdvertisingView downloadAdImageWithUrl:imageString imageName:@"" imgLinkUrl:[diction objectForKey:@"link"] imgDeadline:diction];
        NSLog(@"responseObject广告==%@",responseObject);
    } failure:^(NSError *error) {
        
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"error广告==%@",error);

    }];
    
}

//判断是否早于当前时间
- (BOOL)checkProductDate: (NSString *)startDate withEndDate:(NSString*)endDate{
    /* 首先判断开始时间是否早于当前日期，是则判断结束时间是否晚于当前日期，是则判断今天是否已经显示过,未显示过则返回yes*/
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date_start = [dateFormatter dateFromString:startDate];
    NSDate *date_end = [dateFormatter dateFromString:endDate];

    // 判断是否早于当前时间
    if ([date_start earlierDate:[NSDate date]] == date_start) {
        
        if ([date_end laterDate:[NSDate date]] == date_end) {
            
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString* string = [ dateFormatter stringFromDate:[NSDate date]];
//           NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"showDate"];
//            if (![date isEqualToString:string]) {
//                [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"showDate"];
//                return YES ;
//            }
            return YES ;

        } else {

        }
    } else {

    }
    return NO;

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
