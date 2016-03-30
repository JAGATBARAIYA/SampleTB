//
//  AddReminderVC.m
//  TimeBuddy
//
//  Created by Manish on 29/01/16.
//  Copyright © 2016 Manish. All rights reserved.
//

#import "AddReminderVC.h"
#import "MSTextField.h"
#import "Common.h"
#import "TKAlertCenter.h"
#import "SQLiteManager.h"
#import "NSString+extras.h"
#import "Helper.h"

@interface AddReminderVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtDate;
@property (strong, nonatomic) IBOutlet MSTextField *txtTime;
@property (strong, nonatomic) IBOutlet MSTextField *txtDesc;

@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIButton *btnTime;

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation AddReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_dict) {
        _lblTitle.text = @"Update Reminder";
        _txtTime.text = _dict[@"time"];
        _txtDate.text = _dict[@"date"];
        _txtDesc.text = _dict[@"desc"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDateTapped:(id)sender{
    _btnDate.selected = YES;
    _btnTime.selected = NO;
    [self showDatePickerView];
}

- (IBAction)btnTimeTapped:(id)sender{
    _btnTime.selected = YES;
    _btnDate.selected = NO;
    [self showDatePickerView];
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:_dictTimeZone[@"timeZone"]]];

    if (_datePicker.datePickerMode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:kDateFormat];
    }else if (_datePicker.datePickerMode == UIDatePickerModeTime){
        [dateFormatter setDateFormat:kTimeFormat];
    }

    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    if (_btnDate.selected) {
        _txtDate.text = [value uppercaseString];
    }else if (_btnTime.selected){
        _txtTime.text = [value uppercaseString];
    }
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (IBAction)btnSaveTapped:(id)sender{
    if ([self isValidDetails]) {
        if (_dict) {
            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblReminder set date = '%@',time = '%@',desc = '%@', timezoneId = '%@', isOn = '%@' WHERE tId = %@",_txtDate.text,_txtTime.text,_txtDesc.text,_dictTimeZone[@"tId"], @"1", _dict[@"tId"]];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Reminder Updated Successfully." image:[UIImage imageNamed:@"right"]];
            [self setLocalNotification:[_dict[@"tId"]integerValue]];
            [self clearFields];
            [self btnBackTapped:nil];
        }else{
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblReminder(time,date,desc,timezoneId,isOn) VALUES ('%@','%@','%@','%@','%@')",_txtTime.text,_txtDate.text,_txtDesc.text,_dictTimeZone[@"tId"],@"1"];
            [[SQLiteManager singleton] executeSql:insertSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Reminder Added Successfully." image:[UIImage imageNamed:@"right"]];
            NSArray *arrData = [[SQLiteManager singleton] executeSql:@"SELECT * from tblReminder"];
            NSDictionary *dictionary = [arrData lastObject];
            [self setLocalNotification:[dictionary[@"tId"] integerValue]];
            [self clearFields];
            [self btnBackTapped:nil];
        }
    }
}

#pragma mark - Show Date Picker

- (void)showDatePickerView{
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    [_txtDesc resignFirstResponder];
    [_datePicker setMinimumDate: [NSDate date]];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:_dictTimeZone[@"timeZone"]]];
    [self.view bringSubviewToFront:_datePicker];

    if (_btnDate.selected) {
        _lblPicker.text = @"SELECT DATE";
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }else if (_btnTime.selected){
        _lblPicker.text = @"SELECT TIME";
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
}

#pragma mark - Local Notification

- (void)setLocalNotification:(NSInteger)remId
{
    if (_dict) {
        NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

        for (UILocalNotification *aNotification in aMutNotificationArray)
        {
            if ([[aNotification.userInfo valueForKey:@"tId"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)remId]])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
            }
        }
    }

    NSString *strDateTime = [_txtDate.text stringByAppendingFormat:@" %@", _txtTime.text];
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithName:_dictTimeZone[@"timeZone"]]];
    NSDate *aDate = [dtFormat dateFromString:strDateTime];

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = _txtDesc.text;
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    [localNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)remId], @"tId", _dictTimeZone[@"timeZone"], @"timeZone", nil]];
    localNotification.fireDate = aDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    NSLog(@"Add Reminder Array :: %@",aMutNotificationArray);
    NSLog(@"Add Array Count :: %ld",aMutNotificationArray.count);

}

#pragma mark - TextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self btnCloseTapped:nil];
}

#pragma mark - Validation

- (BOOL)isValidDetails{
    if ([_txtDesc.text isEqualToString:@""]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kEnterTitle image:kErrorImage];
        return NO;
    }else if ([_txtTime.text isEqualToString:@""]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kEnterTime image:kErrorImage];
        return NO;
    }else if ([_txtDate.text isEqualToString:@""]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kEnterDate image:kErrorImage];
        return NO;
    }

    NSString *strDateTime = [_txtDate.text stringByAppendingFormat:@" %@", _txtTime.text];
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithName:_dictTimeZone[@"timeZone"]]];
    NSDate *aDate = [dtFormat dateFromString:strDateTime];

    NSString *strFromDate = [dtFormat stringFromDate:aDate];
    NSString *strCurrentDate = [dtFormat stringFromDate:[NSDate date]];

    if ([strCurrentDate isGreaterToDate:strFromDate]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kEnterProperDate image:kErrorImage];
        return NO;
    }

    return YES;
}

- (void)clearFields{
    _txtTime.text = @"";
    _txtDate.text = @"";
}

@end
