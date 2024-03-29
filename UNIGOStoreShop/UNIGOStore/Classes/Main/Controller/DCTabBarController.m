//
//  DCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCTabBarController.h"

// Controllers
#import "DCNavigationController.h"
#import "LogInmainViewController.h"
#import "DCBeautyMessageViewController.h"
#import "UNStoreViewController.h"

#import "DCshopCarViewController.h"   //购物车
#import "DCCommodityViewController.h"  //分类
#import "DCNewWebViewController.h"

// Models

// Views
#import "DCTabBadgeView.h"
// Vendors

// Categories
#import "HttpRequestToken.h"

// Others

@interface DCTabBarController ()<UITabBarControllerDelegate>

//美信
@property (nonatomic, weak) DCBeautyMessageViewController *beautyMsgVc;

@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;

@end

@implementation DCTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    
    return _tabBarItems;
}

#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 添加通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeValue) name:DCMESSAGECOUNTCHANGE object:nil];
    
    // 添加badgeView
    [self addBadgeViewOnTabBarButtons];
    
    WEAKSELF
    [[NSNotificationCenter defaultCenter] addObserverForName:LOGINOFFSELECTCENTERINDEX object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.selectedViewController = [weakSelf.viewControllers objectAtIndex:DCTabBarControllerHome]; //默认选择商城index为1
    }];

}


#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addDcChildViewContorller];
    
    self.selectedViewController = [self.viewControllers objectAtIndex:DCTabBarControllerHome]; //默认选择商城index为1
}


#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
//                            @{MallClassKey  : @"UNStoreViewController",
//                              MallTitleKey  : @"发现",
//                              MallImgKey    : @"tabBar_find_normal",
//                              MallSelImgKey : @"tabBar_find_press"},
                            
                            @{MallClassKey  : @"DCHandPickViewController",
                              MallTitleKey  : @"首页",
                              MallImgKey    : @"tabBar_home_normal",
                              MallSelImgKey : @"tabBar_home_press"},
                            
                            @{MallClassKey  : @"DCCommodityViewController",
                              MallTitleKey  : @"分类",
                              MallImgKey    : @"tabBar_category_normal",
                              MallSelImgKey : @"tabBar_category_press"},
                            
                            @{MallClassKey  : @"DCNewWebViewController",
                              MallTitleKey  : @"BBS",
                              MallImgKey    : @"tabBar_find_normal",
                              MallSelImgKey : @"tabBar_find_press"},
                            
                            @{MallClassKey  : @"DCshopCarViewController",
                              MallTitleKey  : @"购物车",
                              MallImgKey    : @"tabBar_cart_normal",
                              MallSelImgKey : @"tabBar_cart_press"},
                            
                            @{MallClassKey  : @"DCMyCenterViewController",
                              MallTitleKey  : @"我的",
                              MallImgKey    : @"tabBar_myJD_normal",
                              MallSelImgKey : @"tabBar_myJD_press"},
                            
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController * vc = [NSClassFromString(dict[MallClassKey]) new];
        if ([dict[MallTitleKey] isEqualToString:@"购物车"]) {
            vc = [[NSClassFromString(dict[MallClassKey]) alloc] initWithNibName:@"DCshopCarViewController" bundle:nil];
        }
     
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);//（当只有图片的时候）需要自动调整
        item.title = dict[MallTitleKey];
        [self addChildViewController:nav];
        WEAKSELF
        if ([dict[MallTitleKey] isEqualToString:@"美信"]) {
            weakSelf.beautyMsgVc = (DCBeautyMessageViewController *)vc; //给美信赋值
        }
        self.tabBar.tintColor =[UIColor redColor];
        if (IOS_VERSION>=10.0) {
            self.tabBar.unselectedItemTintColor =[UIColor grayColor];
        }
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if(viewController == [tabBarController.viewControllers objectAtIndex:DCTabBarControllerPerson]){
        
//        if ([HttpRequestToken getToken].length<1) {
//            LogInmainViewController *dcLoginVc = [LogInmainViewController new];
//            [self presentViewController:dcLoginVc animated:YES completion:nil];
//            return NO;
//        }
    }
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
    if ([self.childViewControllers.firstObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jump" object:nil];
    }

}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];

    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}


#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
}


#pragma mark - 添加所有badgeView
- (void)addBadgeViewOnTabBarButtons {
    
    // 设置初始的badegValue
    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
    
    int i = 0;
    for (UITabBarItem *item in self.tabBarItems) {
        
        if (i == 0) {  // 只在美信上添加
            [self addBadgeViewWithBadgeValue:item.badgeValue atIndex:i];
            // 监听item的变化情况
            [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
            _item = item;
        }
        i++;
    }
}

- (void)addBadgeViewWithBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index {
    
    DCTabBadgeView *badgeView = [DCTabBadgeView buttonWithType:UIButtonTypeCustom];
    
    CGFloat tabBarButtonWidth = self.tabBar.dc_width / self.tabBarItems.count;
    
    badgeView.dc_centerX = index * tabBarButtonWidth + 40;
    
    badgeView.tag = index + 1;
    
    badgeView.badgeValue = badgeValue;
    
    [self.tabBar addSubview:badgeView];
}

#pragma mark - 只要监听的item的属性一有新值，就会调用该方法重新给属性赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:[DCTabBadgeView class]]) {
            if (subView.tag == 1) {
                DCTabBadgeView *badgeView = (DCTabBadgeView *)subView;
                badgeView.badgeValue = _beautyMsgVc.tabBarItem.badgeValue;
            }
        }
    }
    
}


#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
