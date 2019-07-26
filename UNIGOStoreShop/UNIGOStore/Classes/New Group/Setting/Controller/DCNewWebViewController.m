//
//  DCNewWebViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 26/7/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCNewWebViewController.h"
#import "CheckNetwordStatus.h"
#import "AFAccountEngine.h"
#import "LogInmainViewController.h"
@interface DCNewWebViewController ()
{
    
    UIView    *  rootView;
    UIImageView *bg_imageView;
    UIWebView *callWebview ;
    UIButton* _headMessageButton;
}
@property (strong,nonatomic) UIButton *colseBtn;
@property (assign,nonatomic) BOOL  isCall;

@end

@implementation DCNewWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;   ////scrollview 下移20像素的问题
    
    self.headLabel.text = _headTitle;
    _loadCount = 1;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.HeadView.height)];
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    // 2.创建请求
    NSMutableURLRequest *request;
    _webUrl = @"http://bbs.unigox.cn/mobile/index.html";
    // 3.加载网页
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    }
    else {
        request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    }
    
    [request setValue:[self tokenPram] forHTTPHeaderField:@"authentication"];
    [_webView loadRequest:request];
    self.webView.navigationDelegate = self ;
    // 最后将webView添加到界面3000 *0.03 =90  (10000-3000)*10% =700 3000*20%=600
    [self.view addSubview:_webView];
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    
    self.headLeftButton.hidden = YES;
    self.HeadView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCookie) name:@"cleadcookieNoticon" object:nil];
}

-(NSString*)tokenPram{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    
//    if (!token) {
//        LogInmainViewController *dcLoginVc = [LogInmainViewController new];
//        [self presentViewController:dcLoginVc animated:YES completion:^{
//        }];
//        return  nil;
//    }
    
    UNClient* account = [AFAccountEngine  getAccount].client;
    NSString * string =[NSString stringWithFormat:@"%@:%@:%d",login_appID ,token,account.identifier];
    NSString * stringBase = [NSString base64EncodeString:string];
    return  [NSString stringWithFormat:@"%d %@",account.identifier , stringBase];
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
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = [UIColor HexString:@"f2f2f2"];
    
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
    
    NSMutableURLRequest *mutableRequest = [navigationAction.request mutableCopy];
    NSDictionary *requestHeaders = navigationAction.request.allHTTPHeaderFields;
    if (requestHeaders[@"authentication"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
      
        [mutableRequest setValue:[self tokenPram] forHTTPHeaderField:@"authentication"];
        [webView loadRequest:mutableRequest];
        decisionHandler(WKNavigationActionPolicyAllow);
    }
  
    
}
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"====加载开始！===");
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
    }else{
        [self  addNoDataImageView ];
    }
    
    
}

-(void)addNoDataImageView{
    //
    if (!rootView) {
        
        rootView=[[UIView alloc]initWithFrame:CGRectMake(0, self.HeadView.height, SCREEN_WIDTH, SCREEN_HEIGHT-self.HeadView.height)];
        [self.view addSubview:rootView];
        rootView.backgroundColor = [UIColor whiteColor];
        
        bg_imageView=[[UIImageView alloc]init];
        bg_imageView.frame = CGRectMake((SCREEN_WIDTH-150*RATIO)/2, 48, 150*RATIO, 150*RATIO);
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
        btn.frame = CGRectMake(50, bg_imageView.bottom+57, SCREEN_WIDTH-100, ((SCREEN_WIDTH-100)/270)*34);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)cleanCookie{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    
    if (_webUrl) {//清除所有cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:_webUrl]];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
}
@end
