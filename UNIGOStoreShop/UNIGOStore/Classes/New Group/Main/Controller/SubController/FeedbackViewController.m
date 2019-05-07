//
//  FeedbackViewController.m
//  TeeLab
//
//  Created by teelab2 on 14-4-10.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIHelper.h"
#import "ExtendClass.h"
#import "CommonVariable.h"


@interface FeedbackViewController ()<UIGestureRecognizerDelegate, UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackcuston;
@property (strong, nonatomic) IBOutlet UIButton *PlaneButton;

@property (strong, nonatomic) IBOutlet UILabel *laberText;
@property (strong, nonatomic) IBOutlet UITextField *userContactTextField;

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.headLabel setText:@"意见反馈"];
    
    [_feedbackView draCirlywithColor:[UIColor grayColor] andRadius:2.0f];
    [_PlaneButton draCirlywithColor:nil andRadius:20.0f];

    _feedbackcuston.delegate=self;
    
  UITapGestureRecognizer*  tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    tapGesture.delegate = self;
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:_PlaneButton];
    
    self.view.backgroundColor=[UIColor  HexString:@"fafafa"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [_PlaneButton setTitleColor:[UIColor HexString:@"26c6da"] forState:UIControlStateNormal];
    
    [_feedbackcuston becomeFirstResponder];

}

-(void)onTap{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
- (IBAction)feedbackbutton:(UIButton *)sender {
    
    NSString *str=_feedbackcuston.text;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (_feedbackcuston.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            _laberText.hidden=NO;//隐藏文字
        }else{
            _laberText.hidden=YES;
        }
    }else{//textview长度不为0
        if (_feedbackcuston.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                _laberText.hidden=NO;
            }else{//不是删除
                _laberText.hidden=YES;
            }
        }else{//长度不为1时候
            _laberText.hidden=YES;
        }
    }
    return YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
//    [self PlaneNetWorking:nil];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)PlaneNetWorking:(UIButton *)sender {
    
    
    
    if ([_feedbackcuston.text length]<1) {
        [UIHelper alertWithTitle:@"反馈信息不能为空！"]; return;
    }
    
    if ( [ExtendClass CountOFNSString:_feedbackcuston.text]==10000) {
        [UIHelper alertWithTitle:@"反馈信息不能有特殊字符！"];
        return;
    }
    if ( [ExtendClass CountOFNSString:_feedbackcuston.text]>500) {
        [UIHelper alertWithTitle:@"反馈信息不能多于500个字符！"];
        return;
    }
    
    
    if ([_userContactTextField.text length]>30) {
        [UIHelper alertWithTitle:@"联系方式不能多于30位"]; return;
    }
    
    if ( [ExtendClass CountOFNSString:_userContactTextField.text]==10000) {
        [UIHelper alertWithTitle:@"联系方式不能有特殊字符！"];
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableDictionary *dic0=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[CommonVariable shareCommonVariable] userInfoo].useId,@"cusId",_feedbackcuston.text,@"content", nil];
    
    if ([_userContactTextField.text length]>0) {
    
        [dic0 setValue:_userContactTextField.text forKey:@"contact"];
    }
    

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.navigationController popViewControllerAnimated:YES];

}


@end
