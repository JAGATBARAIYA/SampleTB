//
//  ClockSetup.h
//  WorldClock
//
//  Created by Eric Prewitt on 10/8/13.
//  Copyright (c) 2013 Eric Prewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ClockSetup : UIView {

    CALayer *containerLayer;
    CALayer *hourHand;
    CALayer *minHand;
    CALayer *secHand;
    NSTimer *timer;
}

@property (nonatomic,strong) NSString *timeZonevalue;

//basic methods
- (void)start:(NSString*)timeValue;
- (void)stop;

//customize appearence
- (void)setHourHandImage:(CGImageRef)image;
- (void)setMinHandImage:(CGImageRef)image;
- (void)setSecHandImage:(CGImageRef)image;
- (void)setClockBackgroundImage:(CGImageRef)image;
@end