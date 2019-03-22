//
//  AFdatePickerView.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/19.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFdatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *ShowDateLabel;
@property (copy, nonatomic) void (^clickCommirbtnBlock)(NSString *date);
@property (weak, nonatomic) IBOutlet UIView *rootView;

-(void)showOrHiddenDate:(BOOL)hidden;

@end
