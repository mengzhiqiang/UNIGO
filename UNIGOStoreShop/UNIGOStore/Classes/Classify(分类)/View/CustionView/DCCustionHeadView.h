//
//  DCCustionHeadView.h
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCustionHeadView : UICollectionReusableView

/** 筛选点击回调 */
@property (nonatomic, copy) void (^backIndex) (NSDictionary * diction);

@property (assign , nonatomic)int sort;   //排序 1综合2销量3新品4价格 默认为1综合
@property (assign , nonatomic)BOOL isSort;  //排序 默认为0升序 1降序


@end
