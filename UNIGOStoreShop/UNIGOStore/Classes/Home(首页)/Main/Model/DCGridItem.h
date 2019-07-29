//
//  DCGridItem.h
//  CDDMall
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCGridItem : NSObject

/** 图片  */
@property (nonatomic, copy ) NSString *image;
/** 文字  */
@property (nonatomic, copy ) NSString *name;
/** tag  */
@property (nonatomic, copy ) NSString *url;
/** tag颜色  */
//@property (nonatomic, copy ,readonly) NSString *gridColor;

@end
