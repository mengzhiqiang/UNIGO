//
//  TimeOfcCodeButton.m
//  ALPHA
//
//  Created by mzq on 15/11/16.
//  Copyright © 2015年 ALPHA. All rights reserved.
//

#import "TimeOfcCodeButton.h"
#import "UIHelper.h"
#import "ExtendClass.h"
#import "Unification.h"
@implementation TimeOfcCodeButton
{

    int   count_Code;

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (!_count_label) {
        [self  LoadCountLable];
        
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     

    }
    return self;
}

-(void)LoadCountLable{

    
    if (!_count_label) {
    _count_label=[[UILabel  alloc]initWithFrame:self.bounds];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        
    }
    
    _codeStyle=@"1";
    _count_label.font=[UIFont systemFontOfSize:16];

    _count_label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_count_label];
    _count_label.textColor=[UIColor whiteColor];
    _count_label.text=@"获取验证码";
    [self addSubview:_count_label];

//    [self addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)loadNewCodeWithEmail{


}


-(void)loadNewCodeWithIphone:(NSString*)ipone{
    
    self.ipone=ipone;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_zh];
    
    if( self.ipone.length == 0 ){
        [_delegate loadNewTitleOfNav:@"请输入用户手机号码！"];        return;
    }
    
    else if (![predicate evaluateWithObject:self.ipone]) {
        [_delegate loadNewTitleOfNav:@"手机号格式不正确！"];        return;
    }
    
    NSUUID *deviceUUID = [UIDevice currentDevice].identifierForVendor;
    NSString *deviceId = [deviceUUID UUIDString];

    NSString *device = [deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""]; //替换字符
    
    NSMutableDictionary*dic_register=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_ipone,@"phone",device,@"uuid", nil];
    
    NSString *pram = register_code;
    
//    if ([_codeStyle isEqualToString:@"2"]) {
//        pram = @"/m/password/code";
//    }
    [UIHelper addLoadingViewTo:self withFrame:0];
    self.enabled=NO;
    NSString *path = [API_HOST stringByAppendingString:pram];
    [HttpEngine requestGetWithURL:path params:dic_register isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [_delegate loadNewTitleOfNav:@"验证码已发送，请注意查收"];
        count_Code=60;
        NSLog(@"====%@",responseObject);
        NSTimer* timer0 =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changecountOfCode:) userInfo:nil repeats:YES];
        [timer0 fire];
        self.enabled=NO;
    } failure:^(NSError *error) {
        self.enabled=YES;
        NSDictionary *Dic_data =error.userInfo;
        
        [self TitleMessage:Dic_data];
        
       
    }];
    
    self.enabled=NO;
    
}

-(void)changecountOfCode:(NSTimer*)time{
    
    count_Code--;
    
    if (count_Code<0) {
        self.enabled=YES;
        [time invalidate];
        _count_label.text= [NSString stringWithFormat:@"获取验证码"];
        _count_label.textColor = [UIColor HexString:NormalColor];
        return;
    }
    self.enabled=NO;
    _count_label.textColor = [UIColor HexString:@"8c8b90"];
    _count_label.text= [NSString stringWithFormat:@"%d秒后重发",count_Code];
}

-(BOOL)TitleMessage:(NSDictionary *)Dic_data{
    
    int code=[[Dic_data objectForKey:@"status_code"] intValue];
    
    if (code == 422) {
        NSString *str_error = [[[Dic_data objectForKey:@"errors"] allKeys] objectAtIndex:0] ;
        NSLog(@"code==%@",[[[Dic_data objectForKey:@"errors"] objectForKey:str_error] objectAtIndex:0]);
        [_delegate loadNewTitleOfNav:[[[Dic_data objectForKey:@"errors"] objectForKey:str_error] objectAtIndex:0]];
        return NO;
    }
    
    if (code == 100) {
        
        NSLog(@"message==%@",[Dic_data objectForKey:@"message"]);
        [AFAlertViewHelper alertViewWithTitle:nil message:@"当前网络不可用，请检查手机的网络设置" delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
            //
        }];
        return NO;
    }
    
    NSString * message = [ Dic_data objectForKey:@"message"];
    if ([[Dic_data objectForKey:@"message"] isEqualToString:@"mobile_in_sms_blacklist"]) {
        [_delegate loadNewTitleOfNav:@"获取验证码失败，请联系你的网络运营商"];
    }else  if ([[Dic_data objectForKey:@"message"] isEqualToString:@"sms_request_too_frequently"]) {
        [UIHelper showUpMessage:@"短信请求太频繁"];
    }else  if ([[Dic_data objectForKey:@"message"] isEqualToString:@"sms_request_times_limited"]) {
        [_delegate loadNewTitleOfNav:@"获取验证码超过次数限制，请更换手机号或明天再试。"];
    }else  if ([[Dic_data objectForKey:@"message"] isEqualToString:@"incorrect_mobile_format"]) {
        [UIHelper showUpMessage:@"手机号格式有误"];
    }else if([[Dic_data objectForKey:@"message"] isEqualToString:@"account_exists"]){
        [UIHelper showUpMessage:@"手机号已注册"];
    }else if([[Dic_data objectForKey:@"message"] isEqualToString:@"user_not_found"]){
        [UIHelper showUpMessage:@"手机号码未注册"];
    }else{
        [UIHelper showUpMessage:@"验证码获取失败"];

    }
    return YES;
    
}

@end
