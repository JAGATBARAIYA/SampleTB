//
//  mainCollectionViewCell.h
//  TimeBuddy
//
//  Created by E2M164 on 20/04/15.
//  Copyright (c) 2015 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "CountryListController.h"
#import "AnalogClockView.h"
#import "ClockSetup.h"

@interface MainCell : UICollectionViewCell

@property (strong, nonatomic) AnalogClockView *analogClockView;
@property (strong, nonatomic) ClockSetup *clockSetup;
@property (strong, nonatomic) IBOutlet UIView *viewAnaloug;
@property (strong, nonatomic) IBOutlet UIView *viewDigital;
@property (strong, nonatomic) IBOutlet UIView *viewDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMiddle;
@property (strong, nonatomic) IBOutlet UILabel *lblTimezoneName;
@property (strong, nonatomic) IBOutlet UILabel *lblTopTime;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddleTime;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTime;
@property (strong, nonatomic) NSTimer *timerGlobal;

- (void)setDigitalView:(NSDictionary*)dict;
- (void)setAnalougView:(NSDictionary*)dict;
- (void)setTime:(NSDictionary*)dict;
- (void)startQuivering;
- (void)stopQuivering;
@end
