//
//  AFActionSheetController.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AFActionSheetBlock)(NSInteger index);

@class AFActionSheetController;


@protocol AFActionSheetControllerDelegate <NSObject>

- (void)actionSheetController:(AFActionSheetController *)actionSheetController clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface AFActionSheetController : UIViewController

- (instancetype)initWithTitle:(NSString *)title ctionTitles:(NSArray *)actionTitles delegate:(id<AFActionSheetControllerDelegate>)delegate;
+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles delegate:(id<AFActionSheetControllerDelegate>)delegate;

//block 回调方法
- (instancetype)initWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles callBackBlock:(AFActionSheetBlock)callBackBlock;

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles callBackBlock:(AFActionSheetBlock)callBackBlock;


@property (strong, nonatomic) NSArray *actionTitles;
@property (weak, nonatomic) id<AFActionSheetControllerDelegate> delegate;
@property (assign, nonatomic) int tag;

- (void)show;
- (void)hide;

@end
