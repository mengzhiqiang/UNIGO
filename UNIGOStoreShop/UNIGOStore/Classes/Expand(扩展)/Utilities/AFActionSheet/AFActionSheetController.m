//
//  AFActionSheetController.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFActionSheetController.h"
#import "AFActionSheetCell.h"
#


#define ActionSheetToWindowLeftRightMargin 0
#define ActionSheetToWindowBottomMargin 0
#define ActionSheetCellHeight 50
#define ActionSheetAnimateDuration 0.2


@interface AFActionSheetController ()<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (weak, nonatomic) UIView *cover;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString *aTitle;

@property (nonatomic, copy) AFActionSheetBlock actionCallBackBlock;

@end

@implementation AFActionSheetController

#pragma mark - Init Methods
- (void)dealloc
{
    NSLog(@"dead ActionSheet");
}


- (instancetype)initWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles callBackBlock:(AFActionSheetBlock)callBackBlock
{
    if (self = [super init]) {
        self.aTitle = title;
        self.actionTitles = actionTitles;
        self.actionCallBackBlock = callBackBlock;
    }
    return self;
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles callBackBlock:(AFActionSheetBlock)callBackBlock
{
    return [[AFActionSheetController alloc] initWithTitle:title actionTitles:actionTitles callBackBlock:callBackBlock];
}

- (instancetype)initWithTitle:(NSString *)title ctionTitles:(NSArray *)actionTitles delegate:(id<AFActionSheetControllerDelegate>)delegate
{
    if (self = [super init]) {
        self.aTitle = title;
        self.actionTitles = actionTitles;
        self.delegate = delegate;
    }
    return self;
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles delegate:(id<AFActionSheetControllerDelegate>)delegate
{
    return [[AFActionSheetController alloc] initWithTitle:title ctionTitles:actionTitles delegate:delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBasic];
    [self setupCover];
    [self setupTableView];
}

#pragma mark - Class Init

#pragma mark - Setup Basic
- (void)setupBasic
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Setup & Layout Subviews
- (void)setupCover
{
    UIView *cover = [UIView new];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    cover.frame = self.view.bounds;
    cover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [cover addGestureRecognizer:tap];
    cover.userInteractionEnabled = YES;
    [self.view addSubview:cover];
    self.cover = cover;
}

- (void)setupTableView
{
    UITableView *tableView = [UITableView new];
    
    // 注册Cell
    [tableView registerClass:[AFActionSheetCell class] forCellReuseIdentifier:NSStringFromClass([AFActionSheetCell class])];
    // 去滚动条
    tableView.showsVerticalScrollIndicator = NO;
    // 去footer
    UIView *tableFooterView = [UIView new];
    tableView.tableFooterView = tableFooterView;
    // 去分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 背景色
    tableView.backgroundColor = [UIColor clearColor];
    // DataSource Delegate
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    // 行高
    tableView.rowHeight = ActionSheetCellHeight;
    
    tableView.alpha = 0.95;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.actionTitles.count) {
        [self configTableViewFrame];
    }
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actionTitles.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AFActionSheetCell class])];
    if (indexPath.row == self.actionTitles.count) {
        cell.cellTitle = @"取消";
        [cell setIndexPath:indexPath tableView:tableView];
    } else {
        cell.cellTitle = self.actionTitles[indexPath.row];
        [cell setIndexPath:indexPath tableView:tableView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideWithIndex:indexPath.row];
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,15,0,15)];
    }
}
#pragma mark - Set Accessors
- (void)setActionTitles:(NSArray *)actionTitles
{
    _actionTitles = actionTitles;
    
    [self configTableViewFrame];
    
    [self.tableView reloadData];
}

- (void)configTableViewFrame
{
    // ActionSheetLastCell_Padding 最后一个cell和倒数一个cell之间间距
    CGFloat tableViewHeight = (self.actionTitles.count + 1) * ActionSheetCellHeight + ActionSheetLastCell_Padding;
    self.tableView.frame = CGRectMake(ActionSheetToWindowLeftRightMargin, self.view.bounds.size.height - tableViewHeight - ActionSheetToWindowBottomMargin, self.view.bounds.size.width - ActionSheetToWindowLeftRightMargin * 2, tableViewHeight);
}

#pragma mark - Actions

#pragma mark - Show & Hide
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    // 动画
    _cover.alpha = 0.0;
    self.tableView.transform = CGAffineTransformMakeTranslation(0, self.tableView.bounds.size.height);
    [UIView animateWithDuration:ActionSheetAnimateDuration animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
        _cover.alpha = 0.3;
    }];
}

- (void)hide
{
    [self hideWithIndex:self.actionTitles.count];
}

- (void)hideWithIndex:(NSInteger)index
{
    [UIView animateWithDuration:ActionSheetAnimateDuration animations:^{
        self.cover.alpha = 0.0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, self.tableView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        //block 回调
        !_actionCallBackBlock ? : _actionCallBackBlock(index);
        // 调用代理方法
        if ([self.delegate respondsToSelector:@selector(actionSheetController:clickedButtonAtIndex:)]) {
            [self.delegate actionSheetController:self clickedButtonAtIndex:index];
        }
    }];
}


@end
