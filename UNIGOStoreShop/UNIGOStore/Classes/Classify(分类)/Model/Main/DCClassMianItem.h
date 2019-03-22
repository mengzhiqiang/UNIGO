//
//  DCClassMianItem.h
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DCCalssSubItem;
@interface DCClassMianItem : NSObject

/** 文标题  */
@property (nonatomic, copy ,readonly) NSString *name;


/** goods  */
//@property (nonatomic, copy ,readonly) NSArray<DCCalssSubItem *> *goods;

/** 商品类题  */
@property (nonatomic, copy ,readonly) NSString *goods_title;

/** 商品图片  */
@property (nonatomic, copy ,readonly) NSString *pic;


@property (nonatomic, copy ,readonly) NSString *pid;

@property (nonatomic, copy ,readonly) NSString *id;

@end
