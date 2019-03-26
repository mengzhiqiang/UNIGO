//
//  AFRegisterAccountViewController.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//
/*
 data =     {
 "access_token" = 1b9fihr2PSUVm8QZ753Opj3e526nWa80;
 client =         {
 mobile = 13800000005;
 uid = 10017;
 };
 "expires_time" = 1552452602;
 "refresh_expires_time" = 1555037402;
 "refresh_token" = Pek5EC1NVMnXaKqwi36GWJ9rd7jyHt8U;
 };
 msg = success;
 status = 1;
 }
 */


#import "AFRegisterAccountViewController.h"
#import "TimeOfcCodeButton.h"
#import "AFAlertViewHelper.h"
#import "NSString+Regular.h"
#import "HttpEngine.h"

#import "AFCommonEngine.h"
#import "AFAccountEngine.h"
//#import "AFNIMEngine.h"
#import "AppDelegate+Notification.h"
//#import "WKwebViewController.h"
#import "Unification.h"
#import "HttpRequestToken.h"
@interface AFRegisterAccountViewController ()<
  PassCodeOfiPoneDelegate,
  UITextFieldDelegate
>
{

    BOOL  ispramConform;

  
}
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeButton;

@property (nonatomic, strong) UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *useView;
@property (strong, nonatomic) IBOutlet UITextField *passWordTextFied;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIView *serverView;
@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (assign, nonatomic)  BOOL  isCodeing; //已经发送code
@property (assign, nonatomic)  BOOL  isCodeRight; //code是否正确

@end

@implementation AFRegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self  commonInit];
    self.view.backgroundColor=[UIColor HexString:@"ffffff"];
    [self registerButtonEnable:NO];
    

    _serverView.frame = CGRectMake((SCREEN_WIDTH-210)/2, SCREEN_HEIGHT-30-30, 210, 30);
    [self.view addSubview:_serverView];
    NSLog(@"====%@",_passWordTextFied);
    [_passWordView addSubview:_passWordTextFied];
//    [self setValue:[UIColor HexString:@"B2B2B2"] forKeyPath:@"_passWordTextFied.placeholderLabel.textColor"];
//    [self setValue:[UIColor HexString:@"B2B2B2"] forKeyPath:@"_codeTextField.placeholderLabel.textColor"];
//    [self setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_codeTextField.placeholderLabel.font"];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _registerButton.backgroundColor=[UIColor clearColor];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"]  forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];
    _registerButton.height = 40*RATIO;
    if (_viewType == AFViewControllerTypeForget) {
        _serverView.hidden=YES;
        [_registerButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    
    _passWordTextFied.delegate = self;
    _codeTextField.delegate    = self;
    _phoneTextField.delegate   = self;
    
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passWordTextFied addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeButton draCirlywithColor:nil andRadius:4.0];

    [self setupCodeTextFieldSubviews];
    
    if (iPhoneX) {
        _rootView.top = self.HeadView.height +50 ;
        self.headLabel.top = self.HeadView.height +50 ;
        _serverView.top = SCREEN_HEIGHT - 30-30-50 ;
    }
    
}

- (void)setupCodeTextFieldSubviews
{
    _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 46, 38);
    _codeTextField.rightView = btn;
    [btn setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearTextAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clearTextAction:(UIButton*)sender{
    _codeTextField.text = @"";
    
}
////隐藏键盘
- (void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (isPAD_or_IPONE4) {
        [UIView animateWithDuration:1.0 animations:^{
            _rootView.top = 64 ;
            self.headLabel.top = 81;
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)codeForNetWork:(id)sender {
    
}
#pragma mark - CommonInit Basic

- (void)commonInit
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.headLabel.text = @"注册帐号";
    if (_viewType == AFViewControllerTypeForget) {
        self.headLabel.text = @"找回密码";
    }
    self.headLabel.frame = CGRectMake(0, 81, SCREEN_WIDTH, 30);
    self.headLabel.font = [UIFont systemFontOfSize:25.0f];
    self.headLabel.textColor =[UIColor HexString:@"464646"];
    _codeButton.delegate=self;
//    [self.rootView addSubview:self.headLabel];
    [_codeButton LoadCountLable];
    [_codeButton addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];
    _codeButton.userInteractionEnabled=NO;
    _codeButton.count_label.textColor = [UIColor HexString:@"8c8b90"];

}

#pragma mark - IBActions
- (void)backAction:(UIButton *)button
{
    [self hideKeyBoard];
    

    NSString *title = @"";
    NSString *message = @"";
    if (self.viewType == AFViewControllerTypeRegister) {
        title = @"确认取消注册帐号吗？";
        message = @"";
    } else {
        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController zh_popViewControllerAnimated:YES];

        return;
    }
    __weak typeof(self) weakSelf = self;
    [AFAlertViewHelper alertViewWithTitle:title message:message delegate:self cancelTitle:@"取消" otherTitle:@"前往登录" clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [strongSelf.navigationController zh_popViewControllerAnimated:YES];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

- (IBAction)forRegisterButton:(UIButton*)sender {
    
    NSPredicate *passpre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORKZ_ZH];

    if( _phoneTextField.text.length == 0 ){
        [UIHelper showUpMessage:@"请输入用户手机号码！"];        return;
    }
    
    else if( ![_phoneTextField.text isValidMobileNumber] ){
        [UIHelper showUpMessage:@"手机号格式不正确！"];        return;
    }
    NSRange range=[_passWordTextFied.text rangeOfString:@" "];
    if(range.location!=NSNotFound){
        [UIHelper showUpMessage:@"密码不能有空格！"];        return;
    }else if( _passWordTextFied.text.length>32 ){
        [UIHelper showUpMessage:@"请设置6-32位密码！"];        return;
    }
//    else if (![passpre evaluateWithObject:_passWordTextFied.text]) {
//        [self promtNavHidden:@"密码可由字母、数字或下划线组成！"];        return;
//    }
    
    if (_viewType == AFViewControllerTypeForget) {
        [self fingPassWordWithIpone]; return;
    }
    
//    [AFUManalyticsEngine UMAnalyticsCountEven:@"sign_up"];

    NSMutableDictionary*dic_register=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_phoneTextField.text,@"phone",_codeTextField.text,@"code",_passWordTextFied.text,@"password", nil];
    
    NSString *pram = user_reg;
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    sender.enabled=NO;
    [self hideKeyBoard];

    NSString *path = [API_HOST stringByAppendingString:pram];
    [HttpEngine requestPostWithURL:path params:dic_register isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper  hiddenAlertWith:self.view];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"];
        [[NSUserDefaults standardUserDefaults] setValue:_phoneTextField.text forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:_passWordTextFied.text  forKey:KEY_PASS_WORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSmartDeviceLoginNotification object:nil];
        
        [HttpRequestToken saveToken:JSONDic[@"access_token"]];
        
        [UIHelper  hiddenAlertWith:self.view];
        [AFAccountEngine saveAccountAndTokenWithUserInfo:JSONDic ];

        NSLog(@"=responseObject===%@",responseObject);

    } failure:^(NSError *error) {
        [UIHelper  hiddenAlertWith:self.view];
        sender.enabled=YES;
        NSDictionary *userInfo =error.userInfo;
        NSLog(@"=error===%@",error);

        if (![UIHelper TitleMessage:userInfo]) {
            return;
        }
        NSInteger statusCode = [[userInfo objectForKey:@"status_code"] intValue];
        NSString * message = [userInfo objectForKey:@"message"];
     
        if(statusCode == 403 || [message isEqualToString:@"sms_code_expired"]){
            [UIHelper showUpMessage:@"验证码已失效,请重试"];
        } else if(statusCode == 403 || [message isEqualToString:@"invalid_credentials"]){
            [UIHelper showUpMessage:@"验证码错误"];
        }
    
    }];

}
-(void)fingPassWordWithIpone{
    
    
    NSMutableDictionary*dic_register=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_phoneTextField.text,@"mobile",_codeTextField.text,@"code",_passWordTextFied.text,@"password", nil];
    
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    _registerButton.enabled=NO;
    [self hideKeyBoard];
    
    NSString *path = [API_HOST stringByAppendingString:user_findPassword];
    
    [HttpEngine requestPutWithURL:path params:dic_register isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper  hiddenAlertWith:self.view];

        [[NSUserDefaults standardUserDefaults] setValue:_phoneTextField.text forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:KEY_PASS_WORD];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self backBtnClicked];
        
        
    } failure:^(NSError *error) {
        [UIHelper  hiddenAlertWith:self.view];
        NSLog(@"====%@",error);
        _registerButton.enabled=YES;
        NSDictionary *userInfo =error.userInfo;
        
        if (![UIHelper TitleMessage:userInfo]) {
            return;
        }
        NSInteger statusCode = [[userInfo objectForKey:@"status_code"] intValue];
        NSString * message = [userInfo objectForKey:@"message"];
        if( [message isEqualToString:@"sms_code_expired"]){
            [UIHelper showUpMessage:@"验证码已失效,请重试"];
        } else if( [message isEqualToString:@"invalid_credentials"]){
            [UIHelper showUpMessage:@"验证码有误,请重试"];
        } else if([message isEqualToString:@"require_different_password"]){
            [UIHelper showUpMessage:@"新旧密码相同,请重试"];
        }else if (statusCode ==404){
            [UIHelper showUpMessage:@"账号不存在"];

        }else{
            [UIHelper showUpMessage:@"服务器异常"];

        }
        
        
    }];
}

- (IBAction)serverBuuton:(UIButton *)sender {
    
//    WKwebViewController *cwb = [[WKwebViewController alloc]init];
//    cwb.headTitle = @"";
//    cwb.webUrl = WEBURL_Agreement;
//    [self.navigationController pushViewController:cwb animated:YES];
}

/*
 注册成功 直接登录
 */


/* 跳转到添加宝贝页面 */
-(void)enterBabydetailVC{
    
    if (_viewType==AFViewControllerTypeForget) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return ;
    }else{
//        SMJSelectJettViewController*conVC=[[SMJSelectJettViewController alloc]init];
//        UIViewController * rootViewController = [self.navigationController.viewControllers firstObject];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        conVC.regist = 10;
//        [rootViewController.navigationController pushViewController:conVC animated:NO];
//
//        [[NSUserDefaults standardUserDefaults] setObject:RobotModel_small_Jett forKey:kJettMobShowRobot] ;
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstRegister"] ;
    }
}

#pragma  mark  校验验证码
-(void)acceptCode{
    
    if (self.viewType == AFViewControllerTypeForget) {
        return;
    }
    
    NSString *pathUrl = [API_HOST stringByAppendingString:register_code];
    NSDictionary*dic=[[NSDictionary alloc]initWithObjectsAndKeys:_phoneTextField.text,@"mobile",_codeTextField.text,@"code", nil];
    NSLog(@"==%@",dic);
    [HttpEngine requestPostWithURL:pathUrl params:dic isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        _isCodeRight = YES;
    } failure:^(NSError *error) {
        
        NSDictionary *userInfo = error.userInfo; ///
        int code=[[userInfo objectForKey:@"status_code"] intValue];
        NSString * message = [ userInfo objectForKey:@"message"];
        if ([message isEqualToString:@"invalid_credentials"] && code == 401) {
            ///验证码错误
 
        }
    }];
}


#pragma mark - Public Method


#pragma mark - Private Method

-(void)loadNewCodeWithIphone{
//    [self enterBabydetailVC];
//    return;
    
    [self hideKeyBoard];
    _codeButton.codeStyle=[NSString stringWithFormat:@"10"];
    if (_viewType == AFViewControllerTypeForget) {
        _codeButton.codeStyle=[NSString stringWithFormat:@"2"];
    }
    
    [_codeButton loadNewCodeWithIphone:_phoneTextField.text];

}
#pragma mark - Delegate

#pragma mark -textField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (isPAD_or_IPONE4) {
        if (textField == _passWordTextFied) {
            [UIView animateWithDuration:0.5 animations:^{
                _rootView.top = 0;
                self.headLabel.top = 17;

            }];
        }
        if (textField == _codeTextField) {
            [UIView animateWithDuration:0.5 animations:^{
                _rootView.top = 30;
                self.headLabel.top = 47;

            }];
        }
    }
   

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    if (textField == _phoneTextField) {
        if (_phoneTextField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    
    if (textField == _codeTextField) {
        if (_codeTextField.text.length>=6 && string.length>0) {
            return NO;
        }
    }
    
    return YES;
}


-(void)textFieldDidChange:(UITextField *)textField{
    
    [self registerButtonEnable:NO];
    if (textField == _codeTextField) {
        _isCodeRight = YES;
    }
    
    if (_phoneTextField.text.length==11 ) {
        
        if (!_isCodeing) {
            _codeButton.userInteractionEnabled=YES;
            _codeButton.count_label.textColor = [UIColor HexString:NormalColor];
        }
        if (_codeTextField.text.length>=4 && _passWordTextFied.text.length>=6 &&_passWordTextFied.text.length<=32) {
            [self registerButtonEnable:YES];
            return;
        }
        
        if (_codeTextField.text.length==6) {
//            [self acceptCode];  ///判断验证是否正确
        }
        
    }else{
        _codeButton.userInteractionEnabled=NO;
        _codeButton.count_label.textColor = [UIColor HexString:@"8c8b90"];

    }

    [self registerButtonEnable:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _codeTextField) {
        if (_phoneTextField.text.length==11) {
//            [self acceptCode];  ///判断验证是否正确
        }
    }
    
    if (textField == _phoneTextField) {
        if (![_phoneTextField.text isValidMobileNumber]) {
            [UIHelper showUpMessage:@"手机号格式不正确！"];
            _registerButton.enabled=NO;
            [_registerButton setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"]  forState:UIControlStateNormal];

        }
    }
    
}
- (IBAction)hiddenOrNoButton:(UIButton *)sender {
    
    if (_passWordTextFied.secureTextEntry) {
        _passWordTextFied.secureTextEntry=NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"Password_btn_show.png"] forState:UIControlStateNormal];
    }else {
        _passWordTextFied.secureTextEntry=YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"Password_btn_hidden.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}

#pragma  mark codeButton delagate
-(void)loadNewTitleOfNav:(NSString *)title{
    
    if ([title isEqualToString:@"验证码已发送，请注意查收"]) {
        [UIHelper showUpMessage:title withColor:BackGreenGColor_Nav];
        return;
    }
    
    if ([title hasPrefix:@"获取验证码"]) {

        [AFAlertViewHelper alertViewWithTitle:nil message:title delegate:self cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
         
        }];
        return;
    }
    
    if (title) {
        [UIHelper showUpMessage:title];
    }
    
}
#pragma  mark 验证码倒计时回调
/* 验证码60秒开始或结束 */
-(void)timeOverWithCode:(BOOL)begin{
    if (begin) {
        _isCodeing = YES;
        _codeButton.count_label.textColor = [UIColor HexString:@"8c8b90"];
        return;
    }
    _isCodeing = NO;
    _codeButton.count_label.textColor = [UIColor HexString:NormalColor];

}

-(void)backBtnClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Setter and Getter

-(void)registerButtonEnable:(BOOL)enable{
    
    ispramConform=enable;
    
    if (ispramConform) {
        _registerButton.enabled=YES;
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"btn_activation_normal"]  forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        return;
    }
    
    _registerButton.enabled=NO;
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"btn_activation_disbled"]  forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor HexString:@"8c8B90"] forState:UIControlStateNormal];

}

@end
