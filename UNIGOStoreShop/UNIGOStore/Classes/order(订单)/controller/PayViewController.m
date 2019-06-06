//
//  PayViewController.m
//  TeeLab
//
//  Created by teelab2 on 14-4-30.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "PayTableViewCell.h"
#import "DCorderDetailStatueViewController.h"
#import <AlipaySDK/AlipaySDK.h>   ///支付宝

//微信
#import "WXApiObject.h"
#import "WXApi.h"


#import "UIHelper.h"
#import "ExtendClass.h"
#import "PayViewController.h"
#import "WXApiManager.h"
#import "AppDelegate.h"

@interface PayViewController ()<UIAlertViewDelegate,WXApiDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString * string;
    
}
@end

@implementation PayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"支付";
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (_platform==10) {
        return;
    }

    _Select=80;
    _platform=3;
    _SumLabel.text = self.SumOfPrice;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResult:) name:@"alipayResult" object:nil];
}


//
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headLabel.text=@"支付";
    self.headMessageButton.hidden=YES;
    [self SetNewframe];
    
    if ([_NewOrder isEqualToString:@"New"]) {
        [self.headLeftButton setTitle:@"取消" forState:UIControlStateNormal];
        self.headLeftButton.titleLabel.font=[UIFont systemFontOfSize:16];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil; ///滑动返回调控
    }

}

-(void)backBtnClicked{

    if ([_NewOrder isEqualToString:@"New"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }

}

-(void)SetNewframe{

    self.automaticallyAdjustsScrollViewInsets = NO;   ////scrollview 下移20像素的问题

    float  height=(isPAD_or_IPONE4 ?-10:0);

    self.view.backgroundColor=[UIColor HexString:@"fafafa"];
    _rootTableView.frame=CGRectMake(0, self.HeadView.height+20, SCREEN_WIDTH, SCREEN_HEIGHT-self.HeadView.height-20-95);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.scrollEnabled=NO;
//    _rootTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    _payButtonView.frame=CGRectMake(0, SCREEN_HEIGHT-111-height, SCREEN_HEIGHT, 111+height);
    _SumLabel.frame=CGRectMake(SCREEN_WIDTH-120-10, 15, 120, 20);
    _payButton.frame=CGRectMake(0, 51, SCREEN_WIDTH, 60+height);
    _SumLabel .textColor=[UIColor HexString:@"737373"];
    _payButton.backgroundColor=[UIColor HexString:greenONE];
    [self.view addSubview:_payButtonView];
    
}

//////设置可变字符串 label
-(void)makeAttributedString:(UILabel *) label WithString:(NSString *)string {
    
    if (!string) {
        return;
    }
    
    NSMutableAttributedString  *str= [[NSMutableAttributedString alloc] initWithString:label.text];
    NSDictionary  *dic=@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName: [UIColor HexString:@"f44336"]};
    
    NSRange range=[label.text rangeOfString:string];
    [str setAttributes:dic range:range];

    label.attributedText=str;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    return   (isPAD_or_IPONE4?70: 90*RATIO);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"INDENTCells";
    
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *image_arr=@[@"payWeixin.png",@"payZhifu.png"];
    
    NSArray *title_arr=@[@"微信快捷支付",@"支付宝快捷支付"];

    NSArray *content_arr=@[@"拥有微信客户端即可使用",@"拥有支付宝客户端即可使用"];
    
    cell.payImageView.image=[UIImage imageNamed:[image_arr objectAtIndex:indexPath.row]];
    cell.payName.text=  [NSString stringWithFormat:@"%@", [title_arr objectAtIndex:indexPath.row]];
    cell.payContent.text=  [NSString stringWithFormat:@"(%@)", [content_arr objectAtIndex:indexPath.row]];
    
    
    [cell makeAttributedString:cell.payName WithString:[NSString stringWithFormat:@"(%@)",[content_arr objectAtIndex:indexPath.row]]];
    
    cell.paySelectOrNo.text=@"";
    cell.paySelectOrNo.textColor=[UIColor HexString:@"b5b5b5"];

    if (_Select-80 ==indexPath.row) {
        cell.paySelectOrNo.text=@"";
        cell.paySelectOrNo.textColor=[UIColor HexString:@"5890ff"];
    }
        
    cell.backgroundColor=[UIColor HexString:@"fafafa"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _Select=(int)indexPath.row+80;
    
    [_rootTableView reloadData];
}



- (IBAction)Paying:(UIButton *)sender {
    
    NSString *path = [API_HOST stringByAppendingString:order_pay];
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.orderID,@"order_id",(_Select==80?@"1":@"2"),@"pay_type",nil];

    
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=支付====%@",responseObject );
   
        if (_Select==80) {
            [self  payOfWXPayReqdata:JSONDic];

        }else{
            [self  payOfAliPayReqdata:(NSString*)JSONDic];
        }
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=支付====%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
    
}


#pragma mark  微信
-(void)payOfWXPayReqdata:(NSDictionary *)Dic_data{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(WXPayFinished:)
                                                 name:@"WXPayFinished"
                                               object:nil];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [NSString stringWithFormat:@"%@",[Dic_data objectForKey:@"partnerid"]];
    request.prepayId= [Dic_data objectForKey:@"prepayid"];
    request.package =[Dic_data objectForKey:@"package"];
    request.nonceStr= [Dic_data objectForKey:@"noncestr"];
    request.timeStamp= (UInt32)[[Dic_data objectForKey:@"timestamp"] intValue];
    request.sign= [Dic_data objectForKey:@"sign"];
    
    if ([WXApi sendReq:request]) {
        NSLog(@"支付中");
    }else{
        NSLog(@"支付调取失败");

    }
    
    DCorderDetailStatueViewController * statusvc = [DCorderDetailStatueViewController new];
    statusvc.orderID = self.orderID ;
    [[WXApiManager sharedManager] setPayControll:self WithStatusVC:statusvc];
    
}
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}


#pragma mark  支付宝
-(void)payOfAliPayReqdata:(NSString *)Dic_data{
    
    NSString *appScheme = @"unigoStorePay";
    
    [[AlipaySDK defaultService] payOrder:Dic_data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝支付回调====reslut = %@",resultDic);

        if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [UIHelper  alertWithTitle:@"支付失败！"];
        }
    }];
}

# pragma  mark 微信支付完成回调

- (void)WXPayFinished:(NSNotification*)notify{
    //BOOL pop = NO;
    NSString *requestStr = notify.object;
    NSLog(@"--========%@==",notify);
    if ([requestStr isEqualToString:@"success"]) {
        NSLog(@"支付成功");
        [UIHelper  alertWithTitle:@"支付成功！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [UIHelper  alertWithTitle:@"支付失败！"];
        NSLog(@"支付失败");
    }
    
}


#pragma mark 支付宝快捷支付


-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"-----===0=%@",result);
}
//wap回调函数
 
-(void)paymentResult:(NSNotification *)usefication
{
    NSDictionary *dic=(NSDictionary*)usefication.object;
    NSString *res=[dic objectForKey:@"resultStatus"];
    NSLog(@"resultStatus==dic===%@",dic);
	if (dic)
    {
		if ([res intValue] == 9000)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [UIHelper  alertWithTitle:@"支付成功！"];
            
            UIViewController * viewVC = self.navigationController.viewControllers.firstObject;
            DCorderDetailStatueViewController * statusvc = [DCorderDetailStatueViewController new];
            statusvc.orderID = self.orderID ;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [viewVC.navigationController pushViewController:statusvc animated:YES];
        }
        else
        {
            //交易失败
            [UIHelper  alertWithTitle:@"支付失败！"];
        }
    }
    else
    {
        //失败
        [UIHelper  alertWithTitle:@"支付失败！"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark 添加订单倒计时

-(void)sumTimeOfIndeent:(NSString*)time{
    
    int remainTime=[time intValue]/1000;
    
    if ([time length]>1) {
        _SumRemainTime=remainTime;
    }else{
    
    }
    
    int min=_SumRemainTime/60;
    int secon=_SumRemainTime%60;
    
    NSString *strMin=[NSString stringWithFormat:@"%d",min];
    if (min<10) {
        strMin=[NSString stringWithFormat:@"0%d",min];
    }
    NSString *strSecon=[NSString stringWithFormat:@"%d",secon];
    if (secon<10) {
        strSecon=[NSString stringWithFormat:@"0%d",secon];
    }
    
    _remTimeLabel.text=[NSString stringWithFormat:@"%@:%@",strMin,strSecon];
    _remTimeLabel.text=[NSString stringWithFormat:@"请在 %@:%@ 分钟内完成支付",strMin,strSecon];
    
    [self makeAttributedString:_remTimeLabel WithString:[NSString stringWithFormat:@"%@:%@",strMin,strSecon]];
    
    
    if (!timer1) {
        timer1 =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTimeOfOrder:) userInfo:nil repeats:YES];
        [timer1 fire];

    }
    
    
}
-(void)showTimeOfOrder:(NSTimer*)timer{
    
    
    if (_SumRemainTime<=0) {
        
        _remTimeLabel.text=@"00:00";
        
        
        [_payButton setTitle:@"订单已过有效期" forState:UIControlStateNormal];
        _payButton.enabled=NO;
        _payButton.backgroundColor=[UIColor colorWithWhite:0.0/255.0 alpha:0.1];
//        [self.navigationController  popToRootViewControllerAnimated:YES];
        return;
    }else{
        
        
        int min=_SumRemainTime/60;
        int secon=_SumRemainTime%60;
        
        
        NSString *strMin=[NSString stringWithFormat:@"%d",min];
        if (min<10) {
            strMin=[NSString stringWithFormat:@"0%d",min];
        }
        NSString *strSecon=[NSString stringWithFormat:@"%d",secon];
        if (secon<10) {
            strSecon=[NSString stringWithFormat:@"0%d",secon];
        }
        
        _remTimeLabel.text=[NSString stringWithFormat:@"%@:%@",strMin,strSecon];
        
        _remTimeLabel.text=[NSString stringWithFormat:@"请在 %@:%@ 分钟内完成支付",strMin,strSecon];
        
        [self makeAttributedString:_remTimeLabel WithString:[NSString stringWithFormat:@"%@:%@",strMin,strSecon]];
//        请在30分钟内完成支付
        
    }
    _SumRemainTime--;
    
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag==100) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }

}

@end
