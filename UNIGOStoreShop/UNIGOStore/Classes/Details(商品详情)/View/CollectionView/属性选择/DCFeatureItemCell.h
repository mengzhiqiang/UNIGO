//
//  DCFeatureItemCell.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCFeatureList;
@interface DCFeatureItemCell : UICollectionViewCell

/* 内容数据 */
@property (nonatomic , copy) DCFeatureList *content;

/* 属性 */
@property (strong , nonatomic)UILabel *attLabel;


-(void)isSelect:(BOOL)bol;
@end
