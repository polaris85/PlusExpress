//
//  BUpdateViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BUpdateViewController.h"
#import "BUpdateTableViewCell.h"
#import "DBUpdate.h"
#import "JSONKit.h"
#import "Constants.h"
@interface BUpdateViewController ()

@end

@implementation BUpdateViewController

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
    titleLabel.text = @"Update";
    updateDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentUpdateIndex = -1;
    [self creatUI];
    
    [self loadMobileUpdateData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (void)loadMobileUpdateData{
    UIDevice *device = [UIDevice currentDevice];
    int deviceType;
    if ([device.model isEqualToString:@"iPad"]) {
        deviceType = 1;
    }else {
        deviceType = 0;
    }
    if ([CheckNetwork connectedToNetwork]) {
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveMobileUpdateDataFinished:);
        httpData.didFailed = @selector(didRetrieveMobileUpdateDataFinishedError);
        
        [self creatHUD];
        [httpData retrieveMobileUpdate:deviceType];
    }
}

- (void)didRetrieveMobileUpdateDataFinished:(id)data {
    [self hideHud];
    
    NSLog(@"Data=%@", data);
    NSLog(@"Result=%@", [[data JSONValue] objectForKey:@"result"]);
    NSLog(@"Status=%@", [[[data JSONValue] objectForKey:@"result"] objectForKey:@"intStatus"]);
    
    if([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"intStatus"] intValue] == 1){
        //updateDataArray = [NSMutableArray arrayWithArray:[[[[data JSONValue] objectForKey:@"result"] objectForKey:@"strUpdateRecords"] allValues]];
        NSArray *dataArray = [[[[[data JSONValue] objectForKey:@"result"] objectForKey:@"strUpdateRecords"] JSONValue] allValues];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *updateIdArrays = [defaults objectForKey:@"PLUS.UpdateID"];
        if (updateIdArrays) {
            
            //int mobileUpdateId = [[[updateDataArray objectAtIndex:currentUpdateIndex] objectForKey:@"idmobileupd"] integerValue];
            //[updateIdArrays addObject:[NSNumber numberWithInt: mobileUpdateId]];
            //[defaults setObject:updateIdArrays forKey:@"PLUS.UpdateID"];
            for (int i=0; i<dataArray.count; i++) {
                if(![updateIdArrays containsObject:[[dataArray objectAtIndex:i] objectForKey:@"idmobileupd"]])
                    [updateDataArray addObject:[dataArray objectAtIndex:i]];
            }
        }else{
            updateDataArray = [NSMutableArray arrayWithArray:dataArray];
        }
        NSLog(@"Count=%lu", (unsigned long)updateDataArray.count);
        [table reloadData];
    }
}

- (void)didRetrieveMobileUpdateDataFinishedError {
    [self hideHud];
    
    
}

- (void)getUpdateContentData:(NSInteger) idmobileupd{
    
    if ([CheckNetwork connectedToNetwork]) {
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didGetUpdateContentDataFinished:);
        httpData.didFailed = @selector(didGetUpdateContentDataFinishedError);
        
        [self creatHUD];
        [httpData getUpdateContent:idmobileupd];
    }
}

- (void)didGetUpdateContentDataFinished:(id)data {
    [self hideHud];
    
    if([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"intStatus"] intValue] == 1){
        
        
        NSString *content = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"strContent"];
        
        NSDictionary *dic = [content JSONValue];
        NSArray *tableArr = [NSArray arrayWithArray:[dic allKeys]];
        
        for (int i = 0; i<tableArr.count; i++) {
            
            NSArray *contentArr = [NSArray arrayWithArray:[dic objectForKey:[tableArr objectAtIndex:i]]];//
            
            for (int j = 0; j< contentArr.count; j++) {
                //NSDictionary *contentDic1 = [NSDictionary dictionaryWithDictionary:[contentArr objectAtIndex:j]];
                
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
                //NSString *conlumnWhere = [conlumnArr objectAtIndex:0] ;
                
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
                    
                    //condition = [NSString stringWithFormat:@"%@='%@'",conlumnWhere,[contentDic objectForKey:conlumnWhere]];
                    NSArray *keys = [[NSArray alloc] init];
                    keys = [contentDic allKeys];
                    for (NSInteger i = 0; i < keys.count; i++)
                    {
                        NSString *key = [keys objectAtIndex: i];
                        if( [key caseInsensitiveCompare:conlumnWhere] == NSOrderedSame ) {
                            condition = [NSString stringWithFormat:@"%@='%@'",conlumnWhere,[contentDic objectForKey:key]];
                            break;
                        }
                    }
                }
                
                
                NSString *updateConditionStr = [NSString stringWithFormat:@"%@",[conditonArr componentsJoinedByString:@","]];
                
                //NSLog(@"%@",updateConditionStr);
                
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *updateIdArrays = [[defaults objectForKey:@"PLUS.UpdateID"] mutableCopy];
    if (!updateIdArrays) {
        updateIdArrays = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [updateIdArrays addObject:[[updateDataArray objectAtIndex:currentUpdateIndex] objectForKey:@"idmobileupd"]];
    [defaults setObject:updateIdArrays forKey:@"PLUS.UpdateID"];
    
    [updateDataArray removeObjectAtIndex:currentUpdateIndex];
    currentUpdateIndex = -1;
    
    [table reloadData];
}

- (void)didGetUpdateContentDataFinishedError {
    [self hideHud];
    
}

#pragma mark -  UI

- (void)creatUI{
    
    int menuButtonSize = 16.0;
    if(IS_IPAD)
        menuButtonSize = 32;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, menuButtonSize, menuButtonSize)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //navigationBar.leftButton = button;
    [navigationBar setLeftButton:button];
    
    [backButton setHidden:YES];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - UIButtonClick
- (void)click:(UIButton *)sender{
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //return highWayArray.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return updateDataArray.count;
}

- (BUpdateTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    BUpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int packageImageSize = 64;
    int titleLabelFont = 14;
    int descriptionLabelFont = 11;
    int deployImageSize = 36;
    int padding = 10;
    int labelHeight = 20;
    int packLabelWidth = 50;
    if (IS_IPAD) {
        packageImageSize = 128;
        titleLabelFont = 25;
        deployImageSize = 72;
        descriptionLabelFont = 20;
        padding = 20;
        labelHeight = 40;
        packLabelWidth = 100;
    }
    cell.titleLabel.frame = CGRectMake(padding + packageImageSize + padding, padding*2, tableView.frame.size.width - packageImageSize - deployImageSize - padding*4, labelHeight);
    cell.label2.frame = CGRectMake(padding + packageImageSize + padding, padding*2 + labelHeight, packLabelWidth, labelHeight);
    cell.packIdLabel.frame = CGRectMake(padding + packageImageSize + padding + packLabelWidth, padding*2 + labelHeight, packLabelWidth, labelHeight);
    cell.descriptionLabel.frame = CGRectMake(padding, padding+packageImageSize, tableView.frame.size.width-padding*2, labelHeight);
    cell.updateButton.frame = CGRectMake(tableView.frame.size.width - deployImageSize - padding, padding*2, deployImageSize, deployImageSize);
    cell.deployLabel.frame = CGRectMake(tableView.frame.size.width - deployImageSize - padding, padding+deployImageSize, deployImageSize, deployImageSize);
    
    NSLog(@"Title=%@",[[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"strtitle"]);
    //cell.fixIdLabel.text = [[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"strtitle"];
    cell.titleLabel.text = [[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"strtitle"];
    cell.descriptionLabel.text = [[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"strdescription"];
    cell.packIdLabel.text = [[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"idmobileupd"];
    
    //cell.updateButton.tag = [[[updateDataArray objectAtIndex:indexPath.row] objectForKey:@"idmobileupd"] integerValue];
    cell.updateButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.updateButton addTarget:self
                action:@selector(updatePackage:)
                forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return 200;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(IBAction) updatePackage:(UIButton *)sender
{
    currentUpdateIndex = sender.tag;
    int mobileUpdateId = [[[updateDataArray objectAtIndex:sender.tag] objectForKey:@"idmobileupd"] integerValue];
    
    [self getUpdateContentData:mobileUpdateId];
}
@end
