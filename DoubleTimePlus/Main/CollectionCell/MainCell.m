//
//  mainCollectionViewCell.m
//  TimeBuddy
//
//  Created by E2M164 on 20/04/15.
//  Copyright (c) 2015 Manish. All rights reserved.
//

#import "MainCell.h"
#import "Country.h"
#import "Helper.h"
#import "Common.h"

#define HORIZONTAL_SPACING  2
#define VERTICAL_SPACING    35
#define Y_OF_CLOCKVIEW  70

@implementation MainCell

- (void)awakeFromNib {
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=7.0;

    _analogClockView = [[NSBundle mainBundle] loadNibNamed:@"AnalogClockView" owner:self options:nil][0];
}

-(void)setDigitalView:(NSDictionary *)dict {
    self.viewAnaloug.backgroundColor = self.backgroundColor=[self randomColor];
    [self setTime:dict];

    _viewAnaloug.alpha=0;
    _viewDigital.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        _viewDigital.alpha=1;
    }];
}

-(void)setAnalougView:(NSDictionary*)dict{
    self.viewAnaloug.backgroundColor = self.backgroundColor=[self randomColor];
    [self setTime:dict];
  
    _viewDigital.alpha=0;
    _viewAnaloug.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        _viewAnaloug.alpha=1;
    }];
}

- (void)setTime:(NSDictionary*)dict {
    [_timerGlobal invalidate];
    [_analogClockView removeFromSuperview];
  
    [self setTimezone:dict];
    
    if (IPHONE4S) {
        _lblTimezoneName.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        _lblTopTime.font=[UIFont fontWithName:@"Roboto-Light" size:22];
        _lblMiddleTime.font=[UIFont fontWithName:@"Roboto-Light" size:22];
        _lblBottomTime.font=[UIFont fontWithName:@"Roboto-Light" size:22];
    } else if (IPHONE5S) {
        _lblTimezoneName.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
        _lblTopTime.font=[UIFont fontWithName:@"Roboto-Light" size:24];
        _lblMiddleTime.font=[UIFont fontWithName:@"Roboto-Light" size:24];
        _lblBottomTime.font=[UIFont fontWithName:@"Roboto-Light" size:24];
    }else if (IPHONE6) {
        _lblTimezoneName.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        _lblTopTime.font=[UIFont fontWithName:@"Roboto-Light" size:27];
        _lblMiddleTime.font=[UIFont fontWithName:@"Roboto-Light" size:27];
        _lblBottomTime.font=[UIFont fontWithName:@"Roboto-Light" size:27];
    }else if (IPHONE6PLUS) {
        _lblTimezoneName.font=[UIFont fontWithName:@"Roboto-Regular" size:19];
        _lblTopTime.font=[UIFont fontWithName:@"Roboto-Light" size:29];
        _lblMiddleTime.font=[UIFont fontWithName:@"Roboto-Light" size:29];
        _lblBottomTime.font=[UIFont fontWithName:@"Roboto-Light" size:29];
    }
    
    [_viewAnaloug addSubview:_analogClockView];
}

- (void)updateTime:(NSTimer*)timer{
    NSTimeZone *timezone=timer.userInfo;
    _lblTopTime.text=[[self getStringFromDate:[NSDate date] timezone:timezone withFormat:@"hh:mm:ss a"] uppercaseString];
    _lblMiddleTime.text = [[self getStringFromDate:[NSDate date] timezone:timezone  withFormat:@"HH:mm:ss"] uppercaseString];
    _lblBottomTime.text = [[self getStringFromDate:[NSDate date] timezone:timezone  withFormat:@"HHmm:ss"] uppercaseString];
}

-(NSTimer*)setTimezone:(NSDictionary*)dict {
    NSTimeZone *tt=[NSTimeZone timeZoneWithName:dict[@"timeZone"]];
    _analogClockView.timezone=tt;
    
    _lblTimezoneName.text=dict[@"name"];
 
    if (![_timerGlobal isValid]) {
        _timerGlobal = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:tt
                                                 repeats:YES];
    }else {
      [_timerGlobal invalidate];
    }
   return nil;
}

-(NSString*)getStringFromDate:(NSDate*)pDate timezone:(NSTimeZone*)timezone withFormat:(NSString*)pDateFormat{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    dtFormatter.timeZone = timezone;
    [dtFormatter setDateFormat:pDateFormat];
    return [dtFormatter stringFromDate:pDate];
}

- (void)startQuivering{
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-4) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.2;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layer = self.btnDelete.layer;
    [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering{
    CALayer *layer = self.btnDelete.layer;
    [layer removeAnimationForKey:@"quivering"];
}

- (UIColor*) randomColor{
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
