//
//  JettNoDataView.h
//  SmartDevice
//
//  Created by zhiqiang meng on 2017/12/30.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickRefreshBlock)();


@interface JettNoDataView : UIView

@property(nonatomic,strong) UIView    *  rootView;
@property(nonatomic,strong) ClickRefreshBlock  clikRefresh;
@property(nonatomic,strong) UIImageView *   bg_imageView;


-(void)addNoDataImageView:(ClickRefreshBlock)BackRefresh;

@end
