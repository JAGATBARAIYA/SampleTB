//
//  ClockCell.h
//  WorldClockDemo
//
//  Created by Urmi Agnihotri on 29/11/13.
//  Copyright (c) 2013 Urmi Agnihotri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface ClockCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblCountryName;
@property (nonatomic,strong) IBOutlet UILabel *lblTimeDiff;
@property (nonatomic,strong) IBOutlet UILabel *lblTime;
@property (nonatomic,strong) IBOutlet UILabel *lblTimeFormat;

-(void) setCellValue:(Country *)country;

@end
