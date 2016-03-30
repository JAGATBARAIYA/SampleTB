//
//  Common.h
//  FlipIn
//
//  Created by Marvin on 20/11/13.
//  Copyright (c) 2013 Marvin. All rights reserved.
//

#ifndef iPhoneStructure_Common_h
#define iPhoneStructure_Common_h

#define isiPhone5                               (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define kUserDirectoryPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define IS_IOS7_OR_GREATER                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ? YES : NO
#define PLAYER                                  [MPMusicPlayerController iPodMusicPlayer]

#define kRandomPasswordString                   @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

#define DegreesToRadians(degrees)               (degrees * M_PI / 180)
#define RadiansToDegrees(radians)               (radians * 180/M_PI)

#define kGeoCodingString                        @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"
#define kNotificationMessage                    @"Notification Message."
#define kRemindMeNotificationDataKey            @"kRemindMeNotificationDataKey"

#define kDateFormat                             @"yyyy-MM-dd"
#define kTimeFormat                             @"hh:mm a"

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kUserInformation                        @"UserInformation"

#define kLocationUnit                           @"LocationUnit"
#define kGuideViewDisplay                       @"GuideViewDisplay"

#define appId                                   @"943431399"
#define appNameing                              @"Weather : Universal Forecast"
#define iTunesURL                               @"itms-apps://itunes.apple.com/app/id963423076"

#define EmailSubject                            @"Weather-Universal Forecast Support"
#define EmailRecipient                          @"info@moveoapps.com"

#define IPHONE4S                                [UIScreen mainScreen].bounds.size.height==480
#define IPHONE5S                                [UIScreen mainScreen].bounds.size.height==568
#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==736
#define IPAD                                    [UIScreen mainScreen].bounds.size.height==1024

//WORLD WETHER ONLINE
#define kWorldWeatherOnlineAPIKey               @"df2d43ec5aa40b68acef3733e7a3a"
#define WEATHER_FORECAST_TABLE_NAME             @"WeatherForecast"

//Validation

#define kEnterTitle                             @"Please enter title."
#define kEnterTime                              @"Please enter time."
#define kEnterDate                              @"Please enter date."
#define kEnterProperDate                        @"You have selected past date and time, Please select proper date and time."
#define kDeleteTitle                            @"Delete"
#define kDeleteDesc                             @"Are you sure you want to delete this reminder?"

#endif
