//
//  BLiveFeedViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/20/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BLiveFeedViewController.h"
#import "BInformationViewController.h"
#import "TblHighwayEntry.h"
#import "TblConfig.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

#import "BLiveFeedTableViewCell.h"
#import "BInformationCCTVDetailViewController.h"
#import "CustomButton.h"
@interface BLiveFeedViewController ()
{
    int backgroundViewHeight;
    int tabHeight;
}
@end

@implementation BLiveFeedViewController

@synthesize tableView;
@synthesize swipeView;

@synthesize request;
@synthesize mapAnnotations;
@synthesize itemsAnnotations;
@synthesize routes;

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
    titleLabel.text = @"Live Feed";
    
    highWayIndex = 0;
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblHighwayEntry searchHighway]];
    
    tempArray = [[NSMutableArray alloc] init];
    markerArray = [[NSMutableArray alloc] init];
    //[self creatAnnouncements];
    btnArray = [[NSMutableArray alloc] initWithCapacity:2];
    segmentIndex = 0;
    [self creatUI];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"LiveFeed Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
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

#pragma mark -  UI

- (void)creatUI{
    
    backgroundViewHeight = 42;
    int padding = 5;
    int dropButtonSize = 24;
    int highwayButtonSize = 32;
    int fontSize = 12;
    int tabFontSize = 13;
    tabHeight = 35;
    
    if (IS_IPAD) {
        backgroundViewHeight = 84;
        padding = 10;
        dropButtonSize = 64;
        highwayButtonSize = 64;
        fontSize = 24;
        tabHeight = 70;
        tabFontSize = 26;
    }
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, backgroundViewHeight)];
    backgroundView.backgroundColor = [UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1];
    [self.view addSubview:backgroundView];
    
    highWayLabel = [[UILabel alloc] init];
    highWayLabel.frame = CGRectMake(padding, padding, self.view.frame.size.width-dropButtonSize-padding, backgroundViewHeight-padding*2);
    [highWayLabel setBackgroundColor:[UIColor whiteColor]];
    if ([highWayArray count] > 0) {
        [highWayLabel setText:[NSString stringWithFormat:@"  %@",[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"strName"]]];
    }
    [highWayLabel setTextColor:[UIColor darkGrayColor]];
    
    [highWayLabel setTextAlignment:NSTextAlignmentLeft];
    highWayLabel.font = [UIFont systemFontOfSize:fontSize];
    [backgroundView addSubview:highWayLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(highWayLabel.frame.origin.x+highWayLabel.frame.size.width-highwayButtonSize-1, 8, 1, backgroundViewHeight-padding*2)];
    line.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:line];
    
    highWayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    highWayBtn.frame = CGRectMake(highWayLabel.frame.origin.x+highWayLabel.frame.size.width-highwayButtonSize, padding, highwayButtonSize, highwayButtonSize);
    [highWayBtn setImage:[UIImage imageNamed:@"dropdown1.png"] forState:UIControlStateNormal];
    [highWayBtn addTarget:self action:@selector(selectHighWay) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:highWayBtn];
    
    UIButton *swipeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    swipeBtn.frame = CGRectMake(highWayLabel.frame.origin.x + highWayLabel.frame.size.width, 9, dropButtonSize, dropButtonSize);
    [swipeBtn setImage:[UIImage imageNamed:@"dropmore.png"] forState:UIControlStateNormal];
    //[dropBtn setImage:[UIImage imageNamed:@"dropIcon-up.png"] forState:UIControlStateSelected];
    [swipeBtn addTarget:self action:@selector(swipePage:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:swipeBtn];
    
    for (int i = 0; i<2; i++) {
        CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2*i, TOP_HEADER_HEIGHT+statusBarHeight+backgroundViewHeight, self.view.frame.size.width/2, tabHeight)];
        btn.tag = i;
        if (i == 0) {
            [btn setButtonColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setButtonColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setTitle:@"Mainline" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:tabFontSize];
            btn.selected = YES;
        }else {
            [btn setButtonColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setButtonColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setTitle:@"Toll Plaza" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:tabFontSize];
        }
        
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btnArray addObject:btn];
    }
    
    swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight + backgroundViewHeight+tabHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight - backgroundViewHeight-tabHeight)];
    swipeView.delegate = self;
    swipeView.dataSource = self;
    
    //[swipeView scrollToPage:1 duration:0.5];
    [self.view addSubview:swipeView];
}

#pragma mark - UIButtonClick
- (void)selectType:(UIButton *)sender{
    
    sender.selected = YES;
    
    if (sender.tag == 0) {
        segmentIndex = 0;
        [[btnArray objectAtIndex:1] setSelected:NO];
        
        [self retrieveLiveUpdate:13];
    }else {
        segmentIndex = 1;
        [[btnArray objectAtIndex:0] setSelected:NO];
        
        [self retrieveTollPlazaCCTV];
    }
    
    //[table reloadData];
}

- (void)setDDListHidden:(BOOL)hidden {
    
    int padding = 5;
    int dropButtonSize = 24;
    int dropDownHeight = 150;
    if (IS_IPAD) {
        backgroundViewHeight = 84;
        padding = 10;
        dropButtonSize = 64;
        dropDownHeight = 300;
    }
    
    
   	NSInteger height = hidden ? 0 : dropDownHeight;
    
    control_ddListHidden_Btn.hidden = hidden;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	//[_ddList.view setFrame:CGRectMake(5, 101, 280, height)];
    [_ddList.view setFrame:CGRectMake(padding, TOP_HEADER_HEIGHT+statusBarHeight+backgroundViewHeight, self.view.frame.size.width-dropButtonSize, height)];
    [self.view bringSubviewToFront:_ddList.view];
	[UIView commitAnimations];
    
    isDDListHidden = !isDDListHidden;
}

- (void)swipePage:(UIButton *)sender{
    if(swipeView.currentItemIndex == 0){
        [swipeView scrollToPage:1 duration:0.5];
    }else{
        [swipeView scrollToPage:0 duration:0.5];
    }
}
- (void)selectHighWay{
    
    if (!_ddList) {
        _ddList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
        _ddList._delegate = self;
        _ddList._resultList = highWayArray;
        [self.view addSubview:_ddList.view];
        
        int padding = 5;
        int dropButtonSize = 24;
        int dropDownHeight = 150;
        if (IS_IPAD) {
            backgroundViewHeight = 84;
            padding = 10;
            dropButtonSize = 64;
            dropDownHeight = 300;
        }
        [_ddList.view setFrame:CGRectMake(padding, TOP_HEADER_HEIGHT+statusBarHeight+backgroundViewHeight, self.view.frame.size.width-dropButtonSize, dropDownHeight)];
    }
    
    [self setDDListHidden:isDDListHidden];
}
#pragma mark  - HttpData

- (void)retrieveTollPlazaCCTV {
    
    [self creatHUD];
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveTollPlazaCCTVDataFinished:);
        httpData.didFailed = @selector(didRetrieveTollPlazaCCTVDataFinishedError);
        
        [self creatHUD];

        [httpData getFacilityCCTV:2 idFacility:@"-1" intDeviceType:deviceType strDeviceId:strUniqueId];
    }
}

- (void)retrieveLiveUpdate:(NSInteger)intType {
    
    if ([CheckNetwork connectedToNetwork]) {
        NSString *dtLastUpdate = [NSString stringWithString:[TblConfig searchDtLastUpdate]];
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveLiveUpdateDataFinished:);
        httpData.didFailed = @selector(didRetrieveLiveUpdateDataFinishedError);
        
        [self creatHUD];
        [httpData retrieveTrafficUpdate:dtLastUpdate strUniqueId:strUniqueId intType:intType];
        
    }
}
- (void)didRetrieveTollPlazaCCTVDataFinished:(id)data {
    [self hideHud];
    NSLog(@"Data=%@", data);
    [tempArray removeAllObjects];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"intStatus"] intValue] == 1) {
        NSArray *contentArr = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"strResults"] JSONValue];
        [tempArray addObjectsFromArray:contentArr];
    }
    
    [self creaRoute];
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
    
    [tableView reloadData];
    
}

- (void)didRetrieveTollPlazaCCTVDataFinishedError {
    [self hideHud];
    
    [self creaRoute];
    
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
    
}
- (void)didRetrieveLiveUpdateDataFinished:(id)data {
    [self hideHud];
    NSLog(@"Data=%@", data);
    [tempArray removeAllObjects];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSArray *contentArr = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"ChangeData"];
        [tempArray addObjectsFromArray:contentArr];
    }
    
    [self creaRoute];
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
    
    [tableView reloadData];
    
}

- (void)didRetrieveLiveUpdateDataFinishedError {
    [self hideHud];
    
    [self creaRoute];
    
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
     
}

- (void)updateTrafficType {
    [heavyVehicleRestrictionView setHidden:TRUE];
    
    // Remove  all pin, exclude point A and point B
    /*
     for (GMSMarker *pin in _mapView.markers) {
     if ([[pin userData] class] != [NSNull null]) {
     if ([[pin userData] objectForKey:@"key"]) {
     continue;
     }
     }
     
     pin.map = nil;
     }
     */
    [self.itemsAnnotations removeAllObjects];
    
    if (liveUpdateArray) {
        [liveUpdateArray removeAllObjects];
        liveUpdateArray = nil;
    }
    
    /*
     NSArray *tempArray = [TblTrafficUpdate searchTblTrafficUpdateByIntType:mapTypeIndex idHighWay:[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"idHighway"]];
     NSLog(@"tempArray : %@", tempArray);
     */
    
    liveUpdateArray = [[NSMutableArray alloc] init];
    NSString *idHighway = [[highWayArray objectAtIndex:highWayIndex] objectForKey:@"idHighway"];
    for (int i = 0; i < [tempArray count]; i++) {
        if ([[[tempArray objectAtIndex:i] objectForKey:@"idHighway"] isEqualToString:idHighway]) {
            [liveUpdateArray addObject:[tempArray objectAtIndex:i]];
        }
    }
    
    if (liveUpdateArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No traffic update available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    /*
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"floLong" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //NSArray *sortedArray;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[liveUpdateArray sortedArrayUsingDescriptors:sortDescriptors]];
    liveUpdateArray = array;
    */
    
    NSArray *sortedArray = [liveUpdateArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2){
        
        float v1 = [[p1 objectForKey:@"floLong" ] floatValue];
        float v2 = [[p2 objectForKey:@"floLong" ] floatValue];
        if (v1 < v2) {
            return NSOrderedAscending;
        } else if (v1 > v2) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    liveUpdateArray = [NSMutableArray arrayWithArray:sortedArray];
    
    for (int i = 0; i<liveUpdateArray.count; i++) {
        
        NSMutableArray *array;
        array = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObject:[liveUpdateArray objectAtIndex:i]]];
        
        CLLocationDegrees latitude=[[[liveUpdateArray objectAtIndex:i] objectForKey:@"floLat"] doubleValue];
        CLLocationDegrees longitude=[[[liveUpdateArray objectAtIndex:i] objectForKey:@"floLong"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        BasicMapAnnotation *annotation=[[BasicMapAnnotation alloc] initWithCoordinate:location dic:[liveUpdateArray objectAtIndex:i] arr:array tag:mapTypeIndex];
        [self.itemsAnnotations addObject:annotation];
        
        int intType = [[[liveUpdateArray objectAtIndex:i] objectForKey:@"intType"] integerValue];
        
        GMSMarker *marker = [GMSMarker markerWithPosition:annotation.coordinate];
        [marker setUserData:[liveUpdateArray objectAtIndex:i]];
        
        if (intType == 13) {
            [marker setIcon:[UIImage imageNamed:((IS_IPAD) ?@"liveTrafficType13Marker_ipad.png":@"liveTrafficType13Marker.png")]];
        }
        marker.map = _mapView;
    }
}

NSInteger SortAsNumbers(id id1, id id2, void *context)
    {
        float v1 = [id1 floatValue];
        float v2 = [id2 floatValue];
        if (v1 < v2) {
            return NSOrderedAscending;
        } else if (v1 > v2) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }
#pragma mark - PassValue protocol
- (void)ddlist:(int)value listTag:(int)tag{
    
    highWayIndex = value;
    // NSLog(@"highWayIndex== %d",highWayIndex);
    if ([highWayArray count] > 0) {
        //[highWayBtn setTitle:[NSString stringWithFormat:@"  %@",[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"strName"]] forState:UIControlStateNormal];
        [highWayLabel setText:[NSString stringWithFormat:@"  %@",[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"strName"]]];
        
    }
    
    [self setDDListHidden:isDDListHidden];
    [self retrieveLiveUpdate:13];
}

#pragma mark - The Good Stuff
- (BOOL) mapView:		(GMSMapView *) 	mapView
    didTapMarker:		(GMSMarker *) 	marker {
    mapView.selectedMarker = marker;
    
    double minus = 0.0f;
    
    mapTypeIndex = 13;
    if(mapTypeIndex == 13)
        minus = ((self.view.frame.size.height > 480) ? 100 : 150);
    
    CGPoint point = [_mapView.projection pointForCoordinate:marker.position];
    point.y = point.y - minus;
    GMSCameraUpdate *camera =
    [GMSCameraUpdate setTarget:[_mapView.projection coordinateForPoint:point]];
    [_mapView animateWithCameraUpdate:camera];
    
    return YES;
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    if (!marker.userData) {
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
        return blankView;
    }
    
    NSDictionary *markerUserData = marker.userData;
    
    GMSAnnotationView *customView = [[GMSAnnotationView alloc] initWithFrame:CGRectZero];
    mapTypeIndex = 13;
    if (mapTypeIndex == 13){
        float imageWidth = 241.0f;
        float imageHeight = 194.0f;
        float paddingLeft = 10.0f;
        float paddingTop = 5.0f;
        if (IS_IPAD) {
            imageWidth = 482.0f;
            imageHeight = 388.0f;
            paddingLeft = 20.0f;
            paddingTop = 10.0f;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, imageWidth, imageHeight)];
        NSString *strURL = [[markerUserData objectForKey:@"strURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:strURL]]; //Img_URL is NSString of your image URL
        if (img) {       //If image is previously downloaded set it and we're done.
            [imageView setImage:img];
            [[SDImageCache sharedImageCache] removeImageForKey:strURL fromDisk:YES];
        }else{
            [imageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"VideoPlaceholder.png"] success:^(UIImage *image, BOOL cached) {
                if (!marker.snippet || !cached) {
                    [marker setSnippet:@""];                 //Set a flag to prevent an infinite loop
                    if (mapView.selectedMarker == marker) {  //Only set if the selected marker equals to the downloaded marker
                        [_mapView setSelectedMarker:marker];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
        
        [imageView setBackgroundColor:[UIColor blackColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [customView setFrame:CGRectMake(0, 0, imageView.frame.size.width + 20.0f, imageView.frame.size.height + 25.0f)];
        [customView addSubview:imageView];
        @try {
            if ([[marker.userData objectForKey:@"key"] isEqualToString:@"StartAndEndPoint"]) {
                [customView setFrame:CGRectZero];
            }
        }
        @catch (NSException *exception) {
            
        }
    }
    
    return customView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"[[tollPlazaArray objectAtIndex:section] count]:%d",[[tollPlazaArray objectAtIndex:section] count]);
    
    return liveUpdateArray.count;
}

- (BLiveFeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    int padding = 5;
    int captureVideoSize = 90;
    int buttonSize = 32;
    int fontSize = 16;
    int labelHeight = 20;
    if (IS_IPAD) {
        padding = 10;
        captureVideoSize = 180;
        buttonSize = 64;
        fontSize = 30;
        labelHeight = 40;
    }
    
    BLiveFeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BLiveFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.captureImageView.frame = CGRectMake(padding, padding, captureVideoSize, captureVideoSize);
    cell.nameLabel.frame = CGRectMake(padding + captureVideoSize + padding, padding, self.tableView.frame.size.width - captureVideoSize - padding*2 , labelHeight);
    [cell.detailLabel setHidden:YES];
    cell.shareButton.frame = CGRectMake(self.tableView.frame.size.width - padding*2, self.tableView.frame.size.height - padding*2, buttonSize, buttonSize);
    
    cell.nameLabel.font = [UIFont systemFontOfSize:fontSize];
    if (liveUpdateArray.count > 0) {
        NSDictionary *data = [liveUpdateArray objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.nameLabel.text = [data objectForKey:@"strDescription"];
        //cell.detailLabel.text = []
        
        //NSString *decLocation = [[[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        
        NSString *strURL = [[data objectForKey:@"strURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:strURL]]; //Img_URL is NSString of your image URL
        if (img) {       //If image is previously downloaded set it and we're done.
            [cell.captureImageView setImage:img];
            [[SDImageCache sharedImageCache] removeImageForKey:strURL fromDisk:YES];
        }else{
            [cell.captureImageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"VideoPlaceholder.png"] success:^(UIImage *image, BOOL cached) {
             } failure:^(NSError *error) {
                
            }];
        }
        
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(shareLiveFeed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BInformationCCTVDetailViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"informationcctvdetailViewController"];
     //    tollPlaza.infoDic = [[tollPlazaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     //    tollPlaza.highWayStr = [[highWayDetailArray objectAtIndex:indexPath.section] objectForKey:@"strName"];
     //    tollPlaza.whichMOkuai = titleStr;
    
     tollPlaza.data = [liveUpdateArray objectAtIndex:indexPath.row];
    
     [self.navigationController pushViewController:tollPlaza animated:YES];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    label.backgroundColor = [UIColor colorWithRed:0.50 green:0.51 blue:0.52 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:11];
    //label.text = [NSString stringWithFormat:@"%@",[[highWayDetailArray objectAtIndex:section] objectForKey:@"strName"]];
    [view addSubview:label];
    
    return view;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return 2;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if (index == 0) {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight+backgroundViewHeight+tabHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-backgroundViewHeight-tabHeight) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            
            [self.view addSubview: tableView];
            
            //[self retrieveLiveFeed];
        }else{
            //[self creatMap];
            
            // Create Map
            
            CGRect rect=CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight+backgroundViewHeight+tabHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-backgroundViewHeight-tabHeight);
            
            _mapView = [[GMSMapView alloc] initWithFrame:rect];
            _mapView.myLocationEnabled = YES;
            _mapView.trafficEnabled = YES;
            [_mapView setDelegate:self];
            [self.view addSubview:_mapView];
            
            [_mapView setMapType:kGMSTypeSatellite];
            
            int buttonSize = 32;
            int padding = 10;
            if (IS_IPAD) {
                buttonSize = 64;
                padding = 20;
            }
            UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            currentLocationBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding, buttonSize, buttonSize);
            [currentLocationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
            [currentLocationBtn setBackgroundColor:[UIColor whiteColor]];
            [currentLocationBtn addTarget:self action:@selector(goToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:currentLocationBtn];
            
            UIButton *roadOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            roadOptionBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding+buttonSize+1, buttonSize, buttonSize);
            [roadOptionBtn setImage:[UIImage imageNamed:@"traffic.png"] forState:UIControlStateNormal];
            [roadOptionBtn setBackgroundColor:[UIColor whiteColor]];
            [roadOptionBtn addTarget:self action:@selector(changeRoadOption) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:roadOptionBtn];
            
            UIButton *mapOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            mapOptionBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding+buttonSize+1+buttonSize+1, buttonSize, buttonSize);
            [mapOptionBtn setImage:[UIImage imageNamed:@"satellite.png"] forState:UIControlStateNormal];
            [mapOptionBtn setBackgroundColor:[UIColor whiteColor]];
            [mapOptionBtn addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:mapOptionBtn];
            
            
            UIButton *zoomOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            zoomOutBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, self.view.frame.size.height-padding-buttonSize-1-buttonSize, buttonSize, buttonSize);
            [zoomOutBtn setImage:[UIImage imageNamed:@"map_plus.png"] forState:UIControlStateNormal];
            [zoomOutBtn setBackgroundColor:[UIColor whiteColor]];
            [zoomOutBtn addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:zoomOutBtn];
            
            UIButton *zoomInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            zoomInBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, self.view.frame.size.height-padding-buttonSize, buttonSize, buttonSize);
            [zoomInBtn setImage:[UIImage imageNamed:@"map_minus.png"] forState:UIControlStateNormal];
            [zoomInBtn setBackgroundColor:[UIColor whiteColor]];
            [zoomInBtn addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:zoomInBtn];        }
        
        [self retrieveLiveUpdate:13];
    }
    else
    {
        if (index == 0) {
            //[self retrieveLiveUpdate:13];
        }
    }
    return view;
}

-(IBAction)shareLiveFeed:(UIButton *)sender
{
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *data = [liveUpdateArray objectAtIndex:sender.tag];
    
    
    NSString *idTrafficUpdate = [[data objectForKey:@"idTrafficUpdate" ] substringFromIndex:3];
    
    
    UIImage *imageToShare = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[[data objectForKey:@"strURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]; //Img_URL is NSString of your image URL
    if (imageToShare) {
        [itemsToShare addObject:imageToShare];
    }
    
    NSString *strDescription = [data objectForKey:@"strDescription"];
    
    
    [itemsToShare addObject:@"For more details, please go to this link"];
    
    NSString *urlToShare = [NSString stringWithFormat:@"http://plustrafik.plus.com.my/livetraffic/index/%@", idTrafficUpdate ];;
    [itemsToShare addObject:urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [activityVC setValue:[NSString stringWithFormat:@"PLUS Expressways Live Feed - %@", strDescription] forKey:@"subject"];
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)changeRoadOption
{
    /*
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        [_mapView animateToZoom:(_mapView.camera.zoom/1.2)];
    }
     */
    _mapView.trafficEnabled = !_mapView.trafficEnabled;
}
- (void)changeMapType
{
    if (_mapView.mapType == kGMSTypeSatellite) {
        _mapView.mapType = kGMSTypeNormal;
    }else{
        _mapView.mapType = kGMSTypeSatellite;
    }
}

- (void)zoomIn
{
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        [_mapView animateToZoom:(_mapView.camera.zoom/1.2)];
    }
}
- (void)zoomOut
{
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        [_mapView animateToZoom:(_mapView.camera.zoom * 1.2)];
    }
}
- (void)creatMap{
    
    CGRect rect=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
    _mapView = [[GMSMapView alloc] initWithFrame:rect];
    _mapView.myLocationEnabled = YES;
    _mapView.trafficEnabled = YES;
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
    /*
    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLocationBtn.frame = CGRectMake(self.view.frame.size.width-35, self.view.frame.size.height -35, 30, 30);
    currentLocationBtn.layer.cornerRadius = 6.0;
    currentLocationBtn.layer.masksToBounds = YES;
    [currentLocationBtn setImage:[UIImage imageNamed:@"mapLocate.png"] forState:UIControlStateNormal];
    [currentLocationBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [currentLocationBtn addTarget:self action:@selector(goToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationBtn];
     */
}

#pragma mark - Map

- (void)creaRoute{
    
    if ([highWayArray count] > 0) {
        Place* home = [[Place alloc] init];
        home.latitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decStartLat"] doubleValue];
        home.longitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decStartLong"] doubleValue];
        
        Place* office = [[Place alloc] init];
        office.latitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decEndLat"] doubleValue];
        office.longitude =[[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decEndLong"] doubleValue];
        
        [_mapView clear];
        [self.mapAnnotations removeAllObjects];
        [markerArray removeAllObjects];
        
        PlaceMark* from = [[PlaceMark alloc] initWithPlace:office];
        [self.mapAnnotations addObject:from];
        CLLocationCoordinate2D fromPosition = CLLocationCoordinate2DMake(home.latitude, home.longitude);
        GMSMarker *formMarker = [GMSMarker markerWithPosition:fromPosition];
        formMarker.icon = [UIImage imageNamed:@"ic_marker_red.png"];
        formMarker.userData = [NSDictionary dictionaryWithObjectsAndKeys:@"StartAndEndPoint", @"key", nil];
        formMarker.map = _mapView;
        
        PlaceMark* to = [[PlaceMark alloc] initWithPlace:home];
        [self.mapAnnotations addObject:to];
        CLLocationCoordinate2D toPosition = CLLocationCoordinate2DMake(office.latitude, office.longitude);
        GMSMarker *toMarker = [GMSMarker markerWithPosition:toPosition];
        toMarker.icon = [UIImage imageNamed:@"ic_marker_green.png"];
        toMarker.userData = [NSDictionary dictionaryWithObjectsAndKeys:@"StartAndEndPoint", @"key", nil];
        toMarker.map = _mapView;
        
        [markerArray addObject:formMarker];
        [markerArray addObject:toMarker];
        if ([CheckNetwork connectedToNetwork]) {
            
            self.routes = nil;
            self.routes = [NSArray arrayWithArray:[self calculateRoutesFrom:from.coordinate to:to.coordinate]];
            
            if (self.routes.count>0) {
                [self makePolylineWithLocations:self.routes];
                [self centerMap];
            }
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)searchRoutes{
    
    if ([CheckNetwork connectedToNetwork]) {
        [_mapView clear];
        [self.mapAnnotations removeAllObjects];
        [markerArray removeAllObjects];
        
        if ([highWayArray count] > 0) {
            Place* home = [[Place alloc] init];
            home.latitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decStartLat"] doubleValue];
            home.longitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decStartLong"] doubleValue];
            
            Place* office = [[Place alloc] init];
            office.latitude = [[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decEndLat"] doubleValue];
            office.longitude =[[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"decEndLong"] doubleValue];
            
            PlaceMark* from = [[PlaceMark alloc] initWithPlace:office];
            [self.mapAnnotations addObject:from];
            CLLocationCoordinate2D fromPosition = CLLocationCoordinate2DMake(home.latitude, home.longitude);
            GMSMarker *formMarker = [GMSMarker markerWithPosition:fromPosition];
            formMarker.icon = [UIImage imageNamed:@"ic_marker_red.png"];
            formMarker.userData = [NSDictionary dictionaryWithObjectsAndKeys:@"StartAndEndPoint", @"key", nil];
            formMarker.map = _mapView;
            
            PlaceMark* to = [[PlaceMark alloc] initWithPlace:home];
            [self.mapAnnotations addObject:to];
            CLLocationCoordinate2D toPosition = CLLocationCoordinate2DMake(office.latitude, office.longitude);
            GMSMarker *toMarker = [GMSMarker markerWithPosition:toPosition];
            toMarker.icon = [UIImage imageNamed:@"ic_marker_green.png"];
            toMarker.userData = [NSDictionary dictionaryWithObjectsAndKeys:@"StartAndEndPoint", @"key", nil];
            toMarker.map = _mapView;
            
            [markerArray addObject:formMarker];
            [markerArray addObject:toMarker];
            
            self.routes = nil;
            self.routes = [NSArray arrayWithArray:[self calculateRoutesFrom:from.coordinate to:to.coordinate]];
            
            if (self.routes.count>0) {
                [self makePolylineWithLocations:self.routes];
                [self centerMap];
            }
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)makePolylineWithLocations:(NSArray *)newLocations{
    GMSMutablePath *path = [GMSMutablePath path];
    for(int i = 0; i < newLocations.count; i++)
    {
        // break the string down even further to latitude and longitude fields.
        CLLocation* location = [newLocations objectAtIndex:i];
        CLLocationCoordinate2D coordinate =location.coordinate;
        [path addCoordinate:coordinate];
    }
    
    routeLine = [GMSPolyline polylineWithPath:path];
    routeLine.strokeColor = [UIColor colorWithRed:126.0f/255.0f green:35.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
    routeLine.strokeWidth = 7.0f;
    routeLine.geodesic = YES;
    routeLine.map = _mapView;
}

- (NSArray*)calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	//NSLog(@"api url: %@", apiUrl);
    
    self.request = [ASIHTTPRequest requestWithURL:apiUrl];
    [request startSynchronous];
    NSString *apiResponse = [request responseString];
    
    //NSLog(@"%@",apiResponse);
    
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    
	return [self decodePolyLine:[encodedPoints mutableCopy]:f to:t];
}


-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
    CLLocation *first = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ];
    CLLocation *end = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}

-(void) centerMap {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    
     for (GMSMarker *marker in markerArray) {
     bounds = [bounds includingCoordinate:marker.position];
     }
     
     GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
     [_mapView animateToViewingAngle:50];
     [_mapView animateWithCameraUpdate:update];
}

#pragma mark - UIButton

- (void)goToCurrentLocation{
    
    if ([CheckNetwork connectedToNetwork]) {
        NSLog(@"Lat=%f, Lng=%f", _mapView.myLocation.coordinate.latitude, _mapView.myLocation.coordinate.longitude);
        [_mapView animateToLocation:_mapView.myLocation.coordinate];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)click{
    
    //   NSLog(@"+++++++click+++++");
}

#pragma mark - ZZMKAnnotationDelegate

- (void)click:(NSMutableDictionary *)dic{
    
    // NSLog(@"+++++++%@",dic);
    
    int intStrType;
    
    if (mapTypeIndex == 1) {
        intStrType = 2;
    }else if (mapTypeIndex == 2) {
        intStrType = 0;
    }else if (mapTypeIndex == 3) {
        intStrType = 4;
    }else if (mapTypeIndex == 4) {
        intStrType = 5;
    }else if (mapTypeIndex == 5) {
        intStrType = 6;
    }
    
    NSLog(@"mapTypeIndex:%d",mapTypeIndex);
    NSLog(@"%@",dic);
    
    BInformationViewController *tollPlaza = [[BInformationViewController alloc] init];
    tollPlaza.strName = [dic objectForKey:@"strName"];
    tollPlaza.strDirection = [dic objectForKey:@"strDirection"];
    tollPlaza.decLocation = [dic objectForKey:@"decLocation"];
    
    if (mapTypeIndex == 7) {
        tollPlaza.strOperationHour = [dic objectForKey:@"strOperationHour"];
    }else {
        tollPlaza.strSignatureName = [dic objectForKey:@"strSignatureName"];
    }
    
    if (mapTypeIndex == 8) {
        tollPlaza.intParentType = [[dic objectForKey:@"intParentType"] intValue];
        tollPlaza.isFromFacility =YES;
    }else {
        tollPlaza.intParentType = intParentType;
    }
    tollPlaza.idParent = [dic objectForKey:@"idParent"];
    tollPlaza.intStrType = [[dic objectForKey:@"strType"] intValue];
    [self.navigationController pushViewController:tollPlaza animated:YES];
}

@end
