//
//  Helper.m
//  DoubleTimePlus
//
//  Created by Manish Dudharejia on 17/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "Helper.h"
#import "Country.h"
#import "Common.h"
#import "SIAlertView.h"

@implementation Helper

#pragma mark - NSUserDefaults

+ (void)siAlertView:(NSString*)title msg:(NSString*)msg{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:msg];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

+(void)addToNSUserDefaults:(id)pObject forKey:(NSString*)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:pObject forKey:pForKey];
    [defaults synchronize];
}

+(void)addBoolNSUserDefaults:(BOOL)yesNo forKey:(NSString*)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setBool:yesNo forKey:pForKey];
    [defaults synchronize];
}

+(BOOL)getBoolFromNSUserDefaults:(NSString*)pForKey{
    BOOL pReturnObject;
    pReturnObject =[[NSUserDefaults standardUserDefaults] boolForKey:pForKey];
    return pReturnObject;
}

+(void)removeFromNSUserDefaults:(NSString*)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:pForKey];
    [defaults synchronize];
}

+(id)getFromNSUserDefaults:(NSString*)pForKey{
    id pReturnObject;
    NSUserDefaults *defaults =[[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.timebuddy"];
    pReturnObject = [defaults objectForKey:pForKey];
    return pReturnObject;
}

+(void)addCustomObjectToUserDefaults:(id)pObject key:(NSString *)pStrKey{
    NSUserDefaults *currentDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.timebuddy"];
    [currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:pObject] forKey:pStrKey];
    [currentDefaults synchronize];
}

+(id)getCustomObjectToUserDefaults:(NSString *)pStrKey{
    id pReturnObject;
    NSData *data = [Helper getFromNSUserDefaults:pStrKey];
    pReturnObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return pReturnObject;
}


#pragma mark - String Functions

+(NSString*)getStringFromDate:(NSDate*)pDate withFormat:(NSString*)pDateFormat{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:pDateFormat];
    return [dtFormatter stringFromDate:pDate];
}

+(NSDate*)getDateFromString:(NSString*)pStrDate withFormat:(NSString*)pDateFormat{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:pDateFormat];
    return [dtFormatter dateFromString:pStrDate];
}

+(NSString*)getDocumentDirectoryPath:(NSString*)pStrPathName{
    NSString *strPath=nil;
    if(pStrPathName)
        strPath = [[kUserDirectoryPath objectAtIndex:0] stringByAppendingPathComponent:pStrPathName];
    return strPath;
}
@end
