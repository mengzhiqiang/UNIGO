//
//  WKwebViewController.m
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/20.
//  Copyright © 2017年 TeeLab. All rights reserved.
//
#import "UIViewController+navigationBar.h"
#import "WKwebViewController.h"
#import "CheckNetwordStatus.h"

@interface WKwebViewController ()
{
    
    UIView    *  rootView;
    UIImageView *bg_imageView;
    UIWebView *callWebview ;
    UIButton* _headMessageButton;
}
@property (strong,nonatomic) UIButton *colseBtn;
@property (assign,nonatomic) BOOL  isCall;

@end

@implementation WKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;   ////scrollview 下移20像素的问题

    self.headLabel.text = _headTitle;
    _loadCount = 1;
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.HeadView.height+1, self.view.frame.size.width, self.view.frame.size.height-self.HeadView.height)];
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    // 2.创建请求
    NSMutableURLRequest *request;
    // 3.加载网页
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    }
    else {
        request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    }

    [_webView loadRequest:request];
    self.webView.navigationDelegate = self ;
    // 最后将webView添加到界面3000 *0.03 =90  (10000-3000)*10% =700 3000*20%=600
    [self.view addSubview:_webView];
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    
    
    if (_IS_hiddenNav) {
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0);
        self.HeadView.hidden = YES;
        self.headMessageButton.hidden = YES;
            if (@available(iOS 11.0, *)) {
                _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
            } else {
                // Fallback on earlier versions
            }
         
        
    }

}


/* url 编码 中文 空格 特殊字符 */
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString* sURl = [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`%^{}\"-[]|\\（）<> "].invertedSet];
//    NSString* sURl = [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return sURl;
    
}

-(void)addCloseButton{

    if (!_colseBtn) {
        _colseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _colseBtn.frame = CGRectMake(self.headLeftButton.right-20, 24, 50, 40);
        [_colseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _colseBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [self.HeadView addSubview:_colseBtn];
        [_colseBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    }
 
    _colseBtn.hidden = NO;
}
-(void)closeVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRightButtonWithTitle:(NSString*)title{
    /////nav 右边按钮
     _headMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headMessageButton addTarget:self action:@selector(RightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _headMessageButton.frame=CGRectMake(SCREEN_WIDTH-80, (iPhoneX?24+20:20), 70, 44);
    _headMessageButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [_headMessageButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [_headMessageButton setTitle:title forState:UIControlStateNormal];
    [self.HeadView addSubview:_headMessageButton];
    
}
-(void)RightBtnClicked:(UIButton*)sender{


    
}
-(void)enableButton{
    _headMessageButton.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (!_IS_homeVC) {
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    
//}
/// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    
//    decisionHandler(WKNavigationActionPolicyCancel);
//
//
//}
/// 1 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
    NSString * string =  navigationAction.request.URL.absoluteString;
    NSLog(@"===decidePolicyForNavigationAction==%@=",string);
    if ([string hasPrefix:@"tel"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        _isCall = YES ;
        return ;
    }
    
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"closewindow"].location != NSNotFound) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    if ([_webUrl hasPrefix:@"https://mobile.tmall.com"]) {
        [self pushTaobaoTianmall];
    }
}
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"====加载开始！===");
    //状态栏添加加载图标
    rootView.hidden=YES;
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"====网页内容时返回！123==%@=",webView.title);
    
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"====网页内容时返回！didFinishNavigation==%@=",webView.title);

    if (webView.isLoading) {
        return;
    }
    if ([webView.title isEqualToString:@"发现"]) {
        _colseBtn.hidden = YES ;
    }
    
    [UIHelper hiddenAlertWith:self.view];
    rootView.hidden=YES;
//    self.headLabel.text = webView.title;
    _loadCount++;
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"====加载失败！2==%@=。====%@",error,webView.URL);
//    NSDictionary * diction = error.userInfo;
    [UIHelper hiddenAlertWith:self.view];
    
    if (self.isCall) {
        return ;
    }

    
}

-(void)addNoDataImageView{
    //
    if (!rootView) {
        
        rootView=[[UIView alloc]initWithFrame:CGRectMake(0, self.HeadView.height, SCREEN_WIDTH, SCREEN_HEIGHT-self.HeadView.height)];
        [self.view addSubview:rootView];
        rootView.backgroundColor = [UIColor whiteColor];
        
        bg_imageView=[[UIImageView alloc]init];
        bg_imageView.frame = CGRectMake((SCREEN_WIDTH-250*RATIO)/2, 48, 250*RATIO, 250*RATIO);
        bg_imageView.image =[UIImage imageNamed:@"img_step3"];
        [rootView addSubview:bg_imageView];
        
        UILabel  *noDateLabel=[[UILabel alloc]init];
        noDateLabel.frame = CGRectMake(50, CGRectGetMaxY(bg_imageView.frame)+10, SCREEN_WIDTH-100, 20);
        noDateLabel.text = @"喔噢！您的网络好像有问题...";
        noDateLabel.font =[UIFont boldSystemFontOfSize:15];
        noDateLabel.textColor = [[UIColor grayColor]colorWithHexString:@"7d8699"];
        noDateLabel.textAlignment =NSTextAlignmentCenter;
        [rootView addSubview:noDateLabel];
        
        UIButton *btn =[ UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, bg_imageView.bottom+57, SCREEN_WIDTH-50, ((SCREEN_WIDTH-50)/270)*44);
        [btn setTitle:@"刷新试试" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [btn addTarget:self action:@selector(reloadAgianURL:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor HexString:NormalColor] forState:UIControlStateNormal];
        [btn draCirlywithColor:[UIColor HexString:NormalColor] andRadius:btn.height/2];
        [rootView addSubview:btn];
        
//        rootView.height = btn.bottom +20;
        
    }
    rootView.hidden=NO;
}
-(void)reloadAgianURL:(UIButton *)sender{
    
    //    [self.webView reload];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    
    rootView.hidden=YES;
}
/// message: 收到的脚本信息.
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{


}

//重写父类方法
- (void)backBtnClicked {
    
    if (_webView.canGoBack) {
        [self.webView goBack];
        //        self.leftShutDownButton.hidden = NO;
    }else {
        //        self.leftShutDownButton.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 跳转到淘宝或天猫
-(void)pushTaobaoTianmall{

//    NSURL *taobaoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@", @"540712212369"]];
//    NSURL *tmallUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"tmall://tmallclient/?{\"action\":\"item:id=%@\"}", @"540712212369"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    if ([[UIApplication sharedApplication] canOpenURL:taobaoUrl]) {
//        //能打开淘宝就打开淘宝
//        [[UIApplication sharedApplication] openURL:taobaoUrl];
//        
//    } else
//        if ([[UIApplication sharedApplication] canOpenURL:tmallUrl]) {
//        //能打开天猫就打开天猫
//        [[UIApplication sharedApplication] openURL:tmallUrl];
//    }
    
}
@end
