//
//  AmendPWViewController.m
//  ALPHA
//
//  Created by teelab2 on 15/1/27.
//  Copyright (c) 2015年 ALPHA. All rights reserved.
//

#import "AmendPWViewController.h"


#import "Unification.h"
#import "AFCommonEngine.h"
#import "AFAccountEngine.h"

//#import "UIViewController+navigationBar.h"

@interface AmendPWViewController ()
@property (weak, nonatomic) IBOutlet UIView *passWordView;

@end

@implementation AmendPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        self.headLabel.text = @"验证密码";
    //添加手势
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.view.backgroundColor=PersonBackGroundColor;
  
    
    [_PassWTestField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.headMessageButton.hidden = NO;
    [self.headMessageButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.headMessageButton.enabled=NO;
    
    if(_settingPW ==10){
        self.headLabel.text = @"设置密码";
        [self.headMessageButton setTitle:@"保存" forState:UIControlStateNormal];
        _PassWTestField.placeholder = @"请输入新密码";
    }
    
    _PassWTestField.delegate = self ;
    
    if (iPhoneX) {
        _passWordView.top = 88+16;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (_PassWTestField.text.length>=6 ) {
        self.headMessageButton.enabled=YES;
        [self.headMessageButton setTitleColor:[UIColor HexString:NormalColor] forState:UIControlStateNormal];
    }else{
        [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
-(void)RightMessageOfTableView{
    [self commintPassWord:nil];
}

- (void)onTap
{
    [[[UIApplication sharedApplication] keyWindow ] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}


- (IBAction)commintPassWord:(UIButton *)sender
{
    [self onTap];
//    NSPredicate *passpre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORKZ_ZH];
//    if (![passpre evaluateWithObject:_PassWTestField.text]) {
//        [UIHelper showUpMessage:@"密码可由字母、数字或下划线组成!"];        return;
//    }
    
    if (_settingPW!=10) {
        if ( [_PassWTestField.text length]>32) {
            [UIHelper showUpMessage:@"请设置6-32位密码！"];
            return;
        }
        
        if ( [_PassWTestField.text length]<6) {
            [UIHelper showUpMessage:@"旧密码不能少于6个字符！"];
            return;
        }
       
        
        [self verificationPassWord]; return ;
    }else{
        if ( [_PassWTestField.text length]>32) {
            [UIHelper showUpMessage:@"请设置6-32位密码！"];        return;
        }
        
        if ( [_PassWTestField.text length]<6) {
            [UIHelper showUpMessage:@"新密码不能少于6个字符！"];
            return;
        }
        if ([_PassWTestField.text isEqualToString:_oldPassWord]) {
            [UIHelper showUpMessage:@"新密码和旧密码不能一致！"];
            return;
        }
      
        NSRange range=[_PassWTestField.text rangeOfString:@" "];
        if(range.location!=NSNotFound){
            [UIHelper showUpMessage:@"用户密码不能有空格！"];
            return;
        }
    }
    NSDictionary*dic_register=[[NSDictionary alloc]initWithObjectsAndKeys:_oldPassWord ,@"old_password",_PassWTestField.text ,@"new_password", nil];
     [UIHelper addLoadingViewTo:self.view withFrame:0];
    NSString *path = [API_HOST stringByAppendingString:@"/m/user/password"];
    [HttpEngine requestPatchWithURL:path params:dic_register isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        [UIHelper showUpMessage:@"修改成功！" withColor:BackGreenGColor_Nav];
        
        NSArray *vc_array=[self.navigationController viewControllers];
        UIViewController *vidwC=[vc_array objectAtIndex:[vc_array count]-2-1];
        [self.navigationController popToViewController:vidwC animated:YES];
    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        if (![UIHelper TitleMessage:error.userInfo]) {
            return;
        }
        if ([[error.userInfo objectForKey:@"message"] isEqualToString:@"invalid_credentials"]) {

            [UIHelper showUpMessage:@"旧密码输入不正确"];
            return;
        }
        [UIHelper showUpMessage:[[[Unification shareUnification] password_Status] objectForKey:[error.userInfo objectForKey:@"message"]]];
    }];
}

-(void)verificationPassWord{
    
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    AFAccount *account = [AFAccountEngine sharedInstance].currentAccount;
    [AFCommonEngine requestedAccountLoginWithUsername:account.mobile password:_PassWTestField.text success:^(NSDictionary *responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        AmendPWViewController * amendVC =[[AmendPWViewController alloc]init];
        amendVC.settingPW=10;
        amendVC.oldPassWord = _PassWTestField.text ;
        [self.navigationController pushViewController:amendVC animated:YES];

    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        NSDictionary *userInfo = error.userInfo;
        int code=[[userInfo objectForKey:@"status_code"] intValue];
        
        if (code == 422) {
#warning  422 错误提示
            NSString *str_error = [[[userInfo objectForKey:@"errors"] allKeys] objectAtIndex:0] ;
            [UIHelper showUpMessage:[[[userInfo objectForKey:@"errors"] objectForKey:str_error] objectAtIndex:0]];
            return ;
        }
        if (code == 100) {
            [UIHelper showUpMessage:[userInfo objectForKey:@"message"]];
            return ;
        }
        
        if ([[userInfo objectForKey:@"message"] isEqualToString:@"invalid_credentials"]) {
            [UIHelper showUpMessage:@"密码不对，请重试！"];
        }
    }];
}



#pragma  mark 密文密码
- (IBAction)hiddenPasswordButton:(UIButton *)sender {
    
        if (_PassWTestField.secureTextEntry) {
            _PassWTestField.secureTextEntry=NO;
            [sender setImage:[UIImage imageNamed:@"Password_btn_show.png"] forState:UIControlStateNormal];
        }else{
            _PassWTestField.secureTextEntry=YES;
            [sender setImage:[UIImage imageNamed:@"Password_btn_hidden.png"] forState:UIControlStateNormal];
        }
   
}

@end
