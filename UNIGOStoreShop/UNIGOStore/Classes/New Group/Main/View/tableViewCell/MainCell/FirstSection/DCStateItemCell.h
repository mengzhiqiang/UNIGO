//
//  DCStateItemCell.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCStateItem;
@interface DCStateItemCell : UICollectionViewCell

/* 数据 */
@property (strong , nonatomic)DCStateItem *stateItem;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;

@end
