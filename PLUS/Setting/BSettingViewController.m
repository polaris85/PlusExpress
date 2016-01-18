
#import "BSettingViewController.h"
#import "TblConfig.h"
#import "DBUpdate.h"
#import "TblHighwayEntry.h"
#import "Constants.h"
@interface BSettingViewController ()

@end

@implementation BSettingViewController

@synthesize currentLocation;
@synthesize locManager;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [locManager stopUpdatingLocation];
    [locManager setDelegate:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleLabel.text = @"Settings";
    if (!isSettingMode) {
        [backButton setHidden:YES];
    }
    
    highwayArr = [[NSArray alloc] initWithArray:[TblHighwayEntry searchHighway]];

    [self creatUI];
    
    //[self creatAnnouncements];
    
    [self CreatLocationManager];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    self.locManager = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)creatUI{
    
    NSInteger bottomHeight = 45;
    if (isSettingMode) {
        bottomHeight = 0;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TOP_HEADER_HEIGHT-statusBarHeight-bottomHeight) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setScrollEnabled:YES];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    if (bottomHeight > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-bottomHeight, self.view.bounds.size.width, bottomHeight)];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 5, 80, 30)];
        [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(goSplash) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview: nextButton];
        
        [self.view addSubview:view];
    }
}

- (void) goSplash
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"]  animated:NO];
}

- (void)switchChanged:(id)sender {
    int tag = [sender tag];
    UISwitch *switchView = (UISwitch *)sender;
    
    if (tag == 1006) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:switchView.isOn forKey:@"Setting.SyncData"];
        [userDefault synchronize];
        
    } else if (tag == 4001) {
        NSString *map = @"";
        if (GmapSwitchView.isOn) {
            [WazeSwitchView setOn:NO animated:YES];
            map = @"Google";
        } else {
            [WazeSwitchView setOn:YES animated:YES];
            map = @"Waze";
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:map forKey:@"Setting.Map"];
        [userDefault synchronize];
        
    } else if (tag == 4002) {
        NSString *map = @"";
        if (WazeSwitchView.isOn) {
            [GmapSwitchView setOn:NO animated:YES];
            map = @"Waze";
        } else {
            [GmapSwitchView setOn:YES animated:YES];
            map = @"Google";
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:map forKey:@"Setting.Map"];
        [userDefault synchronize];
        
    } else {
        NSString *idHighway = [[highwayArr objectAtIndex:tag] objectForKey:@"idHighway"];
            
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:switchView.isOn forKey:[NSString stringWithFormat:@"Setting.%@",idHighway]];
        [userDefault synchronize];
        
        NSMutableArray *highway = [NSMutableArray array];
        
        for (int row = 0; row < [highwayArr count]; row++) {
            NSString *idHighwayRow = [[highwayArr objectAtIndex:row] objectForKey:@"idHighway"];
            
            NSDictionary *highwayDict;
            NSString *settingKey = [NSString stringWithFormat:@"Setting.%@",idHighwayRow];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:settingKey]) {
                highwayDict = [NSDictionary dictionaryWithObject:@"1" forKey:idHighwayRow];
            } else {
                highwayDict = [NSDictionary dictionaryWithObject:@"0" forKey:idHighwayRow];
            }
            [highway addObject:highwayDict];
        }
        
        [self updatePushPreference:highway];

    }
}

- (void)buttonTap:(id)sender {

    int tag = [sender tag];
    if (tag == 3001) {
        [self retrieveTableConfig];
        [self retrieveLatestData];
        
    } else if (tag == 3002) {
        if ([emailField.text isEqualToString:@""]) {
            [self showAlertViewWithTitle:@"Email must be filled" duration:2.0f];
            
        } else if (![self validateEmailWithString:emailField.text]) {
            [self showAlertViewWithTitle:@"Wrong email format" duration:2.0f];
            
        } else if ([pinField.text isEqualToString:@""]) {
            [self showAlertViewWithTitle:@"Password must be filled" duration:2.0f];
            
        } else {
            [self showAlertViewWithTitle:@"Plus Data Saved" duration:1.5];
            
            [DBUpdate update:@"tblConfig" values:[NSString stringWithFormat:@"PlusEmail='%@'", emailField.text]];
            [DBUpdate update:@"tblConfig" values:[NSString stringWithFormat:@"PlusPassword='%@'", pinField.text]];
            
            [emailField resignFirstResponder];
            [pinField resignFirstResponder];
        
        }
    } 
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark  - HttpData
- (void)updatePushPreference:(NSMutableArray *)highway {
    NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    NSDictionary *strModule = [NSDictionary dictionaryWithObject:@"1" forKey:@"LTU"];
    
    NSString *strToken = @""; // PUSH TOKEN
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pushToken"]) {
        strToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushToken"];
    }
    
    HttpData *httpData = [[HttpData alloc] init];
    httpData.dele = self;
    httpData.didFinished = @selector(didUpdatePushPreferenceFinished:);
    httpData.didFailed = @selector(didUpdatePushPreferenceFailed);
    [httpData updatePushPreference:highway strModule:strModule strToken:strToken strUniqueId:strUniqueId
                          latitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
}

- (void)didUpdatePushPreferenceFinished:(id)data{
    [self hideAlertView];
    
    if ([[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
//        NSLog(@"%@",[data JSONValue]);
//        
//        NSString *msg = @"Key has been sent to your email.";
//        [self showAlertViewWithTitle:nil message:msg duration:2.0f];
    }
}

- (void)didUpdatePushPreferenceFailed{
    
    [self hideAlertView];
}

- (void)retrieveTableConfig {
    NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
    
    HttpData *httpData = [[HttpData alloc] init];
    httpData.dele = self;
    httpData.didFinished = @selector(didUpdateTableConfigFinished:);
    httpData.didFailed = @selector(didUpdateTableConfigFailed);
    [httpData retrieveTableConfig:dtLastUpdate strUniqueId:strUniqueId];
}

- (void)didUpdateTableConfigFinished:(id)data{
    NSLog(@"DATA : %@",[data JSONValue]);
    
    if ([[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSLog(@"%@",[data JSONValue]);
        
    }
}

- (void)didUpdateTableConfigFailed {
    
}

- (void)retrieveLatestData{
    [self showLoadingAlertWithTitle:@"Syncing..."];
    
    NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
    NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];

    HttpData *httpData = [[HttpData alloc] init];
    httpData.dele = self;
    httpData.didFinished = @selector(didRetrieveLatestDataFinished:);
    httpData.didFailed = @selector(didRetrieveLatestDataFinishedError);
    [httpData retrieveLatestData:dtLastUpdate strUniqueId:strUniqueId strLastKnownLoc:@""];
}


- (void)didRetrieveLatestDataFinished:(id)data{
    [self hideAlertView];
    
    NSLog(@"didRetrieveLatestDataFinished=====%@",[data JSONValue]);
    [DBUpdate update:@"tblConfig" values:[NSString stringWithFormat:@"dtLastUpdate='%@'",[[[data JSONValue] objectForKey:@"result"] objectForKey:@"LatestCheckDate"]]];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"MsgBox"] length] > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[data JSONValue] objectForKey:@"result"] objectForKey:@"MsgBox"] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        
        if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"] count] != 0) {
            
            NSDictionary *dic = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"];
            
            NSArray *tableArr = [NSArray arrayWithArray:[dic allKeys]];
            //   NSLog(@"%@",tableArr);
            
            for (int i = 0; i<tableArr.count; i++) {
                
                NSArray *contentArr = [NSArray arrayWithArray:[dic objectForKey:[tableArr objectAtIndex:i]]];//
                
                for (int j = 0; j< contentArr.count; j++) {
                    
                    NSDictionary *contentDic = [NSDictionary dictionaryWithDictionary:[contentArr objectAtIndex:j]];
                    
                    // NSLog(@"%@",contentDic);
                    
                    NSEnumerator * enumeratorKey = [contentDic keyEnumerator];
                    
                    NSMutableArray *conlumnArr = [[NSMutableArray alloc] init];
                    
                    for (NSObject *object in enumeratorKey) {
                        
                        [conlumnArr addObject:object];
                    }
                    
                    
                    NSEnumerator * enumeratorValue = [contentDic objectEnumerator];
                    
                    NSMutableArray *valuesArr = [[NSMutableArray alloc] init];
                    
                    for (NSObject *object in enumeratorValue) {
                        
                        //                        if ([object isKindOfClass:[NSNull class]]) {
                        //
                        //                           // NSLog(@"%@",object);
                        //                            object = @"";
                        //                        }
                        [valuesArr addObject:object];
                    }
                    
                    
                    NSMutableArray *conditonArr = [[NSMutableArray alloc] init];
                    
                    for (int k = 0; k<conlumnArr.count; k++) {
                        
                        
                        if (![[conlumnArr objectAtIndex:k] isEqualToString:@"intStatus"]) {
                            
                            //[conditonArr addObject:[NSString stringWithFormat:@"%@='%@'",[conlumnArr objectAtIndex:k],[valuesArr objectAtIndex:k]]];
                            
                            
                            if ([valuesArr objectAtIndex:k] != [NSNull null]) {
                                [conditonArr addObject:[NSString stringWithFormat:@"%@='%@'",[conlumnArr objectAtIndex:k],[valuesArr objectAtIndex:k]]];
                            }else {
                                
                                
                                [conditonArr addObject:[NSString stringWithFormat:@"%@ = ''",[conlumnArr objectAtIndex:k]]];
                            }
                            
                        }
                    }
                    
                    
                    NSString *conlumnWhere = [NSString stringWithFormat:@"id%@",[[tableArr objectAtIndex:i] substringFromIndex:3]];
                    
                    if ([conlumnWhere isEqualToString:@"idPetrolStation"]) {
                        conlumnWhere = @"idPetrol";
                    }else if ([conlumnWhere isEqualToString:@"idAnnouncements"]) {
                        conlumnWhere = @"idAnnouncement";
                    }else if ([conlumnWhere isEqualToString:@"idroutedetails"]) {
                        conlumnWhere = @"idRoute";
                    }
                    
                    NSString *condition;
                    if ([[tableArr objectAtIndex:i] isEqualToString:@"tblroutedetails"]) {
                        // NSLog(@"%@",contentDic);
                        condition = [NSString stringWithFormat:@"%@='%@' AND intSeq = '%@'",conlumnWhere,[contentDic objectForKey:conlumnWhere],[contentDic objectForKey:@"intSeq"]];
                        // NSLog(@"%@",condition);
                    }else {
                        condition = [NSString stringWithFormat:@"%@='%@'",conlumnWhere,[contentDic objectForKey:conlumnWhere]];
                    }
                    
                    
                    
                    NSString *updateConditionStr = [NSString stringWithFormat:@"%@",[conditonArr componentsJoinedByString:@","]];                    
                    //NSLog(@"%@",conditionStr);
                    
                    if ([[contentDic objectForKey:@"intStatus"] intValue] == 1) {
                        
                        
                        if ([DBUpdate checkWithTableName:[tableArr objectAtIndex:i] condition:condition]) {
                            
                            
                            [DBUpdate update:[tableArr objectAtIndex:i] values:updateConditionStr condition:condition];
                            
                        }else {
                            //NSLog(@"%@====%@",conlumnName,values);
                            
                            NSMutableArray *conlumn_deleteState_Arr = [[NSMutableArray alloc] init];
                            NSMutableArray *values_deleteState_Arr = [[NSMutableArray alloc] init];
                            
                            for (int y = 0; y<conlumnArr.count; y++) {
                                
                                
                                if (![[conlumnArr objectAtIndex:y] isEqualToString:@"intStatus"]) {
                                    
                                    [conlumn_deleteState_Arr addObject:[conlumnArr objectAtIndex:y]];
                                    // [values_deleteState_Arr addObject:[NSString stringWithFormat:@"'%@'",[valuesArr objectAtIndex:y]]];
                                    
                                    
                                    if ([[valuesArr objectAtIndex:y] isKindOfClass:[NSString class]]) {
                                        [values_deleteState_Arr addObject:[NSString stringWithFormat:@"'%@'",[valuesArr objectAtIndex:y]]];
                                    }else {
                                        
                                        
                                        [values_deleteState_Arr addObject:@"''"];
                                    }
                                    
                                }
                            }
                            
                            NSString *conlumnName = [NSString stringWithString:[conlumn_deleteState_Arr componentsJoinedByString:@","]];
                            NSString *values = [NSString stringWithString:[values_deleteState_Arr componentsJoinedByString:@","]];
                                                        
                            [DBUpdate insert:[tableArr objectAtIndex:i] columnName:conlumnName values:values];
                        }
                        
                    }else if ([[contentDic objectForKey:@"intStatus"] intValue] == 2) {
                        
                        [DBUpdate deleWithTableName:[tableArr objectAtIndex:i] condition:condition];
                    }
                    
                }
            }
        }
    }
}

- (void)didRetrieveLatestDataFinishedError{
    [self hideAlertView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    [DBUpdate update:@"tblConfig" values:[NSString stringWithFormat:@"dtLastUpdate='%@'",dateStr]];
}

#pragma mark -
#pragma mark UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tView {
	return 3; // Section 4 is hidden!!
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (IS_IPAD) {
        return 52.0f;
    }
    return 26.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    int height = 26.0f;
    int fontSize = 12;
    if (IS_IPAD) {
        height = 52.0f;
        fontSize = 24;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.view.frame.size.width, height)];
    if (section == 0) {
        [headerTitleLabel setText:@"PUSH NOTIFICATION - TRAFFIC UPDATE"];
    } else if (section == 1) {
        [headerTitleLabel setText:@"DEFAULT NAVIGATION APP"];
    }
    /*
    if (section == 0) {
        [headerTitleLabel setText:@"PUSH NOTIFICATION - TRAFFIC UPDATE"];
    } else if (section == 1) {
        [headerTitleLabel setText:@"DATA SYNC"];
    } else if (section == 2) {
        [headerTitleLabel setText:@"DEFAULT NAVIGATION APP"];
    }  else if (section == 3) {
        [headerTitleLabel setText:@"PLUSMILES MEMBER"];
    }
     */
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setTextColor:[UIColor grayColor]];
    [headerTitleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    
    [headerView addSubview:headerTitleLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [highwayArr count];
    } else if (section == 1) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 2) {
        return 86.0f;
    }
    if (IS_IPAD) {
        return 68.0f;
    }
    return 34.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    int section = [indexPath section];
    
    int fontSize = 11;
    if (IS_IPAD) {
        fontSize = 20;
    }
    if (section == 0) {
        UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"Highway-cell"];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Highway-cell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
        }
        
        [[cell textLabel] setText:[[highwayArr objectAtIndex:row] objectForKey:@"strName"]];
        
        UISwitch *highwaySwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
        [highwaySwitch addTarget: self action: @selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [highwaySwitch setTag:row];
        
        NSString *idHighway = [[highwayArr objectAtIndex:row] objectForKey:@"idHighway"];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"Setting.%@",idHighway]]) {
            [highwaySwitch setOn:YES];
        } else {
            [highwaySwitch setOn:NO];
        }
        
        [cell setAccessoryView:highwaySwitch];
        return cell;

    }else if (section == 1) {
        if (row == 0) {
            UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"GoogleMaps-cell"];
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoogleMaps-cell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
                [[cell textLabel] setText:@"GOOGLE MAPS"];
                
                GmapSwitchView = [[UISwitch alloc] initWithFrame: CGRectZero];
                [GmapSwitchView addTarget: self action: @selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [GmapSwitchView setTag:4001];
                
                [cell setAccessoryView:GmapSwitchView];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Setting.Map"] isEqualToString:@"Google"]) {
                [GmapSwitchView setOn:YES];
            } else {
                [GmapSwitchView setOn:NO];
            }
            
            return cell;
            
        } else if (row == 1) {
            UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"Waze-cell"];
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Waze-cell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
                [[cell textLabel] setText:@"WAZE"];
                
                WazeSwitchView = [[UISwitch alloc] initWithFrame: CGRectZero];
                [WazeSwitchView addTarget: self action: @selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [WazeSwitchView setTag:4002];
                
                [cell setAccessoryView:WazeSwitchView];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Setting.Map"] isEqualToString:@"Waze"]) {
                [WazeSwitchView setOn:YES];
            } else {
                [WazeSwitchView setOn:NO];
            }
            
            return cell;
        }
        
    }
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"empty-cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty-cell"];
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -
#pragma mark KeyboardNotification
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    NSInteger lastSection = [_tableView numberOfSections] - 1;
    NSInteger lastRow = [_tableView numberOfRowsInSection:lastSection] - 1;
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [_tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
}

#pragma mark - CreatLocationManager

- (void)CreatLocationManager{
    
    CLLocationManager *temp = [[CLLocationManager alloc] init];
    self.locManager = temp;
    
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    [self.locManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (!isGetLoc) {
        
        isGetLoc = YES;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        //CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
        
        self.currentLocation = location;
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    // NSLog(@"Location manager error: %@", [error description]);
    isGetLoc = NO;
    [manager stopUpdatingLocation];
}


- (void)setSettingMode:(BOOL)mode
{
    isSettingMode = mode;
}
@end
