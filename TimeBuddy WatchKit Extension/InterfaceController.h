//
//  InterfaceController.h
//  TimeBuddy WatchKit Extension
//
//  Created by E2M164 on 04/05/15.
//  Copyright (c) 2015 Manish. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController {
//    CALayer *containerLayer;
//    CALayer *hourHand;
//    CALayer *minHand;
//    CALayer *secHand;
    NSTimer *timer;
}

@property (nonatomic,strong) NSString *timeZonevalue;
@end
