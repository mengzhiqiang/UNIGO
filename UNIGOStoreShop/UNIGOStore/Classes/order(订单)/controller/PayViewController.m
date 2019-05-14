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

#import <AlipaySDK/AlipaySDK.h>   ///支付宝

//微信
#import "WXApiObject.h"
#import "WXApi.h"


#import "UIHelper.h"
#import "ExtendClass.h"
#import "PayViewController.h"

//#import "AppDelegate.h"

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
    NSMutableDictionary *dic0=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.orderID,@"orderId",nil];
/*  网络请求 订单数据
    [self.netWorks_dad netWorkingpost:[Parameter commonConvertToDict:dic0 pram:@"QueryOrderById"] pram:nil];
    self.netWorks_dad.delegate=self;
    */
    
//    _SumLabel.text = @"889.00";
    
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
            [self  payOfAliPayReqdata:JSONDic];
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
    request.partnerId = [Dic_data objectForKey:@"mch_id"];
    request.prepayId= [Dic_data objectForKey:@"prepay_id"];
    request.package =[Dic_data objectForKey:@"package"];
    request.nonceStr= [Dic_data objectForKey:@"nonce_str"];
    request.timeStamp= (UInt32)[[Dic_data objectForKey:@"timestamp"] intValue];
    request.sign= [Dic_data objectForKey:@"sign"];
    
    if ([WXApi sendReq:request]) {
        NSLog(@"支付中");
    }else{
        NSLog(@"支付调取失败");

    }
    
}

#pragma mark  支付宝
-(void)payOfAliPayReqdata:(NSDictionary *)Dic_data{
    
    NSString *appScheme = @"infiniteePay";

    [[AlipaySDK defaultService] payOrder:[Dic_data objectForKey:@"params"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSLog(@"支付宝支付回调====reslut = %@",resultDic);
        
        //                NSString *resultStatus = [NSString toNotNullString:[resultDic objectForKey:@"resultStatus"]];
        
        if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
        else {
            
            [UIHelper  alertWithTitle:@"支付失败！"];
        }
        
    }];
}


//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
//    
//    
//
//    if ([url.scheme isEqualToString:@"wx7cb421de4b3745a9"]) {
//        
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                                  standbyCallback:^(NSDictionary *resultDic) {
//                                                      NSLog(@"result = %@",resultDic);
//                                                  }]; }
//    
//    return YES;
//}

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


//- (void)showAlertMessage:(NSString*)msg
//{
//    mAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [mAlert show];
//

//}


#pragma mark 支付宝快捷支付
/*
-(NSString*)getOrderInfo:(NSInteger)index
{
 
	 *点击获取prodcut实例并初始化订单信息
 
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    
    order.tradeNO = self.orderID; //订单ID（由商家自行制定）

	order.productName = @"大哥大手机"; //商品标题
	order.productDescription = @"最新版神器，怀旧版大哥大，帅购啦！...."; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
	order.notifyURL =  @"http://121.40.69.188/TeeLab/paymentNotify/alipay"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
 */

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"-----===0=%@",result);
}
//wap回调函数
 
-(void)paymentResult:(NSString *)resultd
{
    
    NSLog(@"=====resultd===%@",resultd);
//    //结果处理
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//
    NSDictionary *dic=(NSDictionary*)resultd;
    NSString *res=[dic objectForKey:@"resultStatus"];
	if (dic)
    {
		
		if ([res intValue] == 9000)
        {
        NSLog(@"====支付宝支付成功===");
            [self.navigationController popToRootViewControllerAnimated:YES];
            
//			/// *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
// 
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//                NSLog(@"====支付宝支付成功===");
//                
//                
//                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"查看订单" otherButtonTitles:@"返回主页", nil];
//                [alert show];
////                [self payResultAlert];
//                
//			}
        }
        
        else
            
        {
            //交易失败
            NSLog(@"====支付宝支付失败===");

        }
    }
    else
    {
        //失败
        NSLog(@"====支付宝支付失败===");

    }
    
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
