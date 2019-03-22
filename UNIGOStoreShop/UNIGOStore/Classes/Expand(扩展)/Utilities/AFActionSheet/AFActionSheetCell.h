//
//  AFActionSheetCell.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  最后一个cell和倒数一个cell之间间距
 */
#define ActionSheetLastCell_Padding 5

@interface AFActionSheetCell : UITableViewCell

@property (copy, nonatomic) NSString *cellTitle;

- (void)setIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end
