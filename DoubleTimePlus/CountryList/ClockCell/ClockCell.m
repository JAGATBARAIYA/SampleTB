//
//  ClockCell.m
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 29/11/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#import "ClockCell.h"

#define kDaySmallClockImg [UIImage imageNamed:@"clock@2x"].CGImage
#define kDaySmallHourImg  [UIImage imageNamed:@"hour@2x.png"].CGImage
#define kDaySmallMinuteImg [UIImage imageNamed:@"minute@2x.png"].CGImage
#define kDaySmallSecondImg [UIImage imageNamed:@"second@2x.png"].CGImage

#define kNightSmallClockImg [UIImage imageNamed:@"nightmode_clock@2x"].CGImage
#define kNightSmallHourImg  [UIImage imageNamed:@"nightmode_hour@2x.png"].CGImage
#define kNightSmallMinuteImg [UIImage imageNamed:@"nightmode_minute@2x.png"].CGImage
#define kNightSmallSecondImg [UIImage imageNamed:@"nightmode_second@2x.png"].CGImage

@implementation ClockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) setCellValue:(Country *)country{
    
    _settings = [Helper getCustomObjectToUserDefaults:kSettingsDetails];

    _lblCountryName.text = [NSString stringWithFormat:@"%@",country.stateName];
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ %@",country.compareResult,country.timeDifference]];
    NSRange range = NSMakeRange(0, country.compareResult.length);
    [attrStr setFontName:kRobotoMediumFont size:14 range:range];
    [attrStr setTextBold:YES range:range];
    _lblTimeDiff.attributedText = attrStr;
    
    NSString *currentTime;
    if(!_settings.timeFormat){
        currentTime = [Helper getCurrentTime:country timeFormatType:k12HourTimeFormat];
        NSArray *array = [currentTime componentsSeparatedByString:@" "];
        _lblTime.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        _lblTimeFormat.text = [NSString stringWithFormat:@"%@",[[array objectAtIndex:1] lowercaseString]];
        [_lblTime setFrame:CGRectMake(207, _lblTime.frame.origin.y, _lblTime.frame.size.width, _lblTime.frame.size.height)];
    }
    else {
        currentTime = [Helper getCurrentTime:country timeFormatType:k24HourTimeFormat];
        _lblTime.text = [NSString stringWithFormat:@"%@",currentTime];
        _lblTimeFormat.text = @"";
        [_lblTime setFrame:CGRectMake(236, _lblTime.frame.origin.y, _lblTime.frame.size.width, _lblTime.frame.size.height)];
    }
    
    BOOL isNightMode = [Helper getTimeDifferenceBetweenTwoDates:currentTime];
    if(isNightMode){
        [_clockSetupView setClockBackgroundImage:kNightSmallClockImg];
        [_clockSetupView setHourHandImage:kNightSmallHourImg];
        [_clockSetupView setMinHandImage:kNightSmallMinuteImg];
        [_clockSetupView setSecHandImage:kNightSmallSecondImg];
    }
    else {
        [_clockSetupView setClockBackgroundImage:kDaySmallClockImg];
        [_clockSetupView setHourHandImage:kDaySmallHourImg];
        [_clockSetupView setMinHandImage:kDaySmallMinuteImg];
        [_clockSetupView setSecHandImage:kDaySmallSecondImg];
    }
    NSString *timeZoneVal = [NSString stringWithFormat:@"%@",country.strTimeZone];
    [_clockSetupView start:timeZoneVal];
    
    if(!_settings.clockDisplay){
        [_clockSetupView setHidden:NO];
        [_lblTime setHidden:YES];
        [_lblTimeFormat setHidden:YES];
    }
    else{
        [_clockSetupView setHidden:YES];
        [_lblTime setHidden:NO];
        [_lblTimeFormat setHidden:NO];
    }
}

@end
