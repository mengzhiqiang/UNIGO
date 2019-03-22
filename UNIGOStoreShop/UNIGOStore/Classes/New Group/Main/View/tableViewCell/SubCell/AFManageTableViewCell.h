//
//  AFManageTableViewCell.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/9.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TableEnterImageView;
@property (weak, nonatomic) IBOutlet UIView *rootCellView;
@property (assign, nonatomic)  CGRect cellFrame;
@property (assign, nonatomic)  CGRect headImageFrame;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (strong, nonatomic) UIImageView * qrcodeImageView; ///二维码图标

#pragma mark cell 1
@property (weak, nonatomic) IBOutlet UIImageView *jettImageView;
@property (weak, nonatomic) IBOutlet UILabel *jettNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *bandJettButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectimageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLineLabeltwo;


-(void)changeHeadImageView:(NSDictionary*)dic;

-(void)showBabyHeadImageWithImage:(UIImage *)Image  andUrl:(NSString*)url;

//显示二维码图标
-(void)showrqcode;
@end
