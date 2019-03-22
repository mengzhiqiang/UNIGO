//
//  AFManageTableViewCell.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/9.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFManageTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Regular.h"
#import "AFAccountEngine.h"
#import "UIImageView+AFNetworking.h"
@implementation AFManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellFrame:(CGRect )cellFrame{
    _rootCellView.frame = cellFrame;
    
}
-(void)setHeadImageFrame:(CGRect)headImageFrame{
    _headImageView.frame = headImageFrame;
}

-(void)changeHeadImageView:(NSDictionary*)dic{

    _rootCellView.frame= CGRectMake(0,0,SCREEN_WIDTH,88);
   
    _headImageView.frame= CGRectMake(13, (88-65)/2, 65, 65);
    
//    [_headImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"account_head_Device"] ];
    [_headImageView draCirlywithColor:[UIColor clearColor] andRadius:_headImageView.width/2];
    _titlelable.frame= CGRectMake(_headImageView.right+22.5,( _rootCellView.height-16)/2, 130, 16);
    
}
////家长头像
-(void)headImageWithPar:(NSDictionary*)dic
{
    AFAccount *account = [AFAccountEngine sharedInstance].currentAccount;
    
    AFAccountAvatar *avatar = account.avatar;
    _subTitleLabel.textAlignment =NSTextAlignmentLeft;
    
    _subTitleLabel.text =account.mobile;
    _titlelable.text   = account.nickName;

    _headImageView.frame= CGRectMake(12, (88-64)/2, 64, 64);
    
    [_headImageView setImageWithURL:[NSURL URLWithString:avatar.medium ] placeholderImage:[UIImage imageNamed:@"icon_mobile_parents_placeholder"] ];
    
    [_headImageView draCirlywithColor:[UIColor clearColor] andRadius:_headImageView.width/2];
    _titlelable.frame= CGRectMake(_headImageView.right+16, ( _rootCellView.height-16)/2, 130, 16);
    _subTitleLabel.frame= CGRectMake(_titlelable.left, _titlelable.bottom+10, 130, 14);
    
}
////乐迪头像
-(void)headImageWithJiajia:(NSDictionary*)dic{
    
    _rootCellView.frame= CGRectMake(0,0,SCREEN_WIDTH,88);

    _headImageView.frame= CGRectMake(16, 4, 60, 80);
    NSDictionary*product = [dic objectForKey:@"product"];
    

    [self.headImageView  setImageWithURL:[NSURL URLWithString:[[product objectForKey:@"image"] objectForKey:@"small"]] placeholderImage:[UIImage imageNamed:@"jiajiaRobot_bangding"] ];
    
    
    if ([[product allKeys] count]>0) {
        _titlelable.text =  [product objectForKey:@"name"];
        _subTitleLabel.text = [NSString stringWithFormat:@"%@ %@",[[product objectForKey:@"color"] objectForKey:@"main"],[product objectForKey:@"model"]];
    }
    
    _titlelable.frame= CGRectMake(_headImageView.right+6, 44-16, 130, 16);
    _subTitleLabel.frame= CGRectMake(_titlelable.left, _titlelable.bottom+10, 130, 14);

}

-(void)showBabyHeadImageWithImage:(UIImage *)Image  andUrl:(NSString*)url{

    if (Image) {
        self.headImageView.image =( Image?Image:[UIImage imageNamed:@"iconbaby"]);
    }else{
        
        [self.headImageView  setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"iconbaby"]];
    }
}

-(void)showrqcode{
    
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc]init];
        _qrcodeImageView.frame = CGRectMake(_rootCellView.width-30-12-8, (_rootCellView.height-20)/2, 20, 20);
        _qrcodeImageView.image =[UIImage imageNamed:@"icon_qrcode"];

        [_rootCellView addSubview:_qrcodeImageView];
    }
    _qrcodeImageView.hidden=NO;
}

@end
