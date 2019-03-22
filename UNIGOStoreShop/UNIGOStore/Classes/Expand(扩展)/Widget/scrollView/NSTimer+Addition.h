//
//  NSTimer+Addition.h
//  PagedScrollView
//
///  Created by teelab2 on 15-01-01.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
