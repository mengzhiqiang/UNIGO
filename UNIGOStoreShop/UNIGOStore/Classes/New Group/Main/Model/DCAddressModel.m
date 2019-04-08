//
//  DCAddressModel.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 7/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCAddressModel.h"


static DCAddressModel *_DBCtl = nil;

@implementation DCAddressModel


+ (instancetype)sharedDataBase
{
    if (_DBCtl == nil) {
        _DBCtl = [[DCAddressModel alloc] init];
   
    }
    
    return _DBCtl;
}

-(NSMutableArray*)addressList{
    
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}

@end
