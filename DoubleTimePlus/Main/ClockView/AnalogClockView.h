//
//  AnalogClockView.h
//  DoubleTimePlus
//
//  Created by Manish Dudharejia on 17/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockSetup.h"

@interface AnalogClockView : UIView

@property (strong, nonatomic) IBOutlet ClockSetup *clockView;
@property (strong, nonatomic) NSTimeZone *timezone;

@end
