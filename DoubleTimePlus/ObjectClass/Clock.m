//
//  Clock.m
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 02/12/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#import "Clock.h"

@implementation Clock

+(Clock *)sharedInstance{
    static Clock *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Clock alloc] init];
        [sharedInstance intializationAndLoadCountryData];
    });
    return sharedInstance;
}

-(void) intializationAndLoadCountryData {
    _countryListArray = [[NSMutableArray alloc] init];
    NSArray *timezones = [NSTimeZone knownTimeZoneNames];
    [timezones enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Country *country = [[Country alloc] init];
        NSArray *array = [timezones[idx] componentsSeparatedByString:@"/"];
        if([array count] >= 2){
            if([array count] <= 2){
                country.countryName = [array objectAtIndex:0];
                country.stateName = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            }
            else{
                country.countryName = [array objectAtIndex:0];
                country.stateName = [array objectAtIndex:2];
            }
            
            if([country.countryName isEqualToString:@"America"])
                country.countryName = @"U.S.A";
        }
    }];
    
    /*
    for(int i=0;i<[[NSTimeZone knownTimeZoneNames] count];i++){
        NSArray *array = [[[NSTimeZone knownTimeZoneNames] objectAtIndex:i] componentsSeparatedByString:@"/"];
        if([array count] >= 2){
            if([array count] <= 2){
                objCountry.countryName = [array objectAtIndex:0];
                objCountry.stateName = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            }
            else{
                objCountry.countryName = [array objectAtIndex:0];
                objCountry.stateName = [array objectAtIndex:2];
            }
            
            if([objCountry.countryName isEqualToString:@"America"])
                objCountry.countryName = @"U.S.A";
            
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[[NSTimeZone knownTimeZoneNames] objectAtIndex:i]];
            NSString *convertTimeDiff = [self convertTime:timeZone];
            objCountry.countryTimeZone = timeZone;
            NSArray *resultArray = [convertTimeDiff componentsSeparatedByString:@"&&"];
            objCountry.timeDifference = [resultArray objectAtIndex:0];
            objCountry.strTimeZone = [[NSTimeZone knownTimeZoneNames] objectAtIndex:i];
            objCountry.compareResult = [resultArray objectAtIndex:1];
            [_countryListArray addObject:objCountry];
        }
    }
    */
}

/*
-(NSString *) convertTime:(NSTimeZone *)timeZone{
    NSString *resultTimeDiff,*compareResultStr;

    NSDate *now = [NSDate date];
    NSDateFormatter *dateformatetr1 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateformatetr2 = [[NSDateFormatter alloc] init];
    
    dateformatetr1.dateStyle = dateformatetr2.dateStyle = NSDateFormatterShortStyle;
    dateformatetr1.timeStyle = dateformatetr2.timeStyle = NSDateFormatterShortStyle;

    dateformatetr1.timeZone = [NSTimeZone localTimeZone];
    dateformatetr2.timeZone = timeZone;
    
    NSString *strDate1 = [dateformatetr1 stringFromDate:now];
    NSDate *date1 = [dateformatetr1 dateFromString:strDate1];

    NSString *strDate2 = [dateformatetr2 stringFromDate:now];
    NSDate *date2 = [dateformatetr1 dateFromString:strDate2];
    
    NSDate *dateOne = [self convertDate:[NSDate date] timeZone:nil dateStyle:kCFDateFormatterShortStyle timeStyle:kCFDateFormatterNoStyle];
    NSDate *dateSecond = [self convertDate:date2 timeZone:nil dateStyle:kCFDateFormatterShortStyle timeStyle:kCFDateFormatterNoStyle];
    
    switch ([dateOne compare:dateSecond]){
        case NSOrderedAscending:
            compareResultStr = @"Yesterday,";
            break;
        case NSOrderedSame:
            compareResultStr = @"Today,";
            break;
        case NSOrderedDescending:
            compareResultStr = @"Tommorrow,";
            break;
    }
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    if([conversionInfo hour] <= 0){
        if([conversionInfo hour] == 0 && [conversionInfo minute] == 0)
            resultTimeDiff = [NSString stringWithFormat:@"Now"];
        else {
            if([conversionInfo hour] == 0)
                resultTimeDiff = [NSString stringWithFormat:@"%d minutes behind",abs([conversionInfo minute])];
            else if([conversionInfo minute] == 0)
                resultTimeDiff = [NSString stringWithFormat:@"%i hours behind",abs([conversionInfo hour])];
            else
                resultTimeDiff = [NSString stringWithFormat:@"%ih %dm behind",abs([conversionInfo hour]),abs([conversionInfo minute])];
        }
    } else{
        if([conversionInfo hour] == 0)
            resultTimeDiff = [NSString stringWithFormat:@"%d minutes ahead",abs([conversionInfo minute])];
        else if([conversionInfo minute] == 0)
            resultTimeDiff = [NSString stringWithFormat:@"%i hours ahead",abs([conversionInfo hour])];
        else
            resultTimeDiff = [NSString stringWithFormat:@"%ih %dm ahead",abs([conversionInfo hour]),abs([conversionInfo minute])];
    }
    
    resultTimeDiff = [NSString stringWithFormat:@"%@&&%@",resultTimeDiff,compareResultStr];
    
    return resultTimeDiff;
}

-(NSDate *) convertDate:(NSDate *)compareDate timeZone:(NSTimeZone *)kTimeZone dateStyle:(int )kDateStyle timeStyle:(int )kTimeStyle{
    NSDate *resultDate;
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    df1.timeZone = kTimeZone;
    df1.dateStyle = kDateStyle;
    df1.timeStyle = kTimeStyle;
    NSString *S2 = [df1 stringFromDate:compareDate];
    resultDate = [df1 dateFromString:S2];
    
    return resultDate;
}
*/

@end
