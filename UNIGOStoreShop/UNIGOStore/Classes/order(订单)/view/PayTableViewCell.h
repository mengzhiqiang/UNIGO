//
//  PayTableViewCell.h
//  TeeLab
//
//  Created by teelab2 on 14/12/15.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIImageView *payImageView;
@property (strong, nonatomic) IBOutlet UILabel *payName;
@property (strong, nonatomic) IBOutlet UILabel *payContent;
@property (strong, nonatomic) IBOutlet UILabel *paySelectOrNo;


-(void)makeAttributedString:(UILabel *) label WithString:(NSString *)string ;


@end
