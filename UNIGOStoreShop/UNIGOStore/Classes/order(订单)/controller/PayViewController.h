//
//  PayViewController.h
//  TeeLab
//
//  Created by teelab2 on 14-4-30.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UPPayPluginDelegate.h"
//#import "NETworking.h"
#import "TitleOfHeardViewController.h"

//#import "AlixLibService.h"

#import "WXApi.h"
@interface Product : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end


@interface PayViewController : TitleOfHeardViewController{
    NSMutableArray *_products;
    SEL _result;
    
    NSTimer* timer1;

}


@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;


@property (strong, nonatomic)  NSString *NewOrder;           ///刚提交进来的的订单 不能返回上一页面
@property (strong, nonatomic)  NSString *orderID;           ///订单号
@property (strong, nonatomic)  NSString *SumOfPrice;           ///订单号

@property (assign, nonatomic)  int    platform;           ///平台
@property (strong, nonatomic) IBOutlet UILabel *SumLabel;

@property (nonatomic, assign) int Select;

@property (strong, nonatomic) IBOutlet UIView *payButtonView;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UITableView *rootTableView;
@property (weak, nonatomic) IBOutlet UILabel *remTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *remTimeView;


@property (assign, nonatomic)  int   SumRemainTime;


@end
