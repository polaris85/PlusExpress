//
//  BMerchantView.m
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BMerchantView.h"
#import "Constants.h"
@implementation BMerchantView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        merchantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [merchantTableView setDelegate:self];
        [merchantTableView setDataSource:self];
        [self addSubview:merchantTableView];
        
        [self retrievePromotion];
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

- (void)retrievePromotionLocal {
    NSArray *sortedArray = [[TblPromotion searchPromotion] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *first = [obj1 objectForKey:@"strMerchantName"];
        NSString *second = [obj2 objectForKey:@"strMerchantName"];
        
        return [first compare:second];
    }];
    
    NSMutableSet *alphabetSet = [NSMutableSet set];
    for (int i = 0; i < [sortedArray count]; i++) {
        NSString *strMerchantName = [[sortedArray objectAtIndex:i] objectForKey:@"strMerchantName"];
        NSString *alphabet = [[strMerchantName substringToIndex:1] uppercaseString];
        [alphabetSet addObject:alphabet];
    }
    alphabetArray = [[NSMutableArray alloc] initWithArray:[[alphabetSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *first = (NSString *)obj1;
        NSString *second = (NSString *)obj2;
        return [first compare:second];
    }]];
    
    merchantArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [alphabetArray count]; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (int j = 0; j < [sortedArray count]; j++) {
            NSString *strMerchantName = [[sortedArray objectAtIndex:j] objectForKey:@"strMerchantName"];
            if ([[alphabetArray objectAtIndex:i] isEqualToString:[[strMerchantName substringToIndex:1] uppercaseString]]) {
                [sectionArray addObject:[sortedArray objectAtIndex:j]];
            }
        }
        [merchantArray addObject:sectionArray];
    }
    
    [merchantTableView reloadData];
}

#pragma mark - HttpData
- (void)retrievePromotion {
    if ([CheckNetwork connectedToNetwork]) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"dtRetrievePromotionUpdate"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"2013-08-11 22:12:03" forKey:@"dtRetrievePromotionUpdate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSString *dtLastPromoUpdate = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"dtRetrievePromotionUpdate"]];
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrievePromotionDataFinished:);
        httpData.didFailed = @selector(didRetrievePromotionDataFinishedError);
        
        [self creatHUD];
        
        [httpData retrievePromotion:dtLastPromoUpdate strUniqueId:strUniqueId latitude:2.284551f longitude:102.411804f];
    }
}

- (void)didRetrievePromotionDataFinished:(id)data {
    [self hideHud];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSDictionary *messagesDict = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"];
        
        NSArray *tblNameArray = [NSArray arrayWithObjects:@"tblPromotionCatg", @"tblPromotion", nil];
        
        if ([messagesDict count] > 0)
            for (int i = 0; i < [tblNameArray count]; i++) {
                NSString *tblName = [tblNameArray objectAtIndex:i];
                
                NSArray *contentArr = [messagesDict objectForKey:tblName];
                
                for (int j = 0; j < contentArr.count; j++) {
                    NSDictionary *contentDic = [NSDictionary dictionaryWithDictionary:[contentArr objectAtIndex:j]];
                    
                    NSEnumerator * enumeratorKey = [contentDic keyEnumerator];
                    NSMutableArray *conlumnArr = [[NSMutableArray alloc] init];
                    for (NSObject *object in enumeratorKey) {
                        [conlumnArr addObject:object];
                    }
                    
                    NSEnumerator * enumeratorValue = [contentDic objectEnumerator];
                    NSMutableArray *valuesArr = [[NSMutableArray alloc] init];
                    
                    for (NSObject *object in enumeratorValue) {
                        [valuesArr addObject:object];
                    }
                    
                    NSMutableArray *conditonArr = [[NSMutableArray alloc] init];
                    for (int k = 0; k<conlumnArr.count; k++) {
                        if (![[conlumnArr objectAtIndex:k] isEqualToString:@"intStatus"]) {
                            if ([valuesArr objectAtIndex:k] != [NSNull null]) {
                                [conditonArr addObject:[NSString stringWithFormat:@"%@='%@'",[conlumnArr objectAtIndex:k],[valuesArr objectAtIndex:k]]];
                            } else {
                                [conditonArr addObject:[NSString stringWithFormat:@"%@ = ''",[conlumnArr objectAtIndex:k]]];
                            }
                        }
                    }
                    
                    NSString *conlumnWhere = @"idPromoCatg";
                    if (i == 1) {
                        conlumnWhere = @"idPromo";
                    }
                    
                    NSString *condition = [NSString stringWithFormat:@"%@='%@'",conlumnWhere,[contentDic objectForKey:conlumnWhere]];
                    
                    NSString *updateConditionStr = [NSString stringWithFormat:@"%@",[conditonArr componentsJoinedByString:@","]];
                    
                    if ([[contentDic objectForKey:@"intStatus"] intValue] == 1) {
                        if ([DBUpdate checkWithTableName:tblName condition:condition]) {
                            [DBUpdate update:tblName values:updateConditionStr condition:condition];
                        } else {
                            NSMutableArray *conlumn_deleteState_Arr = [[NSMutableArray alloc] init];
                            NSMutableArray *values_deleteState_Arr = [[NSMutableArray alloc] init];
                            
                            for (int y = 0; y < conlumnArr.count; y++) {
                                if (![[conlumnArr objectAtIndex:y] isEqualToString:@"intStatus"]) {
                                    [conlumn_deleteState_Arr addObject:[conlumnArr objectAtIndex:y]];
                                    
                                    if ([[valuesArr objectAtIndex:y] isKindOfClass:[NSString class]]) {
                                        [values_deleteState_Arr addObject:[NSString stringWithFormat:@"\"%@\"",[valuesArr objectAtIndex:y]]];
                                    } else {
                                        [values_deleteState_Arr addObject:@"\"\""];
                                    }
                                    
                                }
                            }
                            
                            NSString *conlumnName = [NSString stringWithString:[conlumn_deleteState_Arr componentsJoinedByString:@","]];
                            NSString *values = [NSString stringWithString:[values_deleteState_Arr componentsJoinedByString:@","]];
                            
                            [DBUpdate insert:tblName columnName:conlumnName values:values];
                        }
                    } else if ([[contentDic objectForKey:@"intStatus"] intValue] == 2) {
                        [DBUpdate deleWithTableName:tblName condition:condition];
                    }
                    
                }
            }
        
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:currentDate] forKey:@"dtRetrievePromotionUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self retrievePromotionLocal];
}

- (void)didRetrievePromotionDataFinishedError {
    [self hideHud];
    
    [self retrievePromotionLocal];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (IS_IPAD) {
        return 40;
    }
    return 20.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (alphabetArray != nil) {
        return [alphabetArray count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (merchantArray != nil) {
        return [[merchantArray objectAtIndex:section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    BPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BPromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDictionary:[[merchantArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int headerHeight = 20;
    int fontSize = 14;
    if (IS_IPAD) {
        headerHeight = 40;
        fontSize = 28;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, headerHeight)];
    [headerView setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:92.0f/255.0f blue:92.0f/255.0f alpha:1.0f]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.frame.size.width - 5.0f, headerHeight)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [headerLabel setText:[alphabetArray objectAtIndex:section]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *merchantDictionary = [[merchantArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    NSString *urlString = [merchantDictionary objectForKey:@"strWebsite"];
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    BPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BPromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDictionary:[[merchantArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    return MAX(100.0f, cell.totalHeight);
}

@end
