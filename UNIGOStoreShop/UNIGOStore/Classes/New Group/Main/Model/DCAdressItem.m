//
//  DCAdressItem.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/19.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCAdressItem.h"
#import "DCAdressDateBase.h"
@implementation DCAdressItem

- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    
    CGFloat top = 52;
    CGFloat bottom = 46;
    CGFloat middle = [DCSpeedy dc_calculateTextSizeWithText:[NSString stringWithFormat:@"%@ %@",_district,_address] WithTextFont:14 WithMaxW:ScreenW - 24].height;
    
    return top + middle + bottom;;
}


+ (void)load
{
    [DCAdressItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}


-(void )setAddressArea{
    
    NSArray * pro = [DCAdressDateBase sharedDataBase].adressList ;
    
    NSString * pro_string  ;
    NSString * city_string  ;
    NSString * district_string  ;

    for (NSDictionary*dic in pro) {
        if ([[dic objectForKey:@"code"] isEqualToString:self.province]) {
            pro_string = [dic objectForKey:@"name"] ;
            NSArray * city = [dic objectForKey:@"cityList"];
            for (NSDictionary*d in city) {
                if ([[d objectForKey:@"code"] isEqualToString:self.city]) {
                    city_string = [d objectForKey:@"name"] ;
                    NSArray * area = [d objectForKey:@"areaList"];
                    for (NSDictionary*ar in area) {
                        if ([[ar objectForKey:@"code"]isEqualToString:self.district]) {
                            district_string = [ar objectForKey:@"name"];
                            
                            self.address_area = [NSString stringWithFormat:@"%@-%@-%@ ",pro_string,city_string,district_string];
                            return ;
                        }
                    }
                }
            }
        }
    }
    
    return  ;
}
@end
