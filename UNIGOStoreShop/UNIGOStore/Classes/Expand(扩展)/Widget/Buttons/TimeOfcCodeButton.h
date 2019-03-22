//
//  TimeOfcCodeButton.h
//  ALPHA
//
//  Created by mzq on 15/11/16.
//  Copyright © 2015年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PassCodeOfiPoneDelegate <NSObject>

@optional
-(void)loadNewTitleOfNav:(NSString*)title;

-(NSString*)iphoneNumber;

@end


@interface TimeOfcCodeButton : UIButton

@property(nonatomic,strong)UILabel  * count_label;
@property (weak, nonatomic) id<PassCodeOfiPoneDelegate>delegate;

@property(nonatomic,strong)NSString  * ipone;

@property(nonatomic,strong)NSString *   codeStyle;  // 验证码类型1注册 2 找回密码 3绑定

-(void)LoadCountLable;


-(void)loadNewCodeWithIphone:(NSString*)ipone;

@end
