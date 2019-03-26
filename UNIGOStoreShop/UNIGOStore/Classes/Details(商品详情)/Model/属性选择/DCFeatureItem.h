//
//  DCFeatureItem.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCFeatureTitleItem,DCFeatureList;

@interface DCFeatureItem : NSObject

/* 名字 */
//@property (strong , nonatomic)DCFeatureTitleItem *attr;
///* 数组 */
@property (strong , nonatomic)NSArray<DCFeatureList *> *list;

@property (strong , nonatomic)NSString * title;

@property (strong , nonatomic)NSArray *listKeys;
@property (strong , nonatomic)NSArray *listValue;

@property (assign , nonatomic)NSInteger  index;  //选择第几个


@end
