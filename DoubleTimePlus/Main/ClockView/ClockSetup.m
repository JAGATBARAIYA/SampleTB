//
//  ClockSetup.m
//  WorldClock
//
//  Created by Eric Prewitt on 10/8/13.
//  Copyright (c) 2013 Eric Prewitt. All rights reserved.
//

#define kDayClockImg [UIImage imageNamed:@"analog_clock"].CGImage
#define kDayHourImg  [UIImage imageNamed:@"hour_line"].CGImage
#define kDayMinuteImg [UIImage imageNamed:@"minute_line"].CGImage
#define kDaySecondImg [UIImage imageNamed:@"second_line"].CGImage

#import "ClockSetup.h"

@implementation ClockSetup

- (void)start:(NSString*)timeValue{
    _timeZonevalue = timeValue;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
}

- (void)stop{
	[timer invalidate];
	timer = nil;
}

float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

- (void) updateClock:(NSTimer *)theTimer{
    NSDate *currentTime = [NSDate date];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithName:_timeZonevalue];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:[NSDate date]];
    gmtOffset = gmtOffset + 1800;
    
    NSDate *newYorkTime = [currentTime dateByAddingTimeInterval:gmtOffset];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:newYorkTime];
	NSInteger seconds = [dateComponents second];
	NSInteger minutes = [dateComponents minute];
	NSInteger hours = [dateComponents hour];
    
	//NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);
	if (hours > 12) hours -=12; //PM
    
	//set angles for each of the hands
	CGFloat secAngle = Degrees2Radians(seconds/60.0*360);
	CGFloat minAngle = Degrees2Radians(minutes/60.0*360);
	CGFloat hourAngle = Degrees2Radians(hours/12.0*360) + minAngle/12.0;
	
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
    //	secHand.transform = CATransform3DMakeRotation (secAngle+M_PI, 0, 0, 1);
    secHand.transform = CATransform3DMakeRotation (secAngle, 0, 0, 1);
	minHand.transform = CATransform3DMakeRotation (minAngle, 0, 0, 1);
	hourHand.transform = CATransform3DMakeRotation (hourAngle+M_PI, 0, 0, 1);
}

-(void)defaultSetup{
    containerLayer = [CALayer layer];
    hourHand = [CALayer layer];
    minHand = [CALayer layer];
    secHand = [CALayer layer];
    
    //default appearance
//    [self setClockBackgroundImage:NULL];
//    [self setHourHandImage:NULL];
//    [self setMinHandImage:NULL];
//    [self setSecHandImage:NULL];
    
    [self setClockBackgroundImage:kDayClockImg];
    [self setHourHandImage:kDayHourImg];
    [self setMinHandImage:kDayMinuteImg];
    [self setSecHandImage:kDaySecondImg];
    
    //add all created sublayers
    [containerLayer addSublayer:hourHand];
    [containerLayer addSublayer:minHand];
    [containerLayer addSublayer:secHand];
    [self.layer addSublayer:containerLayer];
}

//customize appearence
- (void)setHourHandImage:(CGImageRef)image{
    hourHand.backgroundColor = [UIColor clearColor].CGColor;
    hourHand.cornerRadius = 0.0;
    hourHand.borderWidth = 0.0;
    
	hourHand.contents = (__bridge id)image;
}

- (void)setMinHandImage:(CGImageRef)image{
    minHand.backgroundColor = [UIColor clearColor].CGColor;
    minHand.borderWidth = 0.0;
    minHand.cornerRadius = 0.0;
    
	minHand.contents = (__bridge id)image;
}

- (void)setSecHandImage:(CGImageRef)image{
    secHand.backgroundColor = [UIColor clearColor].CGColor;
    secHand.borderColor = [UIColor clearColor].CGColor;
    secHand.borderWidth = 0.0;
    secHand.cornerRadius = 0.0;
	secHand.contents = (__bridge id)image;
}

- (void)setClockBackgroundImage:(CGImageRef)image{
    containerLayer.borderColor = [UIColor clearColor].CGColor;
    containerLayer.borderWidth = 0.0;
    containerLayer.cornerRadius = 0.0;
	containerLayer.contents = (__bridge id)image;
}

#pragma mark - Private Methods

//Default sizes of hands:
//in percentage (0.0 - 1.0)
#define HOURS_HAND_LENGTH 0.65
#define MIN_HAND_LENGTH 0.75
#define SEC_HAND_LENGTH 0.8
//in pixels
#define HOURS_HAND_WIDTH 10
#define MIN_HAND_WIDTH 8
#define SEC_HAND_WIDTH 4

- (void) layoutSubviews{
	[super layoutSubviews];
    
    
    CGFloat widthContainer=158;   //self.frame.size.width
    CGFloat heightContainer=158;    //self.frame.size.height
    
    
    containerLayer.frame = CGRectMake(0, 0, widthContainer, heightContainer);
   // NSLog(@"%f,,,,%f:",containerLayer.frame.size.width,containerLayer.frame.size.height);
	float length = MIN(self.frame.size.width, self.frame.size.height)/2;
	CGPoint c = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	hourHand.position = minHand.position = secHand.position = c;
    
	CGFloat w, h;
	CGFloat scale = 1;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		scale = [UIScreen mainScreen].scale;
	}
	
	if (hourHand.contents == NULL){
		w = HOURS_HAND_WIDTH;
        h = length;//*HOURS_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)hourHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)hourHand.contents)/scale;
	}
	hourHand.bounds = CGRectMake(0,0,w,h);
	
	if (minHand.contents == NULL){
		w = MIN_HAND_WIDTH;
        h = length;//*MIN_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)minHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)minHand.contents)/scale;
	}
	minHand.bounds = CGRectMake(0,0,w,h);
	
	if (secHand.contents == NULL){
		w = SEC_HAND_WIDTH;
        h = length;//*SEC_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((CGImageRef)secHand.contents)/scale;
		h = CGImageGetHeight((CGImageRef)secHand.contents)/scale;
	}
	secHand.bounds = CGRectMake(0,0,w,h);
    
	hourHand.anchorPoint = CGPointMake(0.5,0.5);
	minHand.anchorPoint = CGPointMake(0.5, 0.5);
	secHand.anchorPoint = CGPointMake(0.5,0.5);
	containerLayer.anchorPoint = CGPointMake(0.5,0.5);
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self defaultSetup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self defaultSetup];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
