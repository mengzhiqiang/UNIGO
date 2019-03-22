//
//  AFEditeViewController.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFEditeNickNameViewController.h"

#import "NSString+Regular.h"
#import "AFCommonEngine.h"
//#import "AFerrorForTextfIeldView.h"

#import "AFAccountEngine.h"

@interface AFEditeNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *passWordRuleTextView;
//@property (nonatomic, strong)AFerrorForTextfIeldView * errorView;

@end

@implementation AFEditeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headLabel.text = @"我的昵称" ;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=PersonBackGroundColor;
    [_titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _titleTextField.delegate = self;
    
    _saveButton.enabled=NO;
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"btn_grey_save"]  forState:UIControlStateNormal];
    [self draCirly:_saveButton];

    _titleTextField.text = _nickName;
    _passWordRuleTextView.frame= CGRectMake(5, 130, SCREEN_WIDTH-10, 30);
    _passWordRuleTextView.text=@"昵称不能超过14个字符。";
    _saveButton.frame = CGRectMake((SCREEN_WIDTH-225)/2, _passWordRuleTextView.bottom+44, 225, 44);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.titleTextField.placeholder = @"请输入1-14个字符";
    self.passWordRuleTextView.hidden = YES;

    
    [self.headMessageButton setTitle:@"保存" forState:UIControlStateNormal];
    self.headMessageButton.frame=CGRectMake(SCREEN_WIDTH-52, self.headMessageButton.top, 50, 44);
    self.headMessageButton.hidden = NO;
    [self.headMessageButton setTitleColor:[UIColor HexString:ButtonSelectColor] forState:UIControlStateNormal];

    if (_titleTextField.text.length<1) {
        self.headMessageButton.enabled=NO;
        [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
   
    if (iPhoneX) {
        _rootView.top = 88+16 ;
    }

}

-(void)RightMessageOfTableView{
    
    if (_type==50) {
        if ([NSString CountOFNSString:_titleTextField.text]>12) {
            [self promtNavHidden:@"宝贝关系超长"];
            return ;
        }
        if (![_titleTextField.text isValidBabyAlias]) {
            [UIHelper showUpMessage:@"宝贝关系不能包含标点或空格！"];
            return ;
        }
        
        _backWithNickNameBlock(_titleTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self chanageMyNickName];

}
#pragma  mark  textField 内容改动监控
- (void) textFieldDidChange:(UITextField *) TextField{
    
    
    if (_titleTextField.text.length>=1 ) {
        self.headMessageButton.enabled=YES;
        [self.headMessageButton setTitleColor:[UIColor HexString:ButtonSelectColor] forState:UIControlStateNormal];

    }else{
        self.headMessageButton.enabled=NO;
        [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }

}

#pragma mark - IBActions
- (IBAction)saveForConnect:(UIButton *)sender {
  
        [self chanageMyNickName];
}
#pragma mark - Private Method

////隐藏键盘
- (void)hideKeyBoard
{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
#pragma mark 修改设备昵称
-(void)changeRobotNickName{
    
    
}
#pragma mark 修改我的帐号昵称
-(void)chanageMyNickName{
    
   
    
    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:_titleTextField.text,@"screen_name", nil];
    _saveButton.enabled=NO;
    NSString *path = [API_HOST stringByAppendingString:jett_user];
    if (_type==30) {
        if ([NSString CountOFNSString:_titleTextField.text]>20) {
            [self promtNavHidden:@"设备昵称超长！"];
//            [self subNameOFNSString:_titleTextField.text];
            return;
        }
        if (![_titleTextField.text isValidBabyAlias]) {
            [UIHelper showUpMessage:@"设备昵称不能包含标点或空格"];
            return;
        }
        dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_titleTextField.text,@"nickname", nil];
    }else{
        if ([NSString CountOFNSString:_titleTextField.text]>14) {
            [self promtNavHidden:@"我的昵称超长！"];
//            [self subNameOFNSString:_titleTextField.text];
            return;
        }
        if (![_titleTextField.text isValidBabyAlias]) {
            [UIHelper showUpMessage:@"我的昵称不能包含标点或空格！"];
            return;
        }
    }

    [UIHelper addLoadingViewTo:self.view withFrame:0];

    [HttpEngine requestPatchWithURL:path params:dic1 isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        _saveButton.enabled=YES;
        
    
        [AFAccountEngine saveAccountInformationWithUserInfo:responseObject];
        _backWithNickNameBlock(_titleTextField.text);
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        _saveButton.enabled=YES;
        NSDictionary * userInfo = error.userInfo;
        
        if (![UIHelper TitleMessage:userInfo]) {
            return;
        }
        NSString *message=[userInfo objectForKey:@"message"];
        int code=[[userInfo objectForKey:@"status_code"] intValue];
        
        if (code==404  && [message isEqualToString:@"user_not_found"]){
            [self promtNavHidden:@"该用户不存在"]; return;
        }
        if (code==403  && [message isEqualToString:@"robot_ownership_required"]){
            [self promtNavHidden:@"查询机器人设置失败"]; return;
        }if (code==404  && [message isEqualToString:@"robot_not_found"]){
            [self promtNavHidden:@"该设备不存在"]; return;
        }
        
        [self promtNavHidden:@"修改失败，请重试！"];
    }];
}

#pragma  mark 设置圆角
-(void)draCirly:(UIView*)view {
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    
}
#pragma mark - Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self addAlertMessage:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}


/*
 字符串长度判断
 */
-(void)subNameOFNSString:(NSString*)sou{
    
    NSLog(@"==%lu==",(unsigned long)[sou length]);
    int length = (int)[sou length];
    
    int nicknameleng=0;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [sou substringWithRange:range];
        const char *cString = [subString UTF8String];
        
        if (cString==nil) {
            nicknameleng=nicknameleng+1;
            if (i==0) {
                _titleTextField.text = @""; return;
            }
            _titleTextField.text=[_titleTextField.text substringToIndex:i];
            return  ;
        //     continue;
        }
        
        if (strlen(cString) == 3)
        {
            NSLog(@"汉字:%s", cString);
            nicknameleng=nicknameleng+2;
        }else {
            nicknameleng=nicknameleng+1;
        }
        if (nicknameleng>14&& self.type ==0) {
            _titleTextField.text=[_titleTextField.text substringToIndex:i]; return;
        }else if (nicknameleng>8&& self.type >=10){
            _titleTextField.text=[_titleTextField.text substringToIndex:i]; return;
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  红色提示信息
//-(void)addAlertMessage:(NSString*)message{
//    
//    if (message.length<1) {
//        [UIView animateWithDuration:1.0 animations:^{
//            _errorView.hidden=YES;
//            
//        }];
//        return;
//    }
//    
//    if (!_errorView) {
//        _errorView =[[ AFerrorForTextfIeldView alloc]init];
//    }
//    float width =[_errorView showErrorMessageWithTitle:message];
//    _errorView.frame= CGRectMake(self.titleTextField.width-width-10-10, 15, width+10, 62);
//    [UIView animateWithDuration:1.0 animations:^{
//        _errorView.hidden=NO;
//        [self.titleTextField addSubview:_errorView];
//        
//    }];
//}



@end
