//
//  BNotificationViewController.m
//  PLUS
//
//  Created by Ben Folds on 10/14/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BNotificationViewController.h"
#import "TblNotification.h"
#import "BLiveTrafficViewController.h"
#import "BSettingViewController.h"
#import "DBUpdate.h"
#import "Constants.h"

@interface BNotificationViewController ()

@end

@implementation BNotificationViewController

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
    
    titleLabel.text = @"Notifications";
    
    float buttonSize = 16.0;
    if (IS_IPAD) {
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
    
    [self createNotificationArray];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [table reloadData];
}
- (void)createNotificationArray
{
    notificationArray = [[NSMutableArray alloc] initWithCapacity:0];
    notificationArray = [TblNotification searchAllNotification];
}
- (void)createUI
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    [backButton setHidden:YES];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-60) style:UITableViewStylePlain];
    [table setScrollEnabled:YES];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-55, self.view.frame.size.width-20, 45)];
    [settingButton setTitle:@"Setting" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(goNotificationSetting) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:settingButton];
}

- (void)goNotificationSetting
{
    BSettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
    [vc setSettingMode:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [notificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    int padding = 10;
    int labelHeight = 20;
    int cellHeight = 50;
    int fontSize1 = 17;
    int fontSize2 = 14;
    if (IS_IPAD) {
        padding = 20;
        labelHeight = 40;
        cellHeight = 100;
        fontSize1 = 30;
        fontSize2 = 25;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *dic = [notificationArray objectAtIndex:indexPath.row];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, self.view.frame.size.width-padding*2, labelHeight)];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    [messageLabel setFont:[UIFont boldSystemFontOfSize:fontSize1]];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setText:[dic objectForKey:@"strMessage"]];
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-padding*2, cellHeight);
    CGSize expectedLabelSize = [[dic objectForKey:@"strMessage"] sizeWithFont:messageLabel.font constrainedToSize:maximumLabelSize lineBreakMode:messageLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = messageLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    messageLabel.frame = newFrame;
    
    [cell.contentView addSubview:messageLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, messageLabel.frame.origin.y+messageLabel.frame.size.height, self.view.frame.size.width-padding*2, labelHeight)];
    [dateLabel setFont:[UIFont systemFontOfSize:fontSize2]];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTag:333];
    [cell.contentView addSubview:dateLabel];
    
    
    
    [dateLabel setText:[dic objectForKey:@"dtReceived"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BLiveTrafficViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"livetrafficViewController"];
    [vc setHighwayIndex:[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"idHighway"] integerValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (IS_IPAD) {
        return  160;
    }
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        NSDictionary *dic = [notificationArray objectAtIndex:indexPath.row];
        NSInteger idHighway = [[dic objectForKey:@"idHighway"] integerValue];
        NSInteger idLiveTraffic = [[dic objectForKey:@"idLiveTraffic"] integerValue];
        NSString *strMessage = [dic objectForKey:@"strMessage"];
        NSString *condition = [NSString stringWithFormat:@"idHighway='%ld' and idLiveTraffic='%ld' and strMessage='%@'", (long)idHighway, (long)idLiveTraffic, strMessage ];
        [DBUpdate deleWithTableName:@"tblNotification" condition:condition];
        [notificationArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

@end
