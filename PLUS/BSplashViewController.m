//
//  BSplashViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BSplashViewController.h"
#import "TblConfig.h"
#import "DBUpdate.h"

@interface BSplashViewController ()

@end

@implementation BSplashViewController
@synthesize currentLocation;
@synthesize locManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Setting.SyncData"];
    device = [UIDevice currentDevice];
    if ([device.model isEqualToString:@"iPad"]) {
        deviceType = 1;
    }else {
        deviceType = 0;
    }
    strOS = [NSString stringWithFormat:@"IOS %@",device.systemVersion];
    strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    
    [self CreatLocationManager];
    
    [self creatUI];
    
    [self retrieveTableConfig];

    /*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"PLUS" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [player setControlStyle:MPMovieControlStyleNone];
    [player setFullscreen:TRUE];
    player.view.frame = self.view.frame;
    [self.view addSubview:player.view];
    [player play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:player];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)playbackStateChanged {
    
    [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackDidFinishNotification];
    
    [player.view removeFromSuperview];
    
    [self creatUI];
    
    [self retrieveTableConfig];
    //[self retrieveLatestData];
    
    //[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(retrieveAnnouncement) userInfo:nil repeats:YES];
}

#pragma mark - UI
- (void)creatUI{
    
    //    NSString *filePath = [UIImage imageNamed:@"Default.png"];
    //    if (self.view.frame.size.height > 480) {
    //        filePath = [[NSBundle mainBundle] pathForResource:@"Default-568h" ofType:@"png"];
    //    }
    //    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageNamed:@"Splash.png"];
    if (self.view.frame.size.height > 480) {
        image = [UIImage imageNamed:@"Splash-568h.png"];
    }
    
    UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageViewBG.image = image;
    [self.view addSubview:imageViewBG];
    
    float heightAdd = 0;
    
    if (self.view.frame.size.height>480) {
        heightAdd = 40;
    }
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(0, 0, 40, 40);
    
    
    activity.center = CGPointMake(160, 235+heightAdd);
    [self.view addSubview:activity];
    [activity startAnimating];
    
    loadingLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, 280+heightAdd, 320, 20)];
    loadingLabel.text = @"Loading...";
    loadingLabel.font = [UIFont systemFontOfSize:18];
    //    loadingLabel.textColor = [UIColor colorWithRed:0 green:.35 blue:.62 alpha:1];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loadingLabel];
    
    UILabel *versionLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, 310+heightAdd, self.view.frame.size.width, 20)];
    versionLabel.text = [NSString stringWithFormat:@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
}

#pragma mark  - HttpData

- (void)retrieveAnnouncement{
    
    if ([CheckNetwork connectedToNetwork]) {
        NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveAnnouncementDataFinished:);
        httpData.didFailed = @selector(didRetrieveAnnouncementDataFinishedError);
        [httpData retrieveAnnouncement:dtLastUpdate strUniqueId:strUniqueId];
    }
}

- (void)didRetrieveAnnouncementDataFinished:(id)data{
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        
        
        if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"] count] != 0) {
            
            NSDictionary *dic = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"];
            
            NSArray *tableArr = [NSArray arrayWithArray:[dic allKeys]];
            
            for (int i = 0; i<tableArr.count; i++) {
                
                NSArray *contentArr = [NSArray arrayWithArray:[dic objectForKey:[tableArr objectAtIndex:i]]];//
                
                for (int j = 0; j< contentArr.count; j++) {
                    
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
                                
                                NSString *escapedStr = [[valuesArr objectAtIndex:k] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                //[values_deleteState_Arr addObject:[NSString stringWithFormat:@"'%@'",escapedStr]];
                                
                                [conditonArr addObject:[NSString stringWithFormat:@"%@='%@'",[conlumnArr objectAtIndex:k],escapedStr]];
                            }else {
                                
                                
                                [conditonArr addObject:[NSString stringWithFormat:@"%@ = ''",[conlumnArr objectAtIndex:k]]];
                            }
                            
                        }
                    }
                    
                    NSString *conlumnWhere = [NSString stringWithFormat:@"id%@",@"Announcement"];
                    
                    if ([conlumnWhere isEqualToString:@"idPetrolStation"]) {
                        conlumnWhere = @"idPetrol";
                    }else if ([conlumnWhere isEqualToString:@"idAnnouncements"]) {
                        conlumnWhere = @"idAnnouncement";
                    }
                    
                    NSString *condition = [NSString stringWithFormat:@"%@='%@'",conlumnWhere,[contentDic objectForKey:conlumnWhere]];
                    
                    NSString *updateConditionStr = [NSString stringWithFormat:@"%@",[conditonArr componentsJoinedByString:@","]];
                    
                    if ([[contentDic objectForKey:@"intStatus"] intValue] == 1) {
                        
                        
                        if ([DBUpdate checkWithTableName:[tableArr objectAtIndex:i] condition:condition]) {
                            
                            [DBUpdate update:[tableArr objectAtIndex:i] values:updateConditionStr condition:condition];
                            
                        }else {
                            
                            NSMutableArray *conlumn_deleteState_Arr = [[NSMutableArray alloc] init];
                            NSMutableArray *values_deleteState_Arr = [[NSMutableArray alloc] init];
                            
                            for (int y = 0; y<conlumnArr.count; y++) {
                                
                                
                                if (![[conlumnArr objectAtIndex:y] isEqualToString:@"intStatus"]) {
                                    
                                    [conlumn_deleteState_Arr addObject:[conlumnArr objectAtIndex:y]];
                                    
                                    if ([[valuesArr objectAtIndex:y] isKindOfClass:[NSString class]]) {
                                        
                                        //[values_deleteState_Arr addObject:[NSString stringWithFormat:@"'%@'",[valuesArr objectAtIndex:y]]];
                                        
                                        NSString *escapedStr = [[valuesArr objectAtIndex:y] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                        [values_deleteState_Arr addObject:[NSString stringWithFormat:@"'%@'",escapedStr]];
                                    }else {
                                        
                                        
                                        [values_deleteState_Arr addObject:@"''"];
                                    }
                                    
                                }
                            }
                            
                            NSString *conlumnName = [NSString stringWithString:[conlumn_deleteState_Arr componentsJoinedByString:@","]];
                            NSString *values = [NSString stringWithString:[values_deleteState_Arr componentsJoinedByString:@","]];
                            NSLog(@"Values=%@", values);
                            [DBUpdate insert:[tableArr objectAtIndex:i] columnName:conlumnName values:values];
                        }
                        
                    }else if ([[contentDic objectForKey:@"intStatus"] intValue] == 2) {
                        
                        [DBUpdate deleWithTableName:[tableArr objectAtIndex:i] condition:condition];
                    }

                }
            }
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAnnouncement" object:nil];
    }
}

- (void)didRetrieveAnnouncementDataFinishedError{
    
}

- (void)retrieveTableConfig {
    //NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
    
    HttpData *httpData = [[HttpData alloc] init];
    httpData.dele = self;
    httpData.didFinished = @selector(didUpdateTableConfigFinished:);
    httpData.didFailed = @selector(didUpdateTableConfigFailed);
    [httpData retrieveTableConfig:dtLastUpdate strUniqueId:strUniqueId];
}

- (void)didUpdateTableConfigFinished:(id)data{
    NSLog(@"didRetrieveTableConfig=====%@",[data JSONValue]);
    
    if ([[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSDictionary *tblConfig = [[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Messages"] objectForKey:@"tblConfig"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[tblConfig objectForKey:@"GoogleMapAPIKey"] forKey:@"Setting.GoogleMapAPIKey"];
        [userDefaults setObject:[tblConfig objectForKey:@"intAnnounceFreq"] forKey:@"Setting.AnnounceFreq"];
        [userDefaults setObject:[tblConfig objectForKey:@"intTimeout"] forKey:@"Setting.Timeout"];
        [userDefaults synchronize];
        
    }
    [self goToTabbar];
}

- (void)didUpdateTableConfigFailed {
    
}

- (void)retrieveLatestData{
    
    [self performSelector:@selector(goToTabbar) withObject:nil afterDelay:1.0];
    
    /*
    if ([CheckNetwork connectedToNetwork]){
        
        NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveLatestDataFinished:);
        httpData.didFailed = @selector(didRetrieveLatestDataFinishedError);
        [httpData retrieveLatestData:dtLastUpdate strUniqueId:strUniqueId strLastKnownLoc:@""];

    }else{
        
        //[self performSelector:@selector(goToTabbar) withObject:nil afterDelay:3.0];
    }
    */
}

- (void)goToTabbar{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didRetrieveLatestDataFinished:(id)data{
    
    
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
            //            NSLog(@"%@",tableArr);
            
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
    
    [self goToTabbar];
}

- (void)didRetrieveLatestDataFinishedError{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    [DBUpdate update:@"tblConfig" values:[NSString stringWithFormat:@"dtLastUpdate='%@'",dateStr]];
    
    [self goToTabbar];
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

@end
