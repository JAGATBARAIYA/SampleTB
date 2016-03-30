//
//  Country.h
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 29/11/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic,strong) NSString *strCountryName;
@property (nonatomic,strong) NSString  *strStateName;
@property (nonatomic,strong) NSTimeZone *timezone;

@property (strong, nonatomic) NSMutableArray *arrCountryList;

+(id)sharedInstance;

@end
