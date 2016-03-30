//
//  AnalogClockView.m
//  DoubleTimePlus
//
//  Created by Manish Dudharejia on 17/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "AnalogClockView.h"
#import "Colors.h"

@implementation AnalogClockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTimezone:(NSTimeZone *)timezone{
    _timezone = timezone;
    [_clockView start:timezone.name];
}

@end
