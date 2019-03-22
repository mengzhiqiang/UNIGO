//
//  CustomCoreTextLabel.m
//  TextCoreText
//
//  Created by mzq on 15/6/4.
//  Copyright (c) 2015年 mzq. All rights reserved.
//

#define ZERORANGE ((NSRange){0, 0})

#import "Define.h"
#import "ExtendClass.h"
#import "CustomCoreTextLabel.h"
#import <CoreText/CoreText.h>

@implementation CustomCoreTextLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.backgroundColor=[UIColor clearColor];
    if ([_string length]<1) {
        return;
    }
    [self characterAttribute:_string withCode:_code];
}


-(void)characterAttribute:(NSString*)str
{
    _string=str;
    [self drawRect:self.frame];
}

-(void)characterAttribute
{
    NSDictionary  *dic_darw=@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:12]};
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:_string attributes:dic_darw];
    [mabstring beginEditing];
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTCharacterShapeAttributeName value:(id)num range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体属性
     CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 40, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体简隔 eg:test
     long number = 10;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(10, 4)];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTLigatureAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     */
    /*
     //设置字体颜色
     [mabstring addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 9)];
     */
    /*
     //设置字体颜色为前影色
     CFBooleanRef flag = kCFBooleanTrue;
     [mabstring addAttribute:(id)kCTForegroundColorFromContextAttributeName value:(id)flag range:NSMakeRange(5, 10)];
     */
    
    /*
     //设置空心字
     long number = 2;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTStrokeWidthAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     
     //设置空心字颜色
     [mabstring addAttribute:(id)kCTStrokeColorAttributeName value:(id)[UIColor greenColor].CGColor range:NSMakeRange(0, [str length])];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTSuperscriptAttributeName value:(id)num range:NSMakeRange(3, 1)];
     */
    
    /*
     //设置斜体字
     CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 14, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    
    /*
     //下划线
     [mabstring addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, 4)];
     //下划线颜色
     [mabstring addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 4)];
     */
    
    //对同一段字体进行多属性设置
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[[UIColor redColor] colorWithHexString:greenONE].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //下划线
    //    [attributes setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    
    //    [mabstring addAttributes:attributes range:NSMakeRange(0, 4)];
    //    [mabstring addAttributes:attributes range:NSMakeRange(20, 4)];
    NSArray *array = [_string componentsSeparatedByString:@"#"];
    if (!_string_array) {
        _string_array=[[NSArray alloc]init];
        _rang_array=[[NSMutableArray alloc]init];
    }
    else {
        
        [_rang_array removeAllObjects];
        _rang_array=[[NSMutableArray alloc]init];
    }
    _string_array=array;
    for (int i=0; i<[array count]-1; i++) {
        
        if (i%2==1) {
            continue;
        }
    
        if (i+1>=[array count]-1) {  ///多一个#报错
            continue;
        }

        NSString *str2=[array objectAtIndex:i+1];
        int leg=0;
        for (int j=0; j<=i; j++) {
            
            if (j==i) {
                leg=leg+(int)[[array objectAtIndex:j]length];
                break;
            }
            leg=leg+(int)[[array objectAtIndex:j]length]+1;
        }
        
        if (i==0) {
            leg=(int)[[array objectAtIndex:0] length];
        }
        
        NSRange rang=NSMakeRange(leg, [str2 length]+2);
        [mabstring addAttributes:attributes range:rang];
        NSValue *rng = [NSValue valueWithRange:rang];
        [_rang_array addObject:rng];
        
    }
    
    [mabstring endEditing];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width-0 , self.bounds.size.height-0));
    
    _frame_ref = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    
    
    //x，y轴方向移动
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    CTFrameDraw(_frame_ref,context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
}


-(void)characterAttribute:(NSString *)str withCode:(NSString *)code{
    
    
    if ([_code length]<1) {
        _string=str;
        _code=code;
        [self drawRect:self.frame];
        return;
    }
    
    if (!_string_array) {
        _string_array=[[NSArray alloc]init];
        _rang_array=[[NSMutableArray alloc]init];
    }else{
        
        [_rang_array removeAllObjects];
        _rang_array=[[NSMutableArray alloc]init];
        
    }
    NSArray *arr=@[code];
    _string_array = arr;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter; ///设置对齐方式
    
    NSDictionary  *dic_darw=@{NSForegroundColorAttributeName: [UIColor grayColor] ,NSFontAttributeName: [UIFont systemFontOfSize:(iPhone5||isPAD_or_IPONE4?10:12)],NSParagraphStyleAttributeName:paragraph};

    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:_string attributes:dic_darw];
    [mabstring beginEditing];
    
    //对同一段字体进行多属性设置
    //红色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[[UIColor redColor] colorWithHexString:greenONE].CGColor forKey:(id)kCTForegroundColorAttributeName];
    
    int leg=(int)[str length]-(int)[code length];
    
    NSRange rang=NSMakeRange(leg, [code length]);
    [mabstring addAttributes:attributes range:rang];
    NSValue *rng = [NSValue valueWithRange:rang];
    [_rang_array addObject:rng];
    
    [mabstring endEditing];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width-0 , self.bounds.size.height-0));
    
    _frame_ref = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    
    
    //x，y轴方向移动
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    CTFrameDraw(_frame_ref,context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
}

/// 接受触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    location.y=location.y;
    location.x=location.x+5;
    //获取每一行
    CFArrayRef lines = CTFrameGetLines(_frame_ref);
    if (lines==nil || !lines) {
        return;
    }
    CGPoint origins[CFArrayGetCount(lines)];
    
    //获取每行的原点坐标
    CTFrameGetLineOrigins(_frame_ref, CFRangeMake(0, 0), origins);
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    for (int i= 0; i < CFArrayGetCount(lines); i++) {
        CGPoint origin = origins[i];
        CGPathRef path = CTFrameGetPath(_frame_ref);
        //获取整个CTFrame的大小
        CGRect rect = CGPathGetBoundingBox(path);
        
        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
        
        //判断点击的位置处于那一行范围内
        if ((location.y <= y) && (location.x >= origin.x)) {
            line = CFArrayGetValueAtIndex(lines, i);
            lineOrigin = origin;
            break;
        }
    }
    location.x-=lineOrigin.x;
    CFIndex index=CTLineGetStringIndexForPosition(line, location);

    int row=0;
    for (int i=0; i<[_rang_array count]; i++) {
        NSRange rag=[[_rang_array objectAtIndex:i] rangeValue];
        if (rag.location<index && (rag.length+rag.location)>=index) {
            row=i*2+1;
            break;
        }
        else if (rag.location>=index) {
            row=i*2;
            break;
        }
    }
    
    if (row%2==0 ) {
        return;
    }
    else if ([_code length]>1) {
        if (row==1) {
            [_Delagate pushTextOfMark:_code];
            
        }
        return;
    }
    NSString *str=[_string_array objectAtIndex:row];
    [_Delagate pushTextOfMark:str];

    return;
}

@end
