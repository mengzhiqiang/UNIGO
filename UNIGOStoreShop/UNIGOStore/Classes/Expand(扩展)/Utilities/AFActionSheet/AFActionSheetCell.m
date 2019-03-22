//
//  AFActionSheetCell.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFActionSheetCell.h"
#import "UIView+ZHRoundCorner.h"



#define ActionSheetCell_TitleLabel_Font             [UIFont systemFontOfSize:17.0f]//[UIFont boldSystemFontOfSize:17.0]
#define ActionSheetCell_TitleLabel_Normal_Color     [UIColor colorWithHexValue:0x000000]
#define ActionSheetCell_TitleLabel_Cancel_Color     [UIColor colorWithHexValue:0x000000]//[UIColor colorWithHexValue:0x888888]
#define ActionSheetCell_Divider_LefRight_Margin 0
#define ActionSheetCell_CornerRadius 0.0f

@interface AFActionSheetCell()

@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, weak) UIView *divider;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL isFirstCell;
@property (assign, nonatomic) BOOL isLastCell;
@property (assign, nonatomic) BOOL isLastSecondCell;

@end

@implementation AFActionSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self baseBuild];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - 基本设置
- (void)baseBuild
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

#pragma mark - SetupSubviews
- (void)setupSubviews
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = ActionSheetCell_TitleLabel_Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *divider = [UIView new];
    divider.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:divider];
    self.divider = divider;
    
//    self.contentView.alpha = 0.5f;
}

#pragma mark - Set Frame
- (void)setFrame:(CGRect)frame
{
    if (self.isLastCell) {
        frame.origin.y += ActionSheetLastCell_Padding;
    }
    [super setFrame:frame];
}

#pragma mark - LayoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    self.divider.frame = CGRectMake(ActionSheetCell_Divider_LefRight_Margin, self.bounds.size.height - 1, self.bounds.size.width - ActionSheetCell_Divider_LefRight_Margin * 2, 1);
    
    // 分割线
    if (self.isLastSecondCell || self.isLastCell) {
        self.divider.hidden = YES;
    } else {
        self.divider.hidden = NO;
    }
    
    // 文字颜色
    if (self.isLastCell) {
        self.titleLabel.textColor = ActionSheetCell_TitleLabel_Cancel_Color;
    } else {
        self.titleLabel.textColor = ActionSheetCell_TitleLabel_Normal_Color;
    }
    
    // 设置圆角
    if (self.isFirstCell) {
        [self zh_setCornerOnTopWithCornerRadius:ActionSheetCell_CornerRadius];
    } else if (self.isLastSecondCell) {
        [self zh_setCornerOnBottomWithCornerRadius:ActionSheetCell_CornerRadius];
    } else if (self.isLastCell) {
        [self zh_setAllCornerWithCornerRadius:ActionSheetCell_CornerRadius];
    }
}

#pragma mark - Set Data
- (void)setCellTitle:(NSString *)cellTitle
{
    _cellTitle = cellTitle.copy;
    
    self.titleLabel.text = _cellTitle;
}

- (void)setIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    self.indexPath = indexPath;
    self.tableView = tableView;
    
    NSInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
    self.isFirstCell = indexPath.row == 0;
    self.isLastCell = indexPath.row == (rowCount - 1) ;
    self.isLastSecondCell = indexPath.row == (rowCount - 2);
}

@end
