//
//  RefreshDataManager.h
//  CompareTimeDemo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshDataManager : NSObject

//+ (RefreshDataManager *)sharedManager;

+ (BOOL)needRefreshData:(NSString *)recordDate;
@end
