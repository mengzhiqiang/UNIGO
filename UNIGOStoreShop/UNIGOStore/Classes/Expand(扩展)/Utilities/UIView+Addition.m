//
//  UIView+Addition.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/1.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIView+Addition.h"
#import <objc/runtime.h>

@implementation UIView (Addition)

/***************************************************************************************************/
- (CGFloat)left {
    return self.frame.origin.x;
}

/***************************************************************************************************/
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGFloat)top {
    return self.frame.origin.y;
}

/***************************************************************************************************/
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGFloat)right {
    return self.left + self.width;
}

/***************************************************************************************************/
- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGFloat)bottom {
    return self.top + self.height;
}

/***************************************************************************************************/
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGFloat)centerX {
    return self.center.x;
}

/***************************************************************************************************/
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

/***************************************************************************************************/
- (CGFloat)centerY {
    return self.center.y;
}

/***************************************************************************************************/
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

/***************************************************************************************************/
- (CGFloat)width {
    return self.frame.size.width;
}

/***************************************************************************************************/
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGFloat)height {
    return self.frame.size.height;
}

/***************************************************************************************************/
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGPoint)origin {
    return self.frame.origin;
}

/***************************************************************************************************/
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/***************************************************************************************************/
- (CGSize)size {
    return self.frame.size;
}

/***************************************************************************************************/
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/***************************************************************************************************/
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;

- (void)setMenuActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        
        if (action) {
            action();
        }
    }
}

- (void)moveOrigin:(CGPoint)origin
{
    self.origin = CGPointMake(self.frame.origin.x + origin.x, self.frame.origin.y + origin.y);
}

- (void)moveX:(CGFloat)x
{
    self.left = self.origin.x + x;
}

- (void)moveY:(CGFloat)y
{
    self.top = self.origin.y + y;
}



- (void)toLeft
{
    self.left = 0.0;
}

- (void)toTop
{
    self.top = 0.0;
}

- (void)toRight
{
    if( self.superview ){
        self.left = self.superview.width - self.width;
    }
}

- (void)toBottom
{
    if( self.superview ){
        self.top = self.superview.height - self.height;
    }
}

- (void)autoExpand
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UIView*)subviewAtIndex:(NSInteger)index
{
    return [self.subviews objectAtIndex:index];
}

- (UIView*)prevView
{
    UIView*	view = nil;
    
    //
    if( self.superview ){
        NSInteger	index = [self.superview indexOfSubview:self];
        if( 0 < index ){
            view = [self.superview subviewAtIndex:index-1];
        }
    }
    
    return view;
}

- (UIView*)nextView
{
    UIView*	view = nil;
    
    //
    if( self.superview ){
        NSInteger	index = [self.superview indexOfSubview:self];
        if( index < [self.superview allSubviewsCount]-1 ){
            view = [self.superview subviewAtIndex:index+1];
        }
    }
    
    return view;
}

- (NSInteger)indexOfSubview:(UIView*)subview
{
    return [self.subviews indexOfObject:subview];
}

- (NSInteger)allSubviewsCount
{
    return [self.subviews count];
}

- (void)removeAllSubviews
{
    NSEnumerator*	enumerator = [self.subviews reverseObjectEnumerator];
    
    UIView*	subView = nil;
    while( subView = [enumerator nextObject] ){
        [subView removeFromSuperview];
    }
}

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration
                         completion:(void (^)(BOOL))completion
{
    [self.layer removeAllAnimations];
    
    self.alpha = 0.0;
    self.hidden = NO;
    
    //
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^( BOOL finished ){
                         if( finished == NO ){
                             self.hidden = YES;
                         }
                         
                         //
                         if( completion ){
                             completion( finished );
                         }
                     }];
}

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
                          completion:(void (^)(BOOL))completion
{
    [self.layer removeAllAnimations];
    
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^( BOOL finished ){
                         self.alpha = 1.0;
                         if( finished == NO ){
                             self.hidden = NO;
                         }else{
                             self.hidden = YES;
                         }
                         
                         
                         if( completion ){
                             completion( finished );
                         }
                     }];
}

- (UIImage*)capturedImageWithSize:(CGSize)size
{
    UIImage*	image = nil;
    CGRect		rect = CGRectZero;
    
    rect.size = size;
    
    UIGraphicsBeginImageContextWithOptions( self.bounds.size, NO, 0 );
    
    CGContextRef	context = UIGraphicsGetCurrentContext();
    CGContextFillRect( context, rect );
    [self.layer renderInContext:context];
    image = [UIImage imageWithData:UIImagePNGRepresentation( UIGraphicsGetImageFromCurrentImageContext() )];
    
    UIGraphicsEndImageContext();
    
    return image;
}
// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}
#pragma  mark 设置圆角
-(void)draCirlywithColor:(UIColor*)color andRadius:(float)Radius{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = Radius;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = (color==nil?[[UIColor clearColor] CGColor ]:[color CGColor]);
    
}

//---------------------------------------------------------------------------------
#pragma mark - Override
//---------------------------------------------------------------------------------
- (BOOL)isExclusiveTouch
{
    
    return YES;
}

/**
 设置view指定位置的边框
 
 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
+ (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    
    if (borderType == UIBorderSideTypeAll) {
        originalView.layer.borderWidth = borderWidth;
        originalView.layer.borderColor = color.CGColor;
        return originalView;
    }
    
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.0f, 0.0f)];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [bezierPath moveToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    
    [originalView.layer addSublayer:shapeLayer];
    
    return originalView;
} 

@end
