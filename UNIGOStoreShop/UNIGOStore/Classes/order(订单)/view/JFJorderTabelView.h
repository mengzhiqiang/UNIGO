//
//  JFJorderTabelView.h
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFJorderTabelView : UITableView

@property(strong ,nonatomic) NSString * orderStyle ;

-(void)updataData:(NSArray* )array tagre:(UIViewController*)tagre;

@end

NS_ASSUME_NONNULL_END
