/******************************************************
 *标题:         uiView
 *创建人:        m
 *创建日期:      14-05-18
 *功能及说明:    相关uiview的封装－－均未类方法  统计分析
 *
 *修改记录列表:
 *修改记录:
 *修改日期:
 *修改者:
 *修改内容简述:
 *********************************************************/
#import <Foundation/Foundation.h>
//#import "DXAlertView.h"
#import "Define.h"

//@protocol PassValueForAlertDelegate <NSObject>
//
//-(void)recieveTextfield:(NSString*)string;
//
//@end

@interface UIHelper : NSObject


/**************************************************************
 ** 功能:     网络判断
 ** 参数:     wu
 ** 返回:     网络是否可用
 **************************************************************/
+(BOOL)isNetworking;


/**************************************************************
 ** 功能:     弹出toast提示
 ** 参数:     nsstring
 ** 返回:     无
 **************************************************************/
+ (void)alertWithTitle:(NSString*)title;

#pragma mark 顶栏提示框
/**************************************************************
 ** 功能:     弹出顶部提示    警告提示
 ** 参数:     nsstring 提示语   背景颜色
 ** 返回:     无
 **************************************************************/
+ (void)showUpMessage:(NSString *)message;
+ (void)showUpMessage:(NSString *)message withColor:(UIColor*)color;

/**************************************************************
 ** 功能:     alert提示
 ** 参数:     nsstring（提示内容内容）、代理对象
 ** 返回:     无
 **************************************************************/
+ (void)alertWithTitle:(NSString*)title
               WithMsg:(NSString*)msg
              delegate:(id)sender
              BtnTitle:(NSString*)btnTitle
            otherTitle:(NSString*)otherTitle
                andTag:(NSInteger)tag
            backHander:(void(^)())back
           otherHander:(void(^)())otherback;

/**************************************************************
 ** 功能:     加loading view  (新加)
 ** 参数:     cgrect(loadingview的frame)、id（加在此对象上）
 ** 返回:     无
 **************************************************************/
+ (void)addLoadingViewTo:(UIView*)targetV  andText:(NSString*)text;

/**************************************************************
 ** 功能:     加loading view
 ** 参数:     cgrect(loadingview的frame)、id（加在此对象上） 新
 ** 返回:     无
 **************************************************************/
+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(int)height;

+(BOOL)TitleMessage:(NSDictionary *)Dic_data ;

+(void)pushLoinViewContrlller;  ///跳转登录页


//+(void)hiddenAlert;
+(void)hiddenAlertWith:(UIView*)targetV;

/**************************************************************
 ** 功能:     调整label 大小
 ** 参数:     当前label 大小size
 ** 返回:     laber size
 **************************************************************/
+(CGSize) makeNewRectView:(UILabel*)mylabel oldSize:(CGSize) oldsize;


/**************************************************************
 ** 功能:     清除ui数据
 ** 参数:     uiview
 ** 返回:     无
 **************************************************************/
+(void)ClearViewOFView:(UIView*)view;



@end
