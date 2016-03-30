//
//  ReminderListVC.m
//  TimeBuddy
//
//  Created by Manish on 29/01/16.
//  Copyright © 2016 Manish. All rights reserved.
//

#import "ReminderListVC.h"
#import "AddReminderVC.h"
#import "SQLiteManager.h"
#import "ReminderCell.h"
#import "SIAlertView.h"
#import "Common.h"
#import <objc/runtime.h>

@interface ReminderListVC ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrReminderList;

@end

@implementation ReminderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrReminderList = [[NSMutableArray alloc]init];
    _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    lpgr.delegate = self;
    [_tblView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getReminderData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Gesture Handle

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:_tblView];
    NSIndexPath *indexPath = [_tblView indexPathForRowAtPoint:p];

    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", (long)indexPath.row);

        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:kDeleteTitle andMessage:kDeleteDesc];
            alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alert) {
                                      [self deleteRow:indexPath.row];
                                  }];
            [alertView addButtonWithTitle:@"NO"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alert) {

                                  }];
            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
            [alertView show];
        }
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
            [_tblView reloadData];
            return;
        }
        NSDictionary *localDict = objc_getAssociatedObject(self, @"Reminder");
        ReminderCell *cell = (ReminderCell *)[_tblView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];

        if ([localDict[@"isOn"] isEqualToString:@"1"])
            [cell.switchOnOff setOn:YES];
        else
            [cell.switchOnOff setOn:NO];


    } else {
        NSLog(@"gestureRecognizer.state = %ld", (long)gestureRecognizer.state);
    }
}

#pragma mark - Get Reminder Data

- (void)getReminderData{
    _arrReminderList = [[NSMutableArray alloc]init];

    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * from tblReminder WHERE timezoneId = %@ order by tId",_dictTimeZone[@"tId"]];
    NSArray *data  = [[SQLiteManager singleton]executeSql:selectQuery];

    [_arrReminderList addObjectsFromArray:data];

    _lblNoRecordFound.hidden = _arrReminderList.count!=0;
    [_tblView reloadData];
}

- (void)deleteRow:(NSInteger)rowID{
    NSDictionary *dict = _arrReminderList[rowID];
    int row = [dict[@"tId"] intValue];
    [[SQLiteManager singleton] deleteRowWithId:row from:@"tblReminder"];

    NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    for (UILocalNotification *aNotification in aMutNotificationArray)
    {
        if ([[aNotification.userInfo valueForKey:@"tId"] isEqualToString:dict[@"tId"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
        }
    }

    [_arrReminderList removeObjectAtIndex:rowID];
    [_tblView reloadData];
    _lblNoRecordFound.hidden = _arrReminderList.count!=0;
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddReminderTapped:(id)sender{
    AddReminderVC *addReminderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddReminderVC"];
    addReminderVC.dictTimeZone = _dictTimeZone;
    [self.navigationController pushViewController:addReminderVC animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrReminderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ReminderCell";
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:self options:nil] objectAtIndex:0];

    NSDictionary *dict = _arrReminderList[indexPath.row];
    cell.lblTitle.text = [NSString stringWithFormat:@"Title   :  %@",dict[@"desc"]];
    cell.lblTime.text = [NSString stringWithFormat:@"Time   :  %@",dict[@"time"]];
    cell.lblDate.text = [NSString stringWithFormat:@"Date   :  %@",dict[@"date"]];

    if ([dict[@"isOn"] isEqualToString:@"1"])
        [cell.switchOnOff setOn:YES];
    else
        [cell.switchOnOff setOn:NO];

    [cell.switchOnOff addTarget:self action:@selector(setNotificationOnOff:) forControlEvents:UIControlEventValueChanged];

    objc_setAssociatedObject(self, @"Reminder", dict, OBJC_ASSOCIATION_RETAIN);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSDictionary *dict = _arrReminderList[indexPath.row];

    AddReminderVC *addReminderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddReminderVC"];
    addReminderVC.dict = dict;
    addReminderVC.dictTimeZone = _dictTimeZone;
    [self.navigationController pushViewController:addReminderVC animated:YES];
}

#pragma mark - Set Local Notification

- (void)setNotificationOnOff:(UISwitch *)sender
{
    BOOL state = [sender isOn];

    NSDictionary *localDict = objc_getAssociatedObject(self, @"Reminder");

    if (state)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblReminder set isOn = '%@' WHERE tId = '%@'", @"1", localDict[@"tId"]];
        [[SQLiteManager singleton] executeSql:updateSQL];

        NSString *strDateTime = [localDict[@"date"] stringByAppendingFormat:@" %@", localDict[@"time"]];
        NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
        [dtFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
        [dtFormat setTimeZone:[NSTimeZone timeZoneWithName:_dictTimeZone[@"timeZone"]]];
        NSDate *aDate = [dtFormat dateFromString:strDateTime];

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = localDict[@"desc"];
        localNotification.soundName = UILocalNotificationDefaultSoundName;

        [localNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",localDict[@"tId"]], @"tId", _dictTimeZone[@"timeZone"], @"timeZone", nil]];
        localNotification.fireDate = aDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else
    {
        NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblReminder set isOn = '%@' WHERE tId = '%@'", @"0", localDict[@"tId"]];
        [[SQLiteManager singleton] executeSql:updateSQL];

        for (UILocalNotification *aNotification in aMutNotificationArray)
        {
            if ([[aNotification.userInfo valueForKey:@"tId"] isEqualToString:localDict[@"tId"]])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
            }
        }
    }
}

@end
