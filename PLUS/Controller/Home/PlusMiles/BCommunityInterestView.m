//
//  BCommunityInterestView.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BCommunityInterestView.h"

@implementation BCommunityInterestView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
        
        [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
        
        categoryTextField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width / 2.0f, 18.0f)];
        [categoryTextField setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [categoryTextField setInputAccessoryView:toolbar];
        [self addSubview:categoryTextField];
        
        timeTextField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(categoryTextField.frame.origin.x + categoryTextField.frame.size.width, 0.0f, frame.size.width / 2.0f, 18.0f)];
        [timeTextField setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [timeTextField setInputAccessoryView:toolbar];
        [self addSubview:timeTextField];
        
        communityInterestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, timeTextField.frame.origin.y + timeTextField.frame.size.height, frame.size.width, frame.size.height - timeTextField.frame.origin.y - timeTextField.frame.size.height - 20.0f) style:UITableViewStylePlain];
        [communityInterestTableView setDataSource:self];
        [communityInterestTableView setDelegate:self];
        [self addSubview:communityInterestTableView];
        
        newPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [newPostButton setFrame:CGRectMake(2.0f, frame.size.height - 20.0f, frame.size.width - 4.0f, 18.0f)];
        [newPostButton setTitle:@"New Post" forState:UIControlStateNormal];
        [newPostButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [[newPostButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.50f]];
        [newPostButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [newPostButton addTarget:self action:@selector(doNewPost) forControlEvents:UIControlEventTouchDown];
        [self addSubview:newPostButton];
        
        timeOptionArray = [[NSArray alloc] initWithObjects:@"Last 7 days", @"Last 1 month", @"Last 3 months", @"Last 12 months", nil];
        
        timeOptionSecondArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:(7 * 24 * 3600)], [NSNumber numberWithDouble:(30 * 24 * 3600)], [NSNumber numberWithDouble:(3 * 30 * 24 * 3600)], [NSNumber numberWithDouble:(365 * 24 * 3600)], nil];
        
        [timeTextField setItemList:timeOptionArray];
        [timeTextField setText:[timeOptionArray objectAtIndex:0]];
        
        communityInterestArray = [[NSMutableArray alloc] init];
        currentPage = 1;
        [self retrieveCategory];
    }
    return self;
}

- (void)creatHUD{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self];
        HUD.labelText = @"loading...";
        [self addSubview:HUD];
        [HUD show:YES];
    }
}

- (void)hideHud{
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

#pragma mark EventHandler
- (void)doNewPost {
    if ([_delegate respondsToSelector:@selector(showAddCommunityInterest:)]) {
        NSString *categoryId = @"";
        for (int i = 0; i < [categoryArray count]; i++) {
            if ([[[categoryArray objectAtIndex:i] objectForKey:@"strInterestCatgName"] isEqual:categoryTextField.text]) {
                categoryId = [[categoryArray objectAtIndex:i] objectForKey:@"idInterestCatg"];
                break;
            }
        }
        
        [_delegate showAddCommunityInterest:categoryId];
    }
}

#pragma mark  - HttpData
- (void)retrieveCategory {
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveCategoryDataFinished:);
        httpData.didFailed = @selector(didRetrieveDataError);
        
        [self creatHUD];
        [httpData retrieveCommunityInterestCategory:strUniqueId intType:0];
    }
}

- (void)retrieveCommunityInterest {
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.LoginId"];
        
        NSString *categoryId = @"";
        for (int i = 0; i < [categoryArray count]; i++) {
            if ([[[categoryArray objectAtIndex:i] objectForKey:@"strInterestCatgName"] isEqual:categoryTextField.text]) {
                categoryId = [[categoryArray objectAtIndex:i] objectForKey:@"idInterestCatg"];
                break;
            }
        }
        
        NSDate *today = [NSDate date];
        NSString *dtLastUpdateDate = [NSString stringWithFormat:@"%@", today];
        for (int i = 0; i < [timeOptionArray count]; i++) {
            if ([[timeOptionArray objectAtIndex:i] isEqualToString:timeTextField.text]) {
                double minus = -1.0f * [[timeOptionSecondArray objectAtIndex:i] doubleValue];
                dtLastUpdateDate = [NSString stringWithFormat:@"%@", [today dateByAddingTimeInterval:minus]];
                break;
            }
        }
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveCommunityInterestDataFinished:);
        httpData.didFailed = @selector(didRetrieveDataError);
        
        [self creatHUD];
        [httpData retrieveCommunityInterestPaging:strUniqueId email:email strCategoryId:categoryId dtLastUpdateDate:dtLastUpdateDate intPageSelect:currentPage];
    }
}

- (void)didRetrieveCategoryDataFinished:(id)data {
    [self hideHud];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSArray *contentArr = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"] objectForKey:@"tblCommunityIntCatg"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        categoryArray = [[NSMutableArray alloc] initWithArray:contentArr];
        
        for (int i = 0; i < [contentArr count]; i++) {
            NSString *categoryName = [[contentArr objectAtIndex:i] objectForKey:@"strInterestCatgName"];
            [tempArray addObject:categoryName];
            
            if (i == 0) {
                [categoryTextField setText:categoryName];
            }
        }
        [categoryTextField setItemList:tempArray];
        [self retrieveCommunityInterest];
    }
}

- (void)didRetrieveCommunityInterestDataFinished:(id)data {
    [self hideHud];
    [communityInterestArray removeAllObjects];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSArray *contentArr = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"] objectForKey:@"tblcommunityinterest"];
        
        [communityInterestArray addObjectsFromArray:contentArr];
    }
    [communityInterestTableView reloadData];
}

- (void)didRetrieveDataError {
    [self hideHud];
}

#pragma mark Event Handler Delegate
- (void)doneClicked:(UIBarButtonItem*)button {
    currentPage = 1;
    
    [self endEditing:YES];
    [self retrieveCommunityInterest];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([communityInterestArray count] != 0) ? [communityInterestArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *EmptyCellIdentifier = @"EmptyCell";
    static NSString *CellIdentifier = @"CommunityInterestCell";
    
    if ([communityInterestArray count] != 0) {
        BCommunityInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BCommunityInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCommunityInterestInfo:[communityInterestArray objectAtIndex:[indexPath row]]];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:13.0f]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        }
        [[cell textLabel] setText:@"No Results"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(showCommunityInterestReply:)]) {
        [_delegate showCommunityInterestReply:[communityInterestArray objectAtIndex:[indexPath row]]];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommunityInterestCell";
    
    if ([communityInterestArray count] != 0) {
        BCommunityInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BCommunityInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCommunityInterestInfo:[communityInterestArray objectAtIndex:[indexPath row]]];
        
        return cell.totalHeight;
    } else {
        return communityInterestTableView.frame.size.height;
    }
}

@end
