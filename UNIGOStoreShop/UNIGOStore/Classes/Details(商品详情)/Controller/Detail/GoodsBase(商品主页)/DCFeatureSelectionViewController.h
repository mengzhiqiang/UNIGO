//
//  DCFeatureSelectionViewController.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCFeatureSelectionViewController : UIViewController

/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;
/* 上一次选择的属性 */
@property (strong , nonatomic)NSMutableArray *lastSeleArray;
/* 上一次选择的数量 */
@property (assign , nonatomic)NSString *lastNum;

/* 规格参数 */
@property (strong , nonatomic)NSDictionary *goodsSpecValue;

@property (strong , nonatomic)NSDictionary *goodsInfomation;

///** 选择的属性和数量 */
//@property (nonatomic , copy) void(^userChooseBlock)(NSMutableArray *seleArray,NSInteger num,NSInteger tag);

@end
