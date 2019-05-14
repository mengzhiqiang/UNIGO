//
//  BabyNickNameViewController.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/5/11.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UNNickNameViewController.h"

#import "AFUpdateBabyInformation.h"
@interface UNNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *rootView;

@end

@implementation UNNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headLabel.text = @"昵称";
  
    [_nickNameTF addTarget:self action:@selector(nickNametextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _nickNameTF.text = [self.baby_Dic objectForKey:@"name"];

    self.headMessageButton.hidden = NO;
    [self.headMessageButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.headMessageButton.enabled=NO;
    
    self.view.backgroundColor=PersonBackGroundColor;
    _nickNameTF.delegate = self;
    if (IS_X_) {
        _rootView.top = 88+16 ;
    }
}

- (void) nickNametextFieldDidChange:(UITextField *) TextField{

    if (TextField.text.length<1) {
        self.headMessageButton.enabled=NO;
        [self.headMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        self.headMessageButton.enabled=YES;
        [self.headMessageButton setTitleColor:[UIColor HexString:NormalColor] forState:UIControlStateNormal];
    }

}

-(void)hideKeyBoard{
    
    [[[UIApplication sharedApplication ]keyWindow ]endEditing:NO];
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)RightMessageOfTableView{
    [self NextButton:nil];
}
- (IBAction)NextButton:(UIButton *)sender {
    
    if (![_nickNameTF.text isValidBabyAlias]) {
        [UIHelper showUpMessage:@"昵称不能包含标点或空格！"];
        return;
    }
    
    NSString *strUrl = [_nickNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([strUrl length]<1) {
        [self promtNavHidden:@"昵称不能为空！"];
        return;
    }
    
    if ([NSString CountOFNSString:strUrl]>12) {
        [self promtNavHidden:@"昵称不能多于12位字符！"];
        return;
    }
    [self saveBabyName];
    
}

-(void)saveBabyName{
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    
    [AFUpdateBabyInformation requestPatchWithparams:self.baby_Dic key:@"nickname" value:_nickNameTF.text success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        _backBabyinforBlock(responseObject);
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        
        NSDictionary *userInfo = error.userInfo;
        if (![UIHelper TitleMessage:userInfo]) {
        }
        
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self NextButton:nil];
    return YES;
}



@end
