//
//  CountryListController.m
//  AllDone
//
//  Created by Urmi Agnihotri on 06/12/13.
//
//

#import "CountryListController.h"
#import "Country.h"
#import "NSObject+Extras.h"
#import "Helper.h"
#import "SQLiteManager.h"
#define kAlpha          @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define kAlphaArray     [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil]

typedef enum{
    kTableIndex = 1,
    kTableSearch = 2,
} TableType;

@interface CountryListController ()
@property (strong, nonatomic) NSMutableArray *arrCountryNames;
@property (strong, nonatomic) NSMutableArray *filteredCountryNames;
@property (assign, nonatomic) TableType tableType;

@end

@implementation CountryListController

#pragma mark - View life Cycle

- (void)awakeFromNib{
    _arrCountryNames = [[NSMutableArray alloc] init];
    _filteredCountryNames = [[NSMutableArray alloc] init];
    [self commonInit];
    [_searchbar becomeFirstResponder];
    
    [self performBlock:^{
        [UIView animateWithDuration:0.4 animations:^{
            [_btnClose setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        }];
    } afterDelay:0.3];
    
    
    
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - Common Init

- (void)commonInit{
    _tableType = kTableIndex;
    [self createSectionList];
}

-(void)createSectionList{
    [kAlphaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_arrCountryNames addObject:[NSMutableArray array]];
    }];
    
    NSMutableArray *countryList = [[Country sharedInstance] arrCountryList];
    [countryList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Country *country = (Country*)obj;
        if(country.strStateName.length == 0)
            return;
        
        NSRange range;
        if(country.strStateName.length!= 0){
            range = [kAlpha rangeOfString:[country.strStateName substringToIndex:1]];
            [_arrCountryNames[range.location] addObject:country];
        }
    }];
    _filteredCountryNames = [[NSMutableArray alloc] initWithArray:_arrCountryNames];
    [_tblCountry reloadData];
}

#pragma mark - SearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        _tableType = kTableIndex;
        [_tblCountry reloadData];
    } else {
        _tableType = kTableSearch;
        [self searchAutocompleteEntriesWithSubstring:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [self commonInit];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _tableType = kTableSearch;
    [searchBar resignFirstResponder];
    [self searchAutocompleteEntriesWithSubstring:searchBar.text];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring{
    [_arrCountryNames removeAllObjects];
    
    [[[Country sharedInstance] arrCountryList] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Country *country = (Country*)obj;
        NSRange substringRange = [country.strStateName rangeOfString:substring options:NSCaseInsensitiveSearch];
        NSRange substringRange1 = [country.strCountryName rangeOfString:substring options:NSCaseInsensitiveSearch];
        
        if (substringRange.location != NSNotFound || substringRange1.location != NSNotFound)
            [_arrCountryNames addObject:country];
    }];
    
    [_tblCountry reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(_tableType == kTableIndex)
        return nil;
    else
        return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_tableType==kTableIndex) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [view addSubview:bgView];
        
        UILabel *lblChar = [[UILabel alloc] init];
        lblChar.frame = CGRectMake(8, 0, 312, view.frame.size.height);
        lblChar.font = [UIFont fontWithName:@"Roboto-Medium" size:15.0];
        lblChar.textColor = [UIColor whiteColor];
        lblChar.text = [self tableView:tableView titleForHeaderInSection:section];
        [view addSubview:lblChar];
        [view bringSubviewToFront:lblChar];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_tableType==kTableIndex) {
        NSArray *arr = _filteredCountryNames[section];
        if(arr.count!=0){
            return 22.0;
        }else {
            return 0.0;
        }
    }else{
        return 0.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(_tableType == kTableIndex)
        return kAlphaArray[section];
    else
        return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_tableType == kTableIndex)
        return _filteredCountryNames.count;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_tableType == kTableIndex)
        return [_filteredCountryNames[section] count];
    else
        return _arrCountryNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Country *country = nil;
    if(_tableType == kTableIndex){
        NSMutableArray *countryNames = _filteredCountryNames[indexPath.section];
        country = countryNames[indexPath.row];
    } else{
        country = _arrCountryNames[indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",country.strStateName,country.strCountryName];
    return cell;
}

#pragma mark - UITableViewDataDelegate

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.view endEditing:YES];
//    Country *country = nil;
//    if(_tableType == kTableIndex){
//        NSMutableArray *countryNames = _filteredCountryNames[indexPath.section];
//        country = countryNames[indexPath.row];
//    } else{
//        country = _arrCountryNames[indexPath.row];
//    }
//   
//    NSArray* foo = [[NSString stringWithFormat:@"%@",country.timezone] componentsSeparatedByString: @" "];
//    NSString* strTimeZone = [foo objectAtIndex: 0];
//
//    NSMutableDictionary *dictData=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName],@"name",strTimeZone,@"timeZone",@"0",@"isCurrentZone", nil];
//    
//    
//    NSArray  *tmpTimes=[[SQLiteManager singleton] findAllFrom:@"timezones"];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName]];
//    NSArray *filtered = [tmpTimes filteredArrayUsingPredicate:predicate];
//    if(filtered.count!=0){
//    //    [Helper siAlertView:nil msg:[NSString stringWithFormat:@"%@ is already added",[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName]]];
//    }else {
//        [[SQLiteManager singleton]save:dictData into:@"timezones"];
//        [_parent RelodCollectionView];
//    }
//    [_parent countryListEnded];
//    _searchbar.text=nil;
//    [_tblCountry reloadData];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    Country *country = nil;
    if(_tableType == kTableIndex){
        NSMutableArray *countryNames = _filteredCountryNames[indexPath.section];
        country = countryNames[indexPath.row];
    } else{
        country = _arrCountryNames[indexPath.row];
    }
    
    NSArray* foo = [[NSString stringWithFormat:@"%@",country.timezone] componentsSeparatedByString: @" "];
    NSString* strTimeZone = [foo objectAtIndex: 0];
    
    NSMutableDictionary *dictData=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName],@"name",strTimeZone,@"timeZone",@"0",@"isCurrentZone", nil];
    
    
    NSArray  *tmpTimes=[[SQLiteManager singleton] findAllFrom:@"timezones"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName]];
    NSArray *filtered = [tmpTimes filteredArrayUsingPredicate:predicate];
    if(filtered.count!=0){
        //    [Helper siAlertView:nil msg:[NSString stringWithFormat:@"%@ is already added",[country.strStateName stringByAppendingFormat:@", %@",country.strCountryName]]];
    }else {
        [[SQLiteManager singleton]save:dictData into:@"timezones"];
        
    }
    
    
    //    [_parent countryListEnded];
    _searchbar.text=nil;
    [_tblCountry reloadData];
    if ([_delegate respondsToSelector:@selector(reloadCollectionAndCommit)]) {
        [_delegate reloadCollectionAndCommit];
    }
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

-(IBAction)btnCloseTapped:(id)sender {
    
    [_delegate rotetButton];
    //   [UIView animateWithDuration:0.4 animations:^{
    //        [_btnClose setTransform:CGAffineTransformMakeRotation(M_PI / 4)];
    //    } completion:^(BOOL finished) {
    //    }];
    
    [self performBlock:^{
        self.alpha = 1;
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    } afterDelay:0.3];
}


@end
