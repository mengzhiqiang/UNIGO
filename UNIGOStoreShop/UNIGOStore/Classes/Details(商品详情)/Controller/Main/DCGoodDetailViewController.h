//
//  DCGoodDetailViewController.h
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCGoodDetailViewController : UIViewController

/* 商品id */
@property (strong , nonatomic)NSString *goodID;
/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

/* 商品轮播图 */
@property (copy , nonatomic)NSArray *shufflingArray;


/* 商品详情url */
@property (strong , nonatomic)NSString *detailUrl;
@end
