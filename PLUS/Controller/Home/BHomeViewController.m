//
//  BHomeViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BHomeViewController.h"
#import "BTollPlazaViewController.h"
#import "BLiveTrafficViewController.h"
#import "Constants.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BHomeViewController ()

@end

@implementation BHomeViewController
@synthesize  adArray;

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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstall"]) {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"agreementViewController"]  animated:NO];
    }else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"]  animated:NO completion:nil];
    }
    
    
    titleLabel.text = @"Home";
    [self creatAnnouncements];
    
    float buttonSize = 16.0;
    if (deviceType == DEVICE_TYPE_IPAD) {
        buttonSize = 32.0;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonSize, buttonSize)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //[button setTitle:@"Menu" forState:UIControlStateNormal];
    [navigationBar setLeftButton:button];
    [backButton setHidden:YES];
    
    heightIphone5Style = 0;
    heightAdIphone5Style = 0;
    
    if (self.view.frame.size.height > 480) {
        heightAdIphone5Style = 88;
    }
    
    [self creatUI];
    [self retrieveAd];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(retrieveAnnouncement) userInfo:nil repeats:YES];
}
- (void) didDismissagreementModal
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"]  animated:NO completion:nil];
}
#pragma mark  - HttpData

- (void)retrieveAnnouncement{
    
    if ([CheckNetwork connectedToNetwork]) {
        NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
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
                                [conditonArr addObject:[NSString stringWithFormat:@"%@='%@'",[conlumnArr objectAtIndex:k],[valuesArr objectAtIndex:k]]];
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
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAnnouncement" object:nil];
    }
}

- (void)didRetrieveAnnouncementDataFinishedError{
    
}

#pragma mark  - HttpData
- (void)retrieveAd{
    
    UIDevice *device = [UIDevice currentDevice];
    //NSLog(@"model:%@ +++++sysmtem:%@",device.model,device.systemVersion);
    
    NSString *strOS = [NSString stringWithFormat:@"IOS %@",device.systemVersion];
    NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    
    HttpData *httpData = [[HttpData alloc] init];
    httpData.dele = self;
    httpData.didFinished = @selector(didRetrieveAdFinished:);
    httpData.didFailed = @selector(didFailed);
    [httpData retrieveAd:deviceType strUniqueId:strUniqueId strOS:strOS];
}

- (void)didRetrieveAdFinished:(id)data{
    
    
    
    if ([[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[[[data JSONValue]  objectForKey:@"result"] objectForKey:@"Advert"]];
        self.adArray = arr;
        
        if ([self.adArray count] > 0) {
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeAdBtn) userInfo:nil repeats:YES];
        }
    }
}

- (void)didFailed{
    
}

- (void)creatAdView{
    
    btnAd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAd.frame = CGRectMake(0, self.view.frame.size.height-AD_HEIGHT, self.view.frame.size.width, AD_HEIGHT);
    [btnAd setBackgroundColor:[UIColor clearColor]];
    [btnAd addTarget:self action:@selector(goToAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAd];
    
    btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-AD_HEIGHT, self.view.frame.size.width, AD_HEIGHT)];
    btnImageView.backgroundColor = [UIColor clearColor];
    btnImageView.userInteractionEnabled = NO;
    [self.view addSubview:btnImageView];
    
}

- (void)changeAdBtn{
    
    adIndex ++;
    
    if (adIndex > self.adArray.count-1) {
        adIndex = 0;
    }
    
    if (btnAd) {
        NSString *imgStr = [[[self.adArray objectAtIndex:adIndex] objectForKey:@"img"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [btnImageView setImageWithURL:[NSURL URLWithString:imgStr]];
    }
}
- (void)goToAd{
    
    if ([self.adArray count] > 0) {
        NSURL *url = [NSURL URLWithString:[[self.adArray objectAtIndex:adIndex] objectForKey:@"LinkURL"]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void) viewWillAppear:(BOOL)animated{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Home"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        //[self performSegueWithIdentifier:@"go_accept" sender:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        
        //[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"] animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat padding = 30;
    CGFloat top = 15;
    CGFloat rowHeight = 60;
    CGFloat buttonPadding = 10;
    NSInteger fontSize = 12;
    CGSize labelSize = CGSizeMake(100, 10);
    if (heightAdIphone5Style > 0) {
        rowHeight += 12;
        buttonPadding += 10;
        fontSize = 14;
        labelSize = CGSizeMake(100, 13);
    }
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        padding = 60;
        top = 30;
        rowHeight = 100;
        buttonPadding = 20;
        fontSize = 30;
        labelSize = CGSizeMake(200, 20);
        if (heightAdIphone5Style > 0) {
            rowHeight += 24;
            buttonPadding += 20;
            fontSize = 32;
            labelSize = CGSizeMake(250, 30);
        }
    }
    
    for (int i = 0; i <8; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat bx = self.view.frame.size.width/2  - ((i+1)%2)*rowHeight;
        
        if (i%2 == 0)
            bx -= padding;
        else
            bx += padding;
        
        btn.frame = CGRectMake(bx, (i/2)*(rowHeight+labelSize.height)+top + (i/2)*labelSize.height, rowHeight, rowHeight);
        
        btn.tag = i;
        
        UILabel *label = [[UILabel alloc] init];
        
        [label setFont:[UIFont systemFontOfSize:fontSize]];
        
        //[label setTextColor:[UIColor colorWithRed:(96/255.f) green:(96/255.f) blue:(96/255.f) alpha:1]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        //label.backgroundColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        if (i == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"home_tollplaza.png"] forState:UIControlStateNormal];
            label.text = @"Toll Plaza";
        }else if (i == 1){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_rsa.png"] forState:UIControlStateNormal];
            label.text = @"RSA & Lay-by";
        }else if (i == 2){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_livetraffic.png"] forState:UIControlStateNormal];
            label.text = @"Live Traffic";
        }else if (i == 3){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_facilities.png"] forState:UIControlStateNormal];
            label.text = @"Facilities";
        }else if (i == 4){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_livefeed.png"] forState:UIControlStateNormal];
            label.text = @"Live Feed";
        }else if (i == 5){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_findme.png"] forState:UIControlStateNormal];
            label.text = @"Find Me";
        }else if (i == 6){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_kembaraplus.png"] forState:UIControlStateNormal];
            label.text = @"Kembara Plus";
        }else if (i == 7){
            [btn setBackgroundImage:[UIImage imageNamed:@"home_plusmiles.png"] forState:UIControlStateNormal];
            label.text = @"PLUSMiles";
        }
        
        //NSAttributedString *str = [[NSAttributedString alloc] initWithString:label.text];
        //labelSize = [str boundingRectWithSize: label.frame.size options: NSStringDrawingUsesLineFragmentOrigin context: nil].size;
        
        //CGFloat lx = bx + (rowHeight - labelSize.width)/2;
        CGFloat lx = btn.center.x - labelSize.width/2;
        label.frame = CGRectMake(lx, (i/2)*(rowHeight+labelSize.height)+2 + rowHeight + (i/2)*labelSize.height + top, labelSize.width, labelSize.height);
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake((i%2)*160, (i/2)*rowHeight, 160, rowHeight)];
        //        [background setImage:[UIImage imageNamed:@"home_bg.png"]];
        //        [cell.contentView addSubview:background];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:btn];
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)creatUI{
    
    UIImageView *background1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+heightIphone5Style + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight + heightAdIphone5Style)];
    [background1 setImage:[UIImage imageNamed:@"menu_bg.png"]];
    [self.view addSubview:background1];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+heightIphone5Style + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight + heightAdIphone5Style)];
    [background setImage:[UIImage imageNamed:@"home_background.png"]];
    background.alpha = 0.8;
    [self.view addSubview:background];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+heightIphone5Style + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight - 50 + heightAdIphone5Style ) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    [self creatAdView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        //return 337 + heightAdIphone5Style + statusBarHeight;
        return self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight - 50 + heightAdIphone5Style;
    }else {
        return 0;
    }
}

#pragma mark - UIButton

- (void)click:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tollplazaViewController"] animated:YES];
            
        }
            break;
            
        case 1:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rsaViewController"] animated:YES];
        }
            break;
        case 2:
        {
            BLiveTrafficViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"livetrafficViewController"];
            [vc setHighwayIndex:0];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"facilitiesViewController"] animated:YES];
        }
            break;
        case 4:
        {
            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"livefeedViewController"] animated:YES];
        }
            break;
        case 5:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"findmeViewController"] animated:YES];
        }
            break;
        case 6:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"kembaraViewController"] animated:YES];
        }
            break;
        case 7:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"plusmilesViewController"] animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
