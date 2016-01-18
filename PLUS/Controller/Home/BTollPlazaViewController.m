//
//  BTollPlazaViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BTollPlazaViewController.h"
#import "TblTollPlazaEntry.h"
#import "TblHighwayEntry.h"
#import "BInformationViewController.h"
#import "Constants.h"
@interface BTollPlazaViewController ()

@end

@implementation BTollPlazaViewController
@synthesize tableView;

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
    titleLabel.text = @"Toll Plaza";

    //[self creatAnnouncements];
    
    [self creatTollPlazaData];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"TollPlaza Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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

#pragma mark -  UI

- (void)creatUI{
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    //  NSLog(@"tollPlazaArray===%@",tollPlazaArray);
    int padding = 10;
    int margin = 0;
    if (deviceType == DEVICE_TYPE_IPAD) {
        padding = 30;
        margin = 10;
    }
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, TOP_HEADER_HEIGHT+statusBarHeight+padding, self.view.frame.size.width-margin*2, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-padding) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - Data

- (void)creatTollPlazaData{
    
    
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblTollPlazaEntry searchIdHighwayFromTollPlaza]];
    // NSLog(@"highWayArray:%@",highWayArray);
    highWayDetailArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    tollPlazaArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    for (int i = 0; i<highWayArray.count; i++) {
        
        NSString *highWayStr = [highWayArray objectAtIndex:i] ;
        [highWayDetailArray addObject:[TblHighwayEntry searchHighwayByIdHighway:highWayStr]];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblTollPlazaEntry searchTollPlazaByIdHighway:highWayStr]];
        [tollPlazaArray addObject:array];
    }
    // NSLog(@"tollPlazaDic===%@",tollPlazaDic);
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    int number = 0;
    
    for (int i = 0; i<highWayArray.count; i++) {
        
        if ([[tollPlazaArray objectAtIndex:i] count] > 0) {
            number ++;
        }
    }
    // NSLog(@"number;%d",number);
    return number;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"[[tollPlazaArray objectAtIndex:section] count]:%d",[[tollPlazaArray objectAtIndex:section] count]);
    
    return [[tollPlazaArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int fontSize = 15;
    if (deviceType == DEVICE_TYPE_IPAD) {
        fontSize = 30;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    NSString *strName = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
    //NSLog(@"strName:%@",strName);
    
    cell.textLabel.text = strName;
    //cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:fontSize];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString *decLocation = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
    //cell.detailTextLabel.textColor = [UIColor colorWithRed:76.0/255 green:209.0/255 blue:255.0/255 alpha:1];
    //cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:fontSize];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BInformationViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
    //    tollPlaza.infoDic = [[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    tollPlaza.highWayStr = [[highWayDetailArray objectAtIndex:indexPath.section] objectForKey:@"strName"];
    //    tollPlaza.whichMOkuai = titleStr;
    tollPlaza.strName = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
    tollPlaza.strDirection = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
    tollPlaza.decLocation = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
    tollPlaza.intParentType = 3;
    tollPlaza.idParent = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
    [self.navigationController pushViewController:tollPlaza animated:YES];
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        return 90;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        return 80;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    int height = 40;
    int padding1 = 10;
    int padding2 = 4;
    int fontSize = 15;
    if (deviceType == DEVICE_TYPE_IPAD) {
        height = 80;
        padding1 = 10;
        padding2 = 8;
        fontSize = 30;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding1, 0, self.tableView.frame.size.width - padding1*2, height - padding2)];
    //label.backgroundColor = [UIColor whiteColor];
    //label.textColor = [UIColor colorWithRed:79.0/255 green:221.0/255 blue:156.0/255 alpha:1];
    //label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor colorWithRed:97/255.0 green:113/255.0 blue:129/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.borderColor = [[UIColor colorWithRed:79.0/255 green:221.0/255 blue:156.0/255 alpha:1] CGColor];
    label.layer.borderWidth = 1.0;
    label.text = [NSString stringWithFormat:@"%@",[[highWayDetailArray objectAtIndex:section] objectForKey:@"strName"]];
    [view addSubview:label];
    
    return view;
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
