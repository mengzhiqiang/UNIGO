//
//  TitleOfHeardViewController.m
//  ALPHA
//
//  Created by teelab2 on 14-7-8.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import "TitleOfHeardViewController.h"
#import "UIHelper.h"
#import "Define.h"
#import "ExtendClass.h"

#import "SVProgressHUD.h"

#import "CustomAlertView.h"

#import "UIBarButtonItem+Extension.h"
#import "AFAlertViewHelper.h"
//#import "SMJWiFiSesultViewController.h"
//#import "SMJWiFiConnectingViewController.h"
//#import "LoginOrRegisterViewController.h"
//#import "SteamEditMainViewController.h"
//#import "SteamMainViewController.h"
//#import "SMJBandViewController.h"
//#import "SMJWiFiScanViewController.h"
//#import "SMJTwoFailViewController.h"
//#import "SMJSelectJettViewController.h"
//#import "SMJBandHelpViewController.h"
@interface TitleOfHeardViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TitleOfHeardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)buildWithNibFile
{
    return [[self alloc]initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark 隐藏加载图标

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self  setHubNetVieW];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor =PersonBackGroundColor;
    [self.view  addSubview:[self headerViewWithTitle:@"UNIGO" target:self colour:[UIColor whiteColor] Landscape:NO ]];
    
    self.headMessageButton.hidden=YES;
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//     handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    _panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:_panGesture];
//    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor=[[UIColor grayColor] colorWithHexString:@"f1f5f8"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

  
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

-(void)handleNavigationTransition:(UIGestureRecognizer*)sender{

}

// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势 Extra argument 'progress' in call
//    if(self.navigationController.childViewControllers.count < 3 || [self isKindOfClass:[GuideUseDeviceViewController class]])
    
//    if ([self isKindOfClass:[SMJWiFiSesultViewController class]] || [self isKindOfClass:[SMJWiFiConnectingViewController class]]|| [self isKindOfClass:[LoginOrRegisterViewController class]]|| [self isKindOfClass:[SteamEditMainViewController class]]|| [self isKindOfClass:[SteamMainViewController class]]|| [self isKindOfClass:[SMJBandViewController class]] || [self isKindOfClass:[SMJWiFiScanViewController class]] || [self isKindOfClass:[SMJTwoFailViewController class]] || [self isKindOfClass:[SMJSelectJettViewController class]] || [self isKindOfClass:[SMJBandHelpViewController class]]) {
//        return NO;
//    }
    
/////滑动位置位于左边界面
    CGPoint translation= [gestureRecognizer locationInView:gestureRecognizer.view];
    if (translation.x >50) {
        return  NO;
    }  if (translation.x > 50) {
        return  false;
    }    return YES;
}

//有效期到 = 1464782448.000000=====当前时间==1464762677.599330====差==-329.506678分钟
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.PromptView_Nav.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController 
    [self.view bringSubviewToFront:self.HeadView];//    [self setupInterfaceOrientationMaskPortrait ];

    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    for (UIView *view in [window subviews]) {
        if ([view isKindOfClass:[CustomAlertView class]]) {
            view.hidden=YES;
            [view removeFromSuperview];
        }
    }
    // 设置导航控制器的代理为self
    self.navigationController.delegate = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
}

- (void)setHubNetVieW
{
    _hublabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 150, 50)];
    _hublabel.textColor=[UIColor clearColor];
    _hublabel.textAlignment=NSTextAlignmentCenter;
    _hublabel.numberOfLines=0;
    _hublabel.font=[UIFont systemFontOfSize:18];
    
    
   UIView *hub_View=[[UIView alloc ]initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2,SCREEN_HEIGHT-100, 180, 30)];
    hub_View.frame=CGRectMake((SCREEN_WIDTH-180)/2,(SCREEN_HEIGHT-80)/2, 180, 80);

    hub_View.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
    hub_View.layer.masksToBounds = YES;
    hub_View.layer.cornerRadius = 5;
    hub_View.layer.borderWidth = 1.0;
    hub_View.layer.borderColor = [[UIColor clearColor] CGColor];
    
    [hub_View addSubview:_hublabel];

    
    _hubView=[[UIView alloc ]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    _hubView.backgroundColor=[UIColor clearColor];
    [_hubView addSubview:hub_View];
}


-(void)backBtnClicked{
    NSLog(@"3werewr");
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnClickedOfRootCV{
    NSLog(@"3234342ewr");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**************************************************************
 ** 功能:     定制navigation bar  二级界面
 ** 参数:     colour（背景颜色）、nsstring（标题）、id（目标对象）
 ** 返回:     uiview
 **************************************************************/
-(UIView*)headerViewWithTitle:(NSString*)title target:(id)sender colour:(UIColor *)colour Landscape:(BOOL)isLandscape{

    if (!_HeadView) {
        _HeadView = [[UIImageView alloc] init] ;
    }
    CGFloat  headHight = 64;
    
    if (iPhoneX) {
        headHight = 88;
    }
    if (isLandscape) {
        headHight = 40;
    }
    _HeadView.frame = CGRectMake(0,0, SCREEN_WIDTH, headHight) ;
    _HeadView.userInteractionEnabled = YES;
    [_HeadView setBackgroundColor:[[UIColor clearColor] colorWithHexString:@"ffffff"]];
    //    _HeadView.image=[UIImage imageNamed:@"mainHead.png"];
    
    _HeadView.contentMode= UIViewContentModeScaleToFill;
    _HeadView.clipsToBounds=NO;
    
    float  LandscapeHight = 24;
    if (iPhoneX) {
        LandscapeHight = 24+20;
    }
    if (isLandscape) {
        LandscapeHight = 0 ;
    }
    UIColor *color_title=[UIColor HexString:@"353535"];
    /////nav 左边按钮
    if (!_headLeftButton) {
        _headLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headimageView=[[UIImageView  alloc]initWithFrame:CGRectMake(11.5, 12, 20, 20)];
        _headimageView.image=[UIImage imageNamed:@"main_btn_back_normal"];
        //    _headimageView.backgroundColor=[UIColor greenColor];
        [_headLeftButton addSubview:_headimageView];
    }
    [_headLeftButton addTarget:sender action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headLeftButton setFrame:CGRectMake(0, LandscapeHight, 50, 40)];
    
    CGFloat wight = 200;
    if (isPAD_or_IPONE4||iPhone5) {
        wight = 160 ;
    }
    if (!_headLabel) {
        _headLabel= [[UILabel alloc] init];
    }
    [_headLabel setFrame:CGRectMake((SCREEN_WIDTH - wight)/2, LandscapeHight,wight, 40)];
    _headLabel.backgroundColor = [UIColor clearColor];
    _headLabel.textAlignment=NSTextAlignmentCenter;
    
    _headLabel.font = [UIFont systemFontOfSize:17];
    
    //    if (IOS_VERSION>=8.0) {
    //        _headLabel.font = [UIFont systemFontOfSize:17 weight:10];
    //    }
    
    _headLabel.text = title;
    _headLabel.textColor = color_title;
    [_HeadView addSubview:_headLabel];
    
    /////nav 右边按钮     /////右边按钮
    if (!_headMessageButton) {
        _headMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_headMessageButton addTarget:sender action:@selector(RightMessageOfTableView) forControlEvents:UIControlEventTouchUpInside];
    _headMessageButton.frame=CGRectMake(SCREEN_WIDTH-72, LandscapeHight, 70, 40);
    _headMessageButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [_headMessageButton setTitleColor: [UIColor HexString:@"000000"] forState:UIControlStateNormal];
    _headMessageButton.hidden=YES;
    /////nav 左边按钮 关闭当前页
    //    _leftShutDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_leftShutDownButton addTarget:sender action:@selector(ShutDownVc) forControlEvents:UIControlEventTouchUpInside];
    //    _leftShutDownButton.frame=CGRectMake(60, 20, 50, 44);
    //    _leftShutDownButton.titleLabel.font=[UIFont systemFontOfSize:17];
    //    [_leftShutDownButton setTitleColor: color_title forState:UIControlStateNormal];
    //    [_leftShutDownButton setTitle:@"关闭" forState:UIControlStateNormal];
    //    _leftShutDownButton.hidden=YES;
    
    [_HeadView addSubview:_headMessageButton  ];
    [_HeadView addSubview:_leftShutDownButton];
    [_HeadView addSubview:_headLeftButton];
    
    [self.view  insertSubview:_HeadView atIndex:100];

    return _HeadView;
}

- (void)RightMessageOfTableView
{
    
}

///设置位圆角
-(UIView*)markround:(UIView*)view radius:(float)rad Width:(float)wid Color:(UIColor*)color{
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = rad;
    view.layer.borderWidth = wid;
    view.layer.borderColor = [color CGColor];
    
    return view;
}

-(void)ShutDownVc{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  顶栏错误提示
-(void)promtNavHidden:(NSString*)title{
    
    [UIHelper showUpMessage:title];return;
  
}
/* 副标题 */
-(void)setHeadSubTitle:(NSString*)title{
    
    self.headLabel.top = 26 ;
    if (!_headSubLabel) {
        _headSubLabel = [[UILabel alloc]init];
        _headSubLabel.textColor =[UIColor HexString:@"8b8c90"];
        _headSubLabel.font = [UIFont systemFontOfSize:10];
        _headLabel.top = 25;
        if (iPhoneX) {
            _headLabel.top = 35;
        }
        _headLabel.height = 18;
        _headLabel.font = [UIFont systemFontOfSize:13];
        _headSubLabel.textAlignment = NSTextAlignmentCenter ;
        _headSubLabel.frame = CGRectMake((SCREEN_WIDTH-100)/2, self.headLabel.bottom+3, 100, 12);
    }
    _headSubLabel.text = title;
    [self.HeadView addSubview:_headSubLabel];
}

///改竖屏
-(void)changeLandscap{
//    [self setupInterfaceOrientationMaskLandscape];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
