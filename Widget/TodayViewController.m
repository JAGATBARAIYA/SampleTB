//
//  TodayViewController.m
//  Widget
//
//  Created by Manish on 14/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "ViewController.h"
#import "Colors.h"
#import "Helper.h"
#import "Country.h"

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *lblTimezoneName;
@property (strong, nonatomic) Country *country;

@end

@implementation TodayViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    
    Country *country = [Helper getCustomObjectToUserDefaults:@"kDefaultTimezone"];
    if(country){
        self.country = country;
    }else {
        NSTimeZone *localTimezone = [NSTimeZone localTimeZone];
        NSArray *array = [localTimezone.name componentsSeparatedByString:@"/"];
        if([array count] >= 2){
            NSString *strCountryName = array[0];
            if([strCountryName isEqualToString:@"America"])
                strCountryName = @"USA";
            
            strCountryName = [strCountryName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            if([array count] <= 2){
                _lblTimezoneName.text = [array[1] stringByAppendingFormat:@", %@",strCountryName];
            } else{
                _lblTimezoneName.text = [array[2] stringByAppendingFormat:@", %@",strCountryName];
            }
        }
    }
    [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES] fire];
    NSLog(@"View did load");
    [self updateUI];
}

#pragma mark - Setter for Country

- (void)setCountry:(Country *)country{
    _country = country;
    _lblTimezoneName.text = [country.strStateName stringByAppendingFormat:@", %@",country.strCountryName];
    
    [self updateTime];
}

- (void)updateTime{
    if(_country){
        _lblTime1.text = [[self getStringFromDate:[NSDate date] timezone:_country withFormat:@"hh:mm:ss a"] uppercaseString];
        _lblTime2.text = [[self getStringFromDate:[NSDate date] timezone:_country withFormat:@"HH:mm:ss"] uppercaseString];
        _lblTime3.text = [[self getStringFromDate:[NSDate date] timezone:_country withFormat:@"HHmm:ss"] uppercaseString];
    }else {
        _lblTime1.text = [[self getStringFromDate:[NSDate date] timezone:nil withFormat:@"hh:mm:ss a"] uppercaseString];
        _lblTime2.text = [[self getStringFromDate:[NSDate date] timezone:nil withFormat:@"HH:mm:ss"] uppercaseString];
        _lblTime3.text = [[self getStringFromDate:[NSDate date] timezone:nil withFormat:@"HHmm:ss"] uppercaseString];
    }
}

-(NSString*)getStringFromDate:(NSDate*)pDate timezone:(Country*)country withFormat:(NSString*)pDateFormat{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    if(country)
        dtFormatter.timeZone = country.timezone;
    [dtFormatter setDateFormat:pDateFormat];
    return [dtFormatter stringFromDate:pDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Tapped

- (IBAction)btnGoToAppTapped:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"DoubleTimePlus://"];
    [self.extensionContext openURL:URL completionHandler:nil];
}

#pragma mark - Date Formate    

-(NSString*)getStringFromDate:(NSDate*)pDate withFormat:(NSString*)pDateFormat{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:pDateFormat];
    return [dtFormatter stringFromDate:pDate];
}

#pragma mark - WidgetUpdate Delegate Method

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
    [self updateTime];
    //NSLog(@"Load Widget");
    //[self updateUI];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

- (void)updateUI{
    int rndValue1 = arc4random()%([[Colors sharedColors] arrColors].count-1);
    int rndValue2 = arc4random()%([[Colors sharedColors] arrColors].count-1);
    int rndValue3 = arc4random()%([[Colors sharedColors] arrColors].count-1);
    int rndValue4 = arc4random()%([[Colors sharedColors] arrColors].count-1);
    
    _lblTimezoneName.textColor = [[Colors sharedColors] arrColors][rndValue1];
    _lblTime1.backgroundColor = [[Colors sharedColors] arrColors][rndValue2];
    _lblTime2.backgroundColor = [[Colors sharedColors] arrColors][rndValue3];
    _lblTime3.backgroundColor = [[Colors sharedColors] arrColors][rndValue4];
}
@end
