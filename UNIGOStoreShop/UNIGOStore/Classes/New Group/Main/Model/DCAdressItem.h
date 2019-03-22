//
//  DCAdressItem.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/19.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCAdressItem : NSObject

@property(nonatomic,strong) NSNumber *ID;

/* 用户名 */
@property (nonatomic, copy) NSString *consignee;
/* 用户电话 */
@property (nonatomic, copy) NSString *mobile;
/* 选择地址地址 */
//@property (nonatomic, copy) NSString *chooseAdress;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;

/* 用户地址 */
@property (nonatomic, copy) NSString *address;

/* 默认地址 1为正常 2为默认 */
@property (nonatomic, copy) NSString *is_default;


/* 行高 */
@property (assign , nonatomic)CGFloat cellHeight;

@end
