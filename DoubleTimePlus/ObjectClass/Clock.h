//
//  Clock.h
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 02/12/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"

@interface Clock : NSObject

@property (nonatomic,strong) NSMutableArray *selectedCountryArray;
@property (nonatomic,strong) NSMutableArray *countryListArray;

-(void) intializationAndLoadCountryData;
+(Clock *)sharedInstance;

@end
