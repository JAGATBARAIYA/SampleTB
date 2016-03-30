//
//  CountryListController.h
//  AllDone
//
//  Created by Urmi Agnihotri on 06/12/13.
//
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class CountryListController;
@protocol countryListViewDelegate <NSObject>

- (void)reloadCollectionAndCommit;
- (void)rotetButton;

@end

@interface CountryListController : UIView

@property (nonatomic, strong) IBOutlet UITableView *tblCountry;
@property (strong, nonatomic) IBOutlet UILabel *lblPullMeUp;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) ViewController *parent;
@property (strong, nonatomic) IBOutlet UIView *panView;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;

@property (assign, nonatomic) id<countryListViewDelegate> delegate;

@end
