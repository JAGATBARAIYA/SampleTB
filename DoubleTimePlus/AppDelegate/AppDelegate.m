//
//  AppDelegate.m
//  DoubleTimePlus
//
//  Created by Manish on 14/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "AppDelegate.h"
#import "Colors.h"
#import "Country.h"
#import "Harpy.h"
#import "RFRateMe.h"
#import "NSObject+Extras.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "SQLiteManager.h"
#import "Helper.h"
#import "Common.h"
#import "ViewController.h"
#import "AddReminderVC.h"
#import "SIAlertView.h"
#import "TKAlertCenter.h"

#define appNaming   @"Time Buddy"
#define trackID     @""

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarHidden = YES;
    
      NSLog(@"path:%@",[Helper getDocumentDirectoryPath:@"TimeZones.sqlite"]);
    
    
    [Colors sharedColors];
    [Country sharedInstance];
    [BNEasyGoogleAnalyticsTracker startWithTrackingId:trackID];
    [self.window makeKeyAndVisible];
    
    [self performBlock:^{
        [RFRateMe showRateAlert];
        [RFRateMe showRateAlertAfterTimesOpened:3];
        [RFRateMe showRateAlertAfterDays:1];
    } afterDelay:3];
    
    [[Harpy sharedInstance] setAppID:appId];
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    [[Harpy sharedInstance] setAppName:appNaming];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeSkip];
    [[Harpy sharedInstance] checkVersion];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[Harpy sharedInstance] checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Harpy sharedInstance] checkVersionDaily];
    [[Harpy sharedInstance] checkVersionWeekly];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"URL : %@",url);
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblReminder set isOn = '%@' WHERE tId = '%@'", @"0", notif.userInfo[@"tId"]];
    [[SQLiteManager singleton] executeSql:updateSQL];

    for (UILocalNotification *aNotification in aMutNotificationArray)
    {
        if ([[aNotification.userInfo valueForKey:@"tId"] isEqualToString:notif.userInfo[@"tId"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
        }
    }

    if (application.applicationState == UIApplicationStateInactive ){
        NSLog(@"app not running");
    }
    else if(application.applicationState == UIApplicationStateActive ){
        NSLog(@"App is running");
    }else if(application.applicationState == UIApplicationStateBackground){
        NSLog(@"App is running in background");
    }
}

@end
