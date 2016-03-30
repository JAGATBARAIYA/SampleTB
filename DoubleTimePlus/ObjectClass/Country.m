//
//  Country.m
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 29/11/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#define kCountryName @"CountryName"
#define kStateName @"StateName"
#define kStrTimeZone @"StrTimeZone"
#define kCountryTimeZone @"CountryTimeZone"
#define kTimeDifference @"TimeDifference"
#define kCompareResult @"CompareResult"

#import "Country.h"

@implementation Country

+(id)sharedInstance{
    static Country *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initializeData];
    });
    return sharedInstance;
}

#pragma mark - Initialize Data

- (void)initializeData{
    NSArray *timezones = [NSTimeZone knownTimeZoneNames];
    NSLog(@"Timezons = %lu",(unsigned long)timezones.count);
    
    _arrCountryList = [[NSMutableArray alloc] init];
    [timezones enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Country *country = [[Country alloc] init];
        NSArray *array = [timezones[idx] componentsSeparatedByString:@"/"];
        if([array count] >= 2){
            if([array count] <= 2){
                country.strCountryName = [array objectAtIndex:0];
                country.strStateName = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            } else{
                country.strCountryName = [array objectAtIndex:0];
                country.strStateName = [array objectAtIndex:2];
            }
            if([country.strCountryName isEqualToString:@"America"])
                country.strCountryName = @"USA";
            
            country.timezone = [NSTimeZone timeZoneWithName:timezones[idx]];
            [_arrCountryList addObject:country];
        }
    }];
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:self.strCountryName forKey:kCountryName];
    [encoder encodeObject:self.strStateName forKey:kStateName];
    [encoder encodeObject:self.timezone forKey:kStrTimeZone];    
}

- (id)initWithCoder:(NSCoder *)decoder{
	self = [super init];
	if( self != nil ){
		self.strCountryName = [decoder decodeObjectForKey:kCountryName];
		self.strStateName = [decoder decodeObjectForKey:kStateName];
        self.timezone = [decoder decodeObjectForKey:kStrTimeZone];
	}
	return self;
}

@end
