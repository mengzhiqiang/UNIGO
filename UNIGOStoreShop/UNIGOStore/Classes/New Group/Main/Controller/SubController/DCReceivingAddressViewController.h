//
//  DCReceivingAddressViewController.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/18.
//Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCAdressItem.h"

@interface DCReceivingAddressViewController : UIViewController

@property(nonatomic , assign) int  pushTag ; //1 正常   2地址选择


@property(nonatomic , strong) DCAdressItem  * selectAddrss ; //选择配送地址

@end
