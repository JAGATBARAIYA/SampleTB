//
//  InterfaceController.m
//  TimeBuddy WatchKit Extension
//
//  Created by E2M164 on 04/05/15.
//  Copyright (c) 2015 Manish. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnTop;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnMiddle;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnBottom;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTimeZoneName;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupDigital;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupAnaloug;

@property (strong, nonatomic) NSTimer *timerGlobal;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
       [self setTimezone:nil];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)updateTimer:(NSTimer*)timer1{
    
    NSTimeZone *timezone=timer1.userInfo;
    [_btnTop setTitle:[[self getStringFromDate:[NSDate date] timezone:timezone withFormat:@"hh:mm:ss a"] uppercaseString]];
    [_btnMiddle setTitle:[[self getStringFromDate:[NSDate date] timezone:timezone  withFormat:@"HH:mm:ss"] uppercaseString]];
    [_btnBottom setTitle:[[self getStringFromDate:[NSDate date] timezone:timezone  withFormat:@"HHmm:ss"] uppercaseString]];
}

-(NSTimer*)setTimezone:(NSDictionary*)dict {
   // NSTimeZone *tt=[NSTimeZone timeZoneWithName:dict[@"timeZone"]];
    //_analogClockView.timezone=tt;
    _lblTimeZoneName.text= @"city name";  //.dict[@"name"];
    
    if (![_timerGlobal isValid]) {
        _timerGlobal = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(updateTimer:)
                                                      userInfo:[NSTimeZone localTimeZone]
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

-(IBAction)btnAnalougTapped:(id)sender {
    
    [_groupDigital setHidden:YES];
    [_groupAnaloug setHidden:NO];
}

-(IBAction)btnBackTapped:(id)sender {
    [_groupDigital setHidden:NO];
    [_groupAnaloug setHidden:YES];
}

@end



