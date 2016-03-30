//
//  ReminderCell.h
//  TimeBuddy
//
//  Created by Manish on 30/01/16.
//  Copyright © 2016 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UISwitch *switchOnOff;

@end
