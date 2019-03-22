//
//  DCAdressItem.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/19.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCAdressItem.h"

@implementation DCAdressItem

- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    
    CGFloat top = 52;
    CGFloat bottom = 46;
    CGFloat middle = [DCSpeedy dc_calculateTextSizeWithText:[NSString stringWithFormat:@"%@ %@",_district,_address] WithTextFont:14 WithMaxW:ScreenW - 24].height;
    
    return top + middle + bottom;;
}

@end
