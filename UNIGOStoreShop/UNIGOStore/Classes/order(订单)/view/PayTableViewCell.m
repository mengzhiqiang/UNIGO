//
//  PayTableViewCell.m
//  TeeLab
//
//  Created by teelab2 on 14/12/15.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import "PayTableViewCell.h"
#import "Define.h"
#import "ExtendClass.h"
@implementation PayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    float  height=(isPAD_or_IPONE4 ?70 :90*RATIO);

    _paySelectOrNo.frame=CGRectMake(SCREEN_WIDTH -40,  (height-20)/2, 20, 20);
    
    float  width=(iPhone6plus?75:50*RATIO);
    
    
    _payImageView.frame=CGRectMake(36,( height-width)/2, width, width);
    
    _payName.frame=CGRectMake(_payImageView.frame.origin.x +_payImageView.frame.size.width+15, ( height-35)/2,150, 15);
    
    _payContent.frame=CGRectMake(_payImageView.frame.origin.x +_payImageView.frame.size.width+15, ( height-35)/2+23,160, 12);

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//////设置可变字符串 label
-(void)makeAttributedString:(UILabel *) label WithString:(NSString *)string {
    
    if (!string) {
        return;
    }
    
    NSMutableAttributedString  *str= [[NSMutableAttributedString alloc] initWithString:label.text];
    NSDictionary  *dic=@{NSForegroundColorAttributeName: [UIColor HexString:@"737373"]};
    
    NSRange range=[label.text rangeOfString:string];
    [str setAttributes:dic range:range];
    
    label.attributedText=str;
}

@end
