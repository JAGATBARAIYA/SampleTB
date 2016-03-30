//
//  Helper.h
//  DoubleTimePlus
//
//  Created by Manish Dudharejia on 17/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject


+ (void)siAlertView:(NSString*)title msg:(NSString*)msg;
+(void)addToNSUserDefaults:(id)pObject forKey:(NSString*)pForKey;
+(void)removeFromNSUserDefaults:(NSString*)pForKey;
+(id)getFromNSUserDefaults:(NSString*)pForKey;
+(void)addCustomObjectToUserDefaults:(id)pObject key:(NSString *)pStrKey;
+(id)getCustomObjectToUserDefaults:(NSString *)pStrKey;

+(void)addBoolNSUserDefaults:(BOOL)yesNo forKey:(NSString*)pForKey;
+(BOOL)getBoolFromNSUserDefaults:(NSString*)pForKey;
+(NSString*)getStringFromDate:(NSDate*)pDate withFormat:(NSString*)pDateFormat;
+(NSDate*)getDateFromString:(NSString*)pStrDate withFormat:(NSString*)pDateFormat;
+(NSString*)getDocumentDirectoryPath:(NSString*)pStrPathName;
@end
