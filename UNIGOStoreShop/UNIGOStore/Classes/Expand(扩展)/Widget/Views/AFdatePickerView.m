//
//  AFdatePickerView.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/19.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFdatePickerView.h"

@interface AFdatePickerView()
@property (weak, nonatomic) IBOutlet UIView *backGroundView;


@end

@implementation AFdatePickerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    _datePickerView.maximumDate=[NSDate date];
    _datePickerView.backgroundColor=[UIColor whiteColor];
    [self addDatePickerSeclect];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_backGroundView addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyBoard{
    [self confirmDateBuuton:nil];

}
-(void)addDatePickerSeclect{

    [_datePickerView addTarget:self action:@selector(dateChange)forControlEvents:UIControlEventValueChanged];

}
-(void)dateChange{
    _ShowDateLabel.text = [self selectBabyDate];
}
- (IBAction)confirmDateBuuton:(UIButton *)sender {
    
    if (sender.tag==10) {
        ///确定
        _clickCommirbtnBlock([self selectBabyDate]);
    }else{
    
    
    }
    
    [self showOrHiddenDate:YES];

}

-(void)showOrHiddenDate:(BOOL)hidden{

    if (hidden) {
        _backGroundView.hidden=YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.rootView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
        }];
        [self performSelector:@selector(hiddenSelfView) withObject:nil afterDelay:0.5];
        
    }else{
        _backGroundView.hidden=NO;
        self.rootView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
        [UIView animateWithDuration:0.5 animations:^{
            self.rootView.frame = CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 260);
            self.hidden=NO;
        }];
    }

}
-(void)hiddenSelfView{

    self.hidden=YES;
}
#pragma mark  当前选择的日期
-(NSString*)selectBabyDate{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str= [outputFormatter stringFromDate:_datePickerView.date];
    NSLog(@"====str==%@",str);
    
    return str;
}

@end
