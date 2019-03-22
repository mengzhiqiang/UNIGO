/******************************************************
 *标题:         类别类
 *创建人:        mzq
 *创建日期:      13-12-29
 *功能及说明:    各系统类的类别，实现系统类方法的拓展
 *
 *修改记录列表:
 *修改记录:
 *修改日期:
 *修改者:
 *修改内容简述:
 *********************************************************/

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"



#define SQUARE_WIDTH                146
#define SQUARE_HEITHG               126
#define SQUARE_X_SPACE              10
#define SQUARE_Y_SPACE_NOMAL        10

#define SQUARE_HEITHG_IPHONE5       154

#define IPHONE_5           @"iPhone 5"
#define IPHONE_4           @"iPhone 4"
#define IPHONE_4S          @"iPhone 4S"
#define IPHONE_3G          @"iPhone 3G"
#define IPHONE_3GS         @"iPhone 3GS"
#import <CommonCrypto/CommonCryptor.h>

@interface ExtendClass : NSObject

+(int)AdaptiveFrame;

+(int)CountOFNSString:(NSString*)sour;


@end

@interface NSString (Extend)

////////时间运算
+(NSString *)sourTime:(NSString *)time;

/////字符串长度 （字节）
-(NSString*)newSring:(NSString *)sou stringLength:(int)Leng;

//- (NSString *)newStringInBase64FromData;            //追加64编码
//+ (NSString*)base64encode:(NSString*)str;           //同上64编码


+ (NSString*) AES128Encrypt:(NSString *)plainText;

+ (NSString*) AES128Decrypt:(NSString *)encryptText;
/**************************************************************
 ** 功能:     邮费计算
 ** 参数:     nil
 ** 返回:     NSString
 **************************************************************/
-(NSString*)LoadNewPostageWithNumber:(NSString*)string ;


/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  当前时间  赛区结束时间
 ** 返回:     NSString 时间差 数据 剩余多少秒
 **************************************************************/
-(NSString*)surplusNowTime:(NSString*)timeStr surplusGamesTimes:(NSString*)GamesTimes;


/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  当前时间  赛区结束时间
 ** 返回:     NSString 时间差 (显示的时间)
 **************************************************************/
-(NSString *)ShowtimePurNowTime:(NSString*)timeStr surplusGamesTimes:(NSString*)GamesTimes;

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  作品创作时间
 ** 返回:     NSString  时间展示 (显示的时间)
 **************************************************************/
-(NSString *)ShowLaterTimeNowTime:(NSString*)Workingtime;

//////解析thml
/**************************************************************
 ** 功能:     温馨提示thml解析
 ** 参数:     nssgring
 ** 返回:     NSString
 **************************************************************/
-(NSString*)GetThmlOfString:(NSString*)sender;

/**************************************************************
 ** 功能:     电话号码正则
 ** 参数:     无
 ** 返回:     bool
 **************************************************************/
- (BOOL)validatePhoneNumber;


/**************************************************************
 ** 功能:     email正则
 ** 参数:     无
 ** 返回:     bool
 **************************************************************/
-(BOOL)validateEmail;

/**************************************************************
 ** 功能:     md5加密
 ** 参数:     无
 ** 返回:     nsstring（加密后字符串）
 **************************************************************/
-(NSString *) md5HexDigest;


/**************************************************************
 ** 功能:     获取当前设备型号
 ** 参数:     无
 ** 返回:     字符串
 **************************************************************/
+ (NSString*)deviceString;

- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;

@end

@interface UIImageView (Extend)
/**************************************************************
 ** 功能:     二级界面构成－－方形背景
 ** 参数:     整型数（界面第几个view，从0开始,横向数）
 ** 返回:     imageview
 **************************************************************/
+ (UIImageView*)squareBackgroundViewWithNum:(NSInteger)num;

/**************************************************************
 ** 功能:     头像添加新浪认证
 ** 参数:     UIButton  按钮   style 认证类型 tag 扩展
 ** 返回:     无
 **************************************************************/
- (void)addSinaVWithBtn:(UIView*)btn style:(NSString*)style andBtnTag:(NSString*)tag;

@end


@interface UILabel (Extend)

/**************************************************************
 ** 功能:     二级界面构成－－方形图上的lable
 ** 参数:     字符串（lable上的text）
 ** 返回:     uilable
 **************************************************************/
+ (UILabel*)squareCenterLableWithText:(NSString*)text;
///设置位圆角阴影
-(UILabel*)markround:(UILabel*)view Color:(UIColor*)color;

-(UILabel*)customLabel:(UILabel*)label withString:(NSString*)string font:(UIFont*)font;
@end


@interface UIButton (Extend)

/**************************************************************
 ** 功能:     二级界面构成－－方形图上最外层button
 ** 参数:     整型数（界面第几个view，从0开始,横向数）
 ** 返回:     uibutton
 **************************************************************/
+ (UIButton*)squareCenterButtonWithNum:(NSInteger)num;

/**************************************************************
 ** 功能:     增加删除效果
 ** 参数:     UIView（加在此view上），CGRect（frame）
 ** 返回:     无
 **************************************************************/
//- (void)addDeleteCoverViewWithBtnTaget:(id)sender andBtnTag:(NSInteger)tag;

@end


@interface UIView (Extend)
/**************************************************************
 ** 功能:     下载的progerssview
 ** 参数:     frame，背景颜色，透明度
 ** 返回:     uiview
 **************************************************************/
+ (UIView*)progressViewWithFrame:(CGRect)frame color:(UIColor*)color alpha:(CGFloat)alpha andText:(NSString*)text;

/**************************************************************
 ** 功能:     查勘案件信息展示背景view
 ** 参数:     无
 ** 返回:     无
 **************************************************************/
//+ (UIView*)checkBgViewWithNum:(NSInteger)num;


///设置位圆角
+(UIView*)markround:(UIView*)view radius:(float)rad Width:(float)wid Color:(UIColor*)color;


@end


@interface NSObject (Extend)

/**************************************************************
 ** 功能:     协助解析 将object对象转成数组
 ** 参数:     无
 ** 返回:     数组
 **************************************************************/
- (NSArray*)convertToArray;

/**************************************************************
 ** 功能:     协助解析 将object对象转成字典
 ** 参数:     无
 ** 返回:     数组
 **************************************************************/
- (NSDictionary*)convertToDict;

/**************************************************************
 ** 功能:     传入 code
 ** 参数:     无
 ** 返回:     数组
 **************************************************************/
//- (NSDictionary*)convertToDict;

@end


@interface UIImage (Extend)

//非缓存
+ (UIImage *)imageNamedNoCache:(NSString *)imageName;

- (UIImage *)fixOrientation:(UIImage *)aImage;

/**************************************************************
 ** 功能:     获取背景衣服
 ** 参数:      （颜色 大小 样式）
 ** 返回:     image
 **************************************************************/
//+ (UIImage *)imageColour:(NSString *)colour Size:(NSString*)size Style:(NSString*)style;

///////改变图片颜色
- (UIImage *) imageWithTintColor:(UIColor *)tintColor image:(UIImage*)img alpha:(float)alpha;
/////图片旋转
-(UIImage *)overTurnWithImage:(UIImage*)img;
// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask   sourImage:(UIImage*)sourImage inRect:(CGRect)rect useName:(NSString*)useName;
/////根据url 获取图片
+(UIImage *) getImageFromURL:(NSString *)fileURL;
// 画文字水印
- (UIImage *) addText:(UIImage *)img text:(NSString *)mark ;

/////根据 组装图片   获取图片
+(UIImage *)loadNewImageWithDic:(NSDictionary *)dic drawImage:(UIImage*)drawImage;

@end


