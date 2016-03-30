//
//  ViewController.m
//  DoubleTimePlus
//
//  Created by Manish on 14/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#define OVERLAY_HEIGHT  0.0
#define PAN_TIMING      0.2f

#import "ViewController.h"
#import "Colors.h"
#import "TodayViewController.h"
#import "CountryListController.h"
#import "Helper.h"
#import "AnalogClockView.h"
#import "CountryListController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import <MessageUI/MessageUI.h>
#import "Messages.h"
#import "SocialMedia.h"
#import "SMPageControl.h"
#import "MainCell.h"
#import "Common.h"
#import "SQLiteManager.h"
#import "AddReminderVC.h"
#import "ReminderListVC.h"

static NSString * const sampleDescription1 = @"A colorful world clock at your fingertips.";
static NSString * const sampleDescription2 = @"Swipe down from top and you can see the list of hundreds of cities across the world to set your preferred timzone.";
static NSString * const sampleDescription3 = @"3 different formats including military clock.";
static NSString * const sampleDescription4 = @"Swipe left to see analog view.";
static NSString * const sampleDescription5 = @"Customize widget area to add Time Buddy widget.";

@interface ViewController () <UIGestureRecognizerDelegate,EAIntroDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,countryListViewDelegate>
{
    CGPoint finalPoint;
}

@property (strong, nonatomic) AnalogClockView *analogClockView;
@property (strong, nonatomic) CountryListController *countryListController;

@property (strong, nonatomic) IBOutlet UIButton *btnAddCityDeleteCity;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontroller;
@property (strong, nonatomic) NSMutableArray *allTimeZones;
@property (strong, nonatomic) NSMutableArray *allTimeZonesList;
@property (assign, nonatomic) BOOL isDeleteView;

@end

@implementation ViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    NSLog(@"Local Notificatin Reminder Array :: %@",aMutNotificationArray);
    NSLog(@"Array Count :: %ld",aMutNotificationArray.count);

    [self commonInit];
    if(![Helper getBoolFromNSUserDefaults:@"InformationView"]){
        [self showIntroWithCrossDissolve];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:@"TimeBuddy"];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOverLayView:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [_countryListController.panView addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.collectionview addGestureRecognizer:lpgr];

}

-(void)commonInit {
    
    [self intializeLocalTimeZone];
    
    _allTimeZones=[[NSMutableArray alloc]init];
    _allTimeZonesList=[[NSMutableArray alloc]init];
    _analogClockView = [[NSBundle mainBundle] loadNibNamed:@"AnalogClockView" owner:self options:nil][0];
    [_collectionview registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellWithReuseIdentifier:@"MainCell"];

    if (_isDeleteView!=YES) {
        [_btnAddCityDeleteCity addTarget:self action:@selector(addCityTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSArray  *tmpTimes=[[SQLiteManager singleton] findAllFrom:TABLENAME];
    if (tmpTimes.count !=0) {
        NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"tId" ascending:NO];
        NSArray *tmpTimes2 = [NSMutableArray arrayWithArray:[tmpTimes sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]]];
        NSSortDescriptor *descriptor2=[NSSortDescriptor sortDescriptorWithKey:@"isCurrentZone" ascending:NO];
        _allTimeZonesList = [NSMutableArray arrayWithArray:[tmpTimes2 sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor2]]];
        
        float pages = (_allTimeZonesList.count/4);
        if (_allTimeZonesList.count%4 == 0) {
        } else {
            pages = ceil((_allTimeZonesList.count/4)+0.5);
        }
        _pagecontroller.numberOfPages=pages;
        for (int i=0; i<_allTimeZonesList.count; i++) {
            [_allTimeZones addObject:[NSNumber numberWithInt:0]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)intializeLocalTimeZone{
    
    NSTimeZone *localTimezone = [NSTimeZone localTimeZone];
    NSArray *array = [localTimezone.name componentsSeparatedByString:@"/"];
    
    if([array count] >= 2){
        NSString *strCountryName = array[0];
        if([strCountryName isEqualToString:@"America"])
            strCountryName = @"USA";
        strCountryName = [strCountryName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        if([array count] <= 2){
            [self saveLocalTimeZone:[array[1] stringByAppendingFormat:@", %@",strCountryName] timezone:[strCountryName stringByAppendingFormat:@"/%@",array[1]]];
        } else{
            [self saveLocalTimeZone:[array[2] stringByAppendingFormat:@", %@",strCountryName] timezone:[strCountryName stringByAppendingFormat:@"/%@",array[2]]];
        }
    }
}

-(void)saveLocalTimeZone:(NSString*)name timezone:(NSString*)timezone {
    
    NSArray *arrayTemp=[[SQLiteManager singleton] find:@"tId" from:TABLENAME where:@"isCurrentZone=1"];
    if (arrayTemp.count!=0) {
        NSString *updateQuery=[NSString stringWithFormat:@"UPDATE %@ SET name = '%@',timeZone = '%@' WHERE tid == '%@'",TABLENAME,name,timezone,arrayTemp[0]];
        [[SQLiteManager singleton] executeSql:updateQuery];
    } else {
        NSMutableDictionary *divtValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          name,@"name",
                                          timezone,@"timeZone",
                                          @"1",@"isCurrentZone",
                                          nil];
        [[SQLiteManager singleton] save:divtValue into:TABLENAME];
    }
}

#pragma mark - Collection View delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return _allTimeZones.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MainCell *cell = (MainCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];

    [cell.btnDelete addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAdd addTarget:self action:@selector(addCellReminder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddMiddle addTarget:self action:@selector(addCellReminder:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.item;
    cell.btnAdd.tag = indexPath.item;
    cell.btnAddMiddle.tag = indexPath.item;
    [cell.btnDelete setHidden:NO];
    [cell.btnAdd setHidden:NO];
    [cell.btnAddMiddle setHidden:YES];

    if (indexPath.item == 0)
    {
        if (_isDeleteView==YES)
        {
            cell.viewDelete.hidden = cell.btnAddMiddle.hidden = NO;
            cell.btnDelete.hidden = cell.btnAdd.hidden = YES;
        }
        else
            cell.viewDelete.hidden=YES;
    }
    else
    {
        if (_isDeleteView==YES)
            cell.viewDelete.hidden=NO;
        else
            cell.viewDelete.hidden=YES;
    }

    NSNumber *temp= _allTimeZones[indexPath.item];
    if (temp==[NSNumber numberWithInt:1]) {
        [cell setAnalougView:_allTimeZonesList[indexPath.item]];
    } else {
        [cell setDigitalView:_allTimeZonesList[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isDeleteView!=YES) {
        for (int j=0; j<_allTimeZones.count; j++) {
            if (_allTimeZones[j]==[NSNumber numberWithInt:1]) {
            }
            if (j==indexPath.item) {
                if (_allTimeZones[j]==[NSNumber numberWithInt:1]) {
                    [self reloadAnaloug:j isAnaloug:[NSNumber numberWithInt:0] indexpath:indexPath collectionView:collectionView];
                }else {
                    [self reloadAnaloug:j isAnaloug:[NSNumber numberWithInt:1] indexpath:indexPath collectionView:collectionView];
                }
            }else {
            }
        }
    }
}

-(void)reloadAnaloug:(int)index isAnaloug:(NSNumber*)isAnaloug indexpath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView {
    
    [self.allTimeZones replaceObjectAtIndex:index  withObject:isAnaloug];
    NSArray *array=[[NSArray alloc]initWithObjects:indexPath, nil];
    [collectionView performBatchUpdates:^{
        [collectionView reloadItemsAtIndexPaths:array];
    } completion:^(BOOL finished) {
    }];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = 0;
    itemWidth = ((size.width)/2)-50;
    CGFloat itemHeight=0;
    itemHeight =((size.height)/2)-50;
    
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - Relod Collectionview

-(void)RelodCollectionView {
    
    [self commonInit];
    [_collectionview reloadData];
}

- (void)mainCollectionViewCell:(MainCell*)cell indexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor=[UIColor greenColor];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    
    MainCell *cell;
    cell.viewAnaloug.hidden=NO;
}

#pragma mark - Scroll View delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pagecontroller.currentPage = self.collectionview.contentOffset.x / _collectionview.frame.size.width;
}

#pragma mark - Button Actions

-(IBAction)addCityTapped:(id)sender {
    if (_isDeleteView!=YES) {
        
        _countryListController = [[NSBundle mainBundle] loadNibNamed:@"CountryListController" owner:self options:nil][0];
        _countryListController.delegate = self;
        [self.view addSubview:_countryListController];
        _countryListController.frame = self.view.bounds;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
    }];
}

-(IBAction)deleteCell:(UIButton *)sender
{
    NSLog(@"delete indexpath:%ld",(long)sender.tag);
    NSDictionary *dict=_allTimeZonesList[sender.tag];
    int row=[dict[@"tId"] intValue];
    [[SQLiteManager singleton] deleteRowWithId:row from:TABLENAME];

    NSMutableArray *aMutNotificationArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    NSString *strDelete = [NSString stringWithFormat:@"DELETE from tblReminder WHERE timezoneId = %@",dict[@"tId"]];
    [[SQLiteManager singleton] executeSql:strDelete];

    for (UILocalNotification *aNotification in aMutNotificationArray)
    {
        if ([[aNotification.userInfo valueForKey:@"timeZone"] isEqualToString:dict[@"timeZone"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
        }
    }

    [_allTimeZonesList removeObjectAtIndex:sender.tag];
    [_allTimeZones removeObjectAtIndex:sender.tag];
    [_collectionview performBatchUpdates:^{
        [_collectionview deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    } completion:^(BOOL finished) {
        [_collectionview.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *path = (NSIndexPath*)obj;
            MainCell *cell = (MainCell*)[_collectionview cellForItemAtIndexPath:path];
            cell.btnDelete.tag = path.row;
            if (_allTimeZonesList.count == 1) {
                cell.viewDelete.hidden = YES;
            }
        }];
    }];
    
    if (_allTimeZonesList.count==1) {
        _isDeleteView=NO;

        [_btnAddCityDeleteCity addTarget:self action:@selector(addCityTapped:) forControlEvents:UIControlEventTouchUpInside];
         [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        [UIView animateWithDuration:0.8 animations:^{
            [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        } completion:^(BOOL finished) {
        }];
    }
    
    float pages = (_allTimeZonesList.count/4);
    if (_allTimeZonesList.count%4 == 0) {
    } else {
        pages = ceil((_allTimeZonesList.count/4)+0.5);
    }
    _pagecontroller.numberOfPages=pages;
    _pagecontroller.currentPage = self.collectionview.contentOffset.x / _collectionview.frame.size.width;
}

-(IBAction)addCellReminder:(UIButton *)sender{
    ReminderListVC *reminderListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReminderListVC"];
    NSDictionary *dict=_allTimeZonesList[sender.tag];
    reminderListVC.dictTimeZone = dict;
    [self.navigationController pushViewController:reminderListVC animated:YES];
}

-(IBAction)closeLongpress:(id)sender {
    if (_isDeleteView==YES) {
        _isDeleteView=NO;
        [_collectionview reloadData];
        [_btnAddCityDeleteCity addTarget:self action:@selector(addCityTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        [UIView animateWithDuration:0.8 animations:^{
            [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - gesture Events

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (_isDeleteView!=YES) {
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
            _isDeleteView=YES;
            [_collectionview reloadData];
            return;
        }
    }

    [_btnAddCityDeleteCity addTarget:self action:@selector(closeLongpress:) forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:0.4 animations:^{
        [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
    }];
}

-(void)toggleOverLayView:(UIPanGestureRecognizer *)gesturer{

}

- (void)countryListEnded{

}

-(IBAction)btnInfoTapped:(id)sender{
    [self showIntroWithCrossDissolve];
}

- (IBAction)btnContactUsTapped:(id)sender {
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *msgcontroller = [[MFMailComposeViewController alloc] init];
        msgcontroller.mailComposeDelegate = self;
        [msgcontroller setSubject:@"TimeBuddy Support"];
        [msgcontroller setToRecipients:[NSArray arrayWithObject:@"info@moveoapps.com"]];
        [self presentViewController:msgcontroller animated:YES completion:NULL];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Simply Awesome";
    page1.desc = sampleDescription1;
    page1.bgImage = [self imageWithColor:[UIColor colorWithRed:64.0/255.0 green:77.0/255.0 blue:255.0/255.0 alpha:1.0]];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Set the Timezone";
    page2.desc = sampleDescription2;
    page2.bgImage = [self imageWithColor:[UIColor colorWithRed:162.0/255.0 green:3.0/255.0 blue:14.0/255.0 alpha:1.0]];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Digital Clock";
    page3.desc = sampleDescription3;
    page3.bgImage =[self imageWithColor:[UIColor colorWithRed:0.0/255.0 green:99.0/255.0 blue:12.0/255.0 alpha:1.0]];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Analog Clock";
    page4.desc = sampleDescription4;
    page4.bgImage = [self imageWithColor:[UIColor colorWithRed:144.0/255.0 green:8.0/255.0 blue:195.0/255.0 alpha:1.0]];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroPage *page5=[EAIntroPage page];
    page5.title=@"Create Widget";
    page5.desc=sampleDescription5;
    page5.bgImage=[self imageWithColor:[UIColor colorWithRed:213.0/255.0 green:110.0/255.0 blue:26.0/255.0 alpha:1.0]];
    page5.titleIconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title5"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.3];
}
- (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - EAIntroView delegate methods
- (void)introDidFinish:(EAIntroView *)introView{
    [Helper addBoolNSUserDefaults:YES forKey:@"InformationView"];
    [introView removeFromSuperview];
}
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {

}
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex{

}
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex{

}

-(void)reloadCollectionAndCommit {
    [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
    [UIView animateWithDuration:0.8 animations:^{
        [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    } completion:^(BOOL finished) {
    }];

    [_collectionview reloadData];
    [self commonInit];
    [_collectionview reloadData];
}

- (void)rotetButton {
    [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
    [UIView animateWithDuration:0.8 animations:^{
        [_btnAddCityDeleteCity setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    } completion:^(BOOL finished) {
    }];
}

@end
