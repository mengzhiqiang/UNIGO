
/*
    
   登录成功后；
 
 如果没有绑定机器人，则选择大小乐迪，根本进入不同主页（未绑定）；
 如果只添加一个机器人，则跳转到相应的主页（绑定）；
 如果添加两个宝贝，则默认跳转小乐迪主页，设置小乐迪为当前选中状态
 
 
 */

#import "LogInmainViewController.h"

#import "Unification.h"

#import <ImageIO/ImageIO.h>
#import "HttpRequestToken.h"
#import "AFAccountEngine.h"

#import "AFRegisterAccountViewController.h"
@interface LogInmainViewController ()<UIGestureRecognizerDelegate>
{

}
@end

@implementation LogInmainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    _loginForUseId.layer.masksToBounds = YES;
    _loginForUseId.layer.cornerRadius = 5;
    _loginForUseId.layer.borderWidth = 0.5;
    _loginForUseId.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _UserName.text =  [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    self.backgroundImageView.backgroundColor=[[UIColor grayColor] colorWithHexString:@"ffffff"];
    self.view.backgroundColor=[[UIColor grayColor] colorWithHexString:@"ffffff"];

    _loginForUseId.frame= CGRectMake(25, 20, SCREEN_WIDTH-50, 40*RATIO);
    if (_regist==10) {
        self.headLeftButton.hidden=YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headLabel.text=@"登录";
    self.headLabel.top = 81;
    self.headLabel.height = 26 ;
    self.headLabel.font = [UIFont systemFontOfSize:25];
    
    [_UserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_PassWord addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    _ad_scrollView=[[UIScrollView alloc]init];
    _ad_scrollView.frame=CGRectMake(0, 64, 320, 340);
    
    _UserName.delegate=self;
    _PassWord.delegate=self;
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    
    if ([userName length]>0) {
        _UserName.text=userName;
    }
    _loginForUseId.enabled=NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [_loginForUseId setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"] forState:UIControlStateNormal];
    [_loginForUseId setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];

    if (iPhoneX) {
        self.headLabel.top = self.HeadView.height+50 ;
        _rootView.top = self.headLabel.bottom+50;
        _middleView.top = _rootView.bottom+30 ;

    }
    
    self.headLeftButton.hidden = YES ;
    
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
      if (_UserName.text.length==11 && _PassWord.text.length>=6) {
        _loginForUseId.enabled=YES;
          [_loginForUseId setBackgroundImage:[UIImage imageNamed:@"btn_activation_normal"] forState:UIControlStateNormal];
          [_loginForUseId setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        _loginForUseId.enabled=NO;
        [_loginForUseId setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"] forState:UIControlStateNormal];
        [_loginForUseId setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];

    }
}

- (IBAction)hiddenOrNoButton:(UIButton *)sender {
    
    if (_PassWord.secureTextEntry) {
        _PassWord.secureTextEntry=NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"Password_btn_show.png"] forState:UIControlStateNormal];
    }else {
        _PassWord.secureTextEntry=YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"Password_btn_hidden.png"] forState:UIControlStateNormal];

    }
}

- (void)onTap
{
    [self hideKeyBoard];
}
-(void)backBtnClicked{

    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

///设置位圆角
-(UIView*)markround:(UIView*)view  {
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    
    return view;
}

- (IBAction)EnterLogin:(UIButton *)sender
{
    NSPredicate *predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_zh];
    NSPredicate *passpre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORKZ_ZH];
    
    if( _UserName.text.length == 0 ) {
        [self promtNavHidden:@"请输入手机号！"];
        return;
    }
    else if ( ![predicate0 evaluateWithObject:_UserName.text]) {
        [self promtNavHidden:@"手机号输入格式不正确!"];
        return;
    }
    
    if ([_PassWord.text length]==0) {
        [self promtNavHidden:@"请输入密码！"];
        return;
    }
    if ([_PassWord.text length]>32 || [_PassWord.text length]<6) {
        [self promtNavHidden:@"请设置6-32位密码！"];
        return;
    }
    NSRange range=[_PassWord.text rangeOfString:@" "];
    if(range.location!=NSNotFound){
        [UIHelper showUpMessage:@"用户密码不能有空格！"];
        return;
    }
//    else if (![passpre evaluateWithObject:_PassWord.text]) {
//        [self promtNavHidden:@"密码可由字母、数字或下划线组成"];        return;
//    }
    
    [self hideKeyBoard];
    _loginForUseId.enabled=NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = _UserName.text;
    param[@"password"] = _PassWord.text;
    param[@"appid"]  = login_appID ;
    param[@"appsecret"]  = login_appsecret ;
    param[@"nonce"]  = @"123" ;
    param[@"timestamp"]  = [NSDate getCurrentTime] ;
    param[@"sign"]  = [NSString signStr:param] ;

    NSLog(@"param===%@",param);
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    NSString *path = [API_HOST stringByAppendingString:user_login];
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        _loginForUseId.enabled = YES;
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"];
        [[NSUserDefaults standardUserDefaults] setValue:_UserName.text forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:_PassWord.text  forKey:KEY_PASS_WORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSmartDeviceLoginNotification object:nil];
       [HttpRequestToken saveToken:JSONDic[@"access_token"]];
        
        [UIHelper  hiddenAlertWith:self.view];
        [AFAccountEngine saveAccountAndTokenWithUserInfo:JSONDic  ];
        
//            //登录云信318686
//            [[AFNIMEngine sharedInstance] loginNIMSDKWithNIMInfo:responseObject[@"nim"]];
        
        if ([responseObject objectForKey:@"msg"]) {
            [self promtNavHidden:[responseObject objectForKey:@"msg"]];

        }else{
        }
        [self  dismissViewControllerAnimated:YES completion:nil];

        NSLog(@"==fail=userInfo==%@",[responseObject objectForKey:@"msg"]);
   
    } failure:^(NSError *error) {
        _loginForUseId.enabled = YES;
        [UIHelper  hiddenAlertWith:self.view];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==fail=userInfo==%@",[userInfo objectForKey:@"msg"]);

        
        int code=[[userInfo objectForKey:@"status_code"] intValue];

        if (code==404  &&[[userInfo objectForKey:@"message"] isEqualToString:@"user_not_found"] ){
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
            NSLog(@"=登录跳转=Dic_data=%@==",userInfo) ;
            [self promtNavHidden:[[[Unification shareUnification] token_Status] objectForKey:[userInfo objectForKey:@"message"]]];
            return  ;
        }
        
        if (![UIHelper TitleMessage:userInfo]) {
            return;
        }
        [self promtNavHidden:[userInfo objectForKey:@"msg"]];
    }];
}

////隐藏键盘
- (void)hideKeyBoard
{
    
    [_UserName resignFirstResponder];
    [_PassWord resignFirstResponder];

//    [UIView animateWithDuration:0.5 animations:^ {
//        _rootView.frame=CGRectMake(0, 64, SCREEN_WIDTH, 451);
//        
//    }];
}

#pragma mark 找回密码
- (IBAction)findPassWord:(UIButton *)sender {
     AFRegisterAccountViewController*per=[[AFRegisterAccountViewController alloc]init];
    if (sender.tag==10) {
        per.title = @"注册";
        per.viewType = AFViewControllerTypeRegister;

    }else{
        per.title = @"忘记密码";
        per.viewType = AFViewControllerTypeForget;

    }
    
    [self presentViewController:per animated:YES completion:nil];
//     [self.navigationController pushViewController:per animated:YES];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{       // became first responder
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self hideKeyBoard];
        
    return YES;
}
//
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
    if (textField == _UserName) {
        if (_UserName.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
  
    
    if (textField == _UserName) {
        if( _UserName.text.length == 0 ) {
            [self promtNavHidden:@"请输入手机号！"];
            _loginForUseId.enabled=NO;
            [_loginForUseId setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"] forState:UIControlStateNormal];
            [_loginForUseId setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];        }
         else if (![_UserName.text isValidMobileNumber]) {
            [UIHelper showUpMessage:@"手机号格式不正确！"];
            _loginForUseId.enabled=NO;
            [_loginForUseId setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"] forState:UIControlStateNormal];
            [_loginForUseId setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];
            
        }
    }
    
}

static  int  textieldTag=0;

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    textieldTag=1;
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

