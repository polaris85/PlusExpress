//
//  BLiveTrafficViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BLiveTrafficViewController.h"
#import "BInformationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SDWebImageDownloader.h"
#import "TblHighwayEntry.h"
#import "TblCSC.h"
#import "TblTollPlazaEntry.h"
#import "TblPetrolStation.h"
#import "TblRSA.h"
#import "TblFacilitiesEntry.h"
#import "CheckNetwork.h"
#import "TblConfig.h"
#import "TblTrafficUpdate.h"
#import "UIImageView+WebCache.h"
#import "DBUpdate.h"
#import "Constants.h"
@interface BLiveTrafficViewController (){
    CalloutMapAnnotation *_calloutAnnotation;
    CalloutMapAnnotation *_previousdAnnotation;
}
@end

@implementation BLiveTrafficViewController

@synthesize request;
@synthesize mapAnnotations;
@synthesize itemsAnnotations;
@synthesize routes;
@synthesize videoFeed = _videoFeed;

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
    
    titleLabel.text = @"Live Traffic";
    //[self creatAnnouncements];
    
    
    //highWayIndex = 0;
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblHighwayEntry searchHighway]];
    
    tempArray = [[NSMutableArray alloc] init];
    markerArray = [[NSMutableArray alloc] init];
    
    intParentType = 3;
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.itemsAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    if(isPushMode){
        [backButton removeTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton addTarget:self action:@selector(removeDialog) forControlEvents:UIControlEventTouchUpInside];
    }
    [self creatUI];
    [self changeAno:-5];
}
- (void)setHighwayIndex:(NSInteger)index
{
    highWayIndex = index;
}
- (void)setPushMode:(BOOL)pushMode
{
    isPushMode = pushMode;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVideoFeed:(BOOL)videoFeed {
    _videoFeed = videoFeed;
    
    if (self.videoFeed) {
        [self changeAno:13];
    } else {
        [self changeAno:-5];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.mapAnnotations = nil;
    self.itemsAnnotations = nil;
    self.routes = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  - HttpData

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

- (void)didRetrieveLiveUpdateDataFinished:(id)data {
    [self hideHud];
    
    [tempArray removeAllObjects];
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSArray *contentArr = [[[data JSONValue] objectForKey:@"result"] objectForKey:@"ChangeData"];
        [tempArray addObjectsFromArray:contentArr];
    }
    
    [self creaRoute];
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
}

- (void)didRetrieveLiveUpdateDataFinishedError {
    [self hideHud];
    
    [self creaRoute];
    
    if (mapTypeIndex != -1) {
        [self updateTrafficType];
    }
}

- (void)removeDialog{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UI

- (void)creatUI{
    
    int backgroundViewHeight = 42;
    int padding = 5;
    int dropButtonSize = 24;
    int highwayButtonSize = 32;
    int fontSize = 12;
    if (IS_IPAD) {
        backgroundViewHeight = 84;
        padding = 10;
        dropButtonSize = 64;
        highwayButtonSize = 64;
        fontSize = 24;
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
    
    [self creatMap];
    
    UIButton *dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dropBtn.frame = CGRectMake(highWayLabel.frame.origin.x + highWayLabel.frame.size.width, 9, dropButtonSize, dropButtonSize);
    [dropBtn setImage:[UIImage imageNamed:@"dropmore.png"] forState:UIControlStateNormal];
    //[dropBtn setImage:[UIImage imageNamed:@"dropIcon-up.png"] forState:UIControlStateSelected];
    [dropBtn addTarget:self action:@selector(displayDropScroll:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:dropBtn];
    
    control_ddListHidden_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    control_ddListHidden_Btn.frame = self.view.frame;
    control_ddListHidden_Btn.backgroundColor = [UIColor clearColor];
    //control_ddListHidden_Btn.alpha = 0.5;
    [control_ddListHidden_Btn addTarget:self action:@selector(control_ddListHidden:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:control_ddListHidden_Btn];
    control_ddListHidden_Btn.hidden = YES;
    
    UIImage *heavyVehicleImage = [UIImage imageNamed:@"HeavyVehicleRestriction.png"];
    heavyVehicleRestrictionView = [[UIImageView alloc] initWithFrame:CGRectMake((_mapView.frame.size.width - heavyVehicleImage.size.width) / 2.0, (_mapView.frame.size.height - heavyVehicleImage.size.height) / 2.0f, heavyVehicleImage.size.width, heavyVehicleImage.size.height)];
    [heavyVehicleRestrictionView setImage:heavyVehicleImage];
    [heavyVehicleRestrictionView setHidden:TRUE];
    [_mapView addSubview:heavyVehicleRestrictionView];
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
    CGRect rect=CGRectMake(0,backgroundView.frame.origin.y + backgroundView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - backgroundView.frame.origin.y - backgroundView.frame.size.height);
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    _mapView = [GMSMapView mapWithFrame:rect camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.trafficEnabled = YES;
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
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
    [self.view addSubview:zoomInBtn];
}

- (void)setDDListHidden:(BOOL)hidden {
    
    int backgroundViewHeight = 42;
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

- (void)selectHighWay{
    
    if (!_ddList) {
        _ddList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
        _ddList._delegate = self;
        _ddList._resultList = highWayArray;
        [self.view addSubview:_ddList.view];
        
        int backgroundViewHeight = 42;
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

- (void)control_ddListHidden:(UIButton *)button{
    
    button.hidden = !button.hidden;
    
    if (_ddList) {
        [self.view bringSubviewToFront:_ddList.view];
    }
    
    [self setDDListHidden:isDDListHidden];
}

- (void)displayDropScroll:(UIButton *)sender{
    
    if (!_dropScroll) {
        _dropScroll = [[DropDownScroll alloc] initWithFrame:CGRectMake(0, backgroundView.frame.origin.y + backgroundView.frame.size.height, self.view.frame.size.width, 58)];
        _dropScroll.dele = self;
        
        /*
        NSArray *descriptionArray = [NSArray arrayWithObjects:@"ALL", [NSNumber numberWithInt:-5], @"Traffic Alert", [NSNumber numberWithInt:14], @"Video Feed", [NSNumber numberWithInt:13], @"RSA Closure", [NSNumber numberWithInt:11], @"Major Disruption", [NSNumber numberWithInt:2], @"Incident", [NSNumber numberWithInt:3], @"Road Work", [NSNumber numberWithInt:4],  @"Alternative Route", [NSNumber numberWithInt:6],  @"Future Event", [NSNumber numberWithInt:8], @"AES", [NSNumber numberWithInt:12], nil];
         */
        NSArray *descriptionArray = [NSArray arrayWithObjects:@"ALL", [NSNumber numberWithInt:-5], @"Traffic Alert", [NSNumber numberWithInt:14], @"RSA Closure", [NSNumber numberWithInt:11], @"Major Disruption", [NSNumber numberWithInt:2], @"Incident", [NSNumber numberWithInt:3], @"Road Work", [NSNumber numberWithInt:4],  @"Alternative Route", [NSNumber numberWithInt:6],  @"Future Event", [NSNumber numberWithInt:8], @"AES", [NSNumber numberWithInt:12], nil];
        [_dropScroll loadData:descriptionArray dropDownScrollType:TrafficType];
        
        [self.view addSubview:_dropScroll];
    }
    
    if (_ddList) {
        [self.view bringSubviewToFront:_ddList.view];
    }
    
    NSInteger height = isDropScrollHidden ? 0 : 58;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[_dropScroll setFrame:CGRectMake(0, backgroundView.frame.origin.y + backgroundView.frame.size.height, self.view.frame.size.width, height)];
	[UIView commitAnimations];
    
    isDropScrollHidden = !isDropScrollHidden;
    
    sender.selected = !sender.selected;
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


#pragma mark - PassValue protocol
- (void)ddlist:(int)value listTag:(int)tag{
    
    highWayIndex = value;
    // NSLog(@"highWayIndex== %d",highWayIndex);
    if ([highWayArray count] > 0) {
        //[highWayBtn setTitle:[NSString stringWithFormat:@"  %@",[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"strName"]] forState:UIControlStateNormal];
        [highWayLabel setText:[NSString stringWithFormat:@"  %@",[[highWayArray objectAtIndex:highWayIndex] objectForKey:@"strName"]]];
        
    }
    
    [self setDDListHidden:isDDListHidden];
    //[self searchRoutes];
    [self changeAno:mapTypeIndex];
}

#pragma mark - DropDownScrollDelegate
- (void)changeAno:(NSInteger)tag{
    mapTypeIndex = tag;
    NSLog(@"tag : %ld", (long)tag);
    [self retrieveLiveUpdate:mapTypeIndex];
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
    
    if (mapTypeIndex == 15) {
        [heavyVehicleRestrictionView setHidden:NO];
        return;
    }
    
    if (liveUpdateArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No traffic update available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
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
            [marker setIcon:[UIImage imageNamed:@"liveTrafficType13Marker.png"]];
        } else if (intType == 14) {
            int intSpeedLimit = [[[liveUpdateArray objectAtIndex:i] objectForKey:@"intSpeedLimit"] integerValue];
            int intWaterLevel = [[[liveUpdateArray objectAtIndex:i] objectForKey:@"intWaterLevel"] integerValue];
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"marker_%d_%d.png", intSpeedLimit, intWaterLevel]];
            [marker setIcon:image];
        } else {
            NSString *imageName = [NSString stringWithFormat:@"liveTrafficType%dicon.png", [[[liveUpdateArray objectAtIndex:i] objectForKey:@"intType"] intValue]];
            [marker setIcon:[UIImage imageNamed:imageName]];
        }
        marker.map = _mapView;
    }
}

- (void)click{
    
    //   NSLog(@"+++++++click+++++");
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
    
    /*
    for (BasicMapAnnotation *annotation in self.itemsAnnotations) {
         GMSMarker *marker = [GMSMarker markerWithPosition:annotation.coordinate];
         bounds = [bounds includingCoordinate:marker.position];
     }
     */
    
    for (GMSMarker *marker in markerArray) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
     GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
     [_mapView animateToViewingAngle:50];
     [_mapView animateWithCameraUpdate:update];
    
}

#pragma mark - The Good Stuff
- (BOOL) mapView:		(GMSMapView *) 	mapView
    didTapMarker:		(GMSMarker *) 	marker {
    mapView.selectedMarker = marker;
    
    double minus = 0.0f;
    NSDictionary *markerUserData = marker.userData;
    
    if (mapTypeIndex != 13) {
        NSMutableString *contentString = [NSMutableString stringWithString:@""];
        
        if ([markerUserData objectForKey:@"strTitle"]) {
            [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strTitle"]];
        }
        
        if ([markerUserData objectForKey:@"strDescription"]) {
            [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
        }
        
        if (mapTypeIndex == 6) {
            if ([markerUserData objectForKey:@"intSpeedLimit"]) {
                [contentString appendFormat:@"Wind Speed - %@ km/h\n", [markerUserData objectForKey:@"intSpeedLimit"]];
            }
            
            if ([markerUserData objectForKey:@"intWaterLevel"]) {
                [contentString appendFormat:@"Water Level - %@ cm\n", [markerUserData objectForKey:@"intWaterLevel"]];
            }
        } else if (mapTypeIndex == 7) {
            contentString = [NSMutableString stringWithString:@""];
            
            if ([markerUserData objectForKey:@"intSpeedLimit"]) {
                [contentString appendFormat:@"Speed Limit - %@ km/h\n", [markerUserData objectForKey:@"intSpeedLimit"]];
            }
            
            if ([markerUserData objectForKey:@"strDescription"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
            }
        } else if (mapTypeIndex == 12) {
            contentString = [NSMutableString stringWithString:@""];
            
            if ([markerUserData objectForKey:@"strTitle"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strTitle"]];
            }
            
            if ([markerUserData objectForKey:@"strDescription"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
            }
        }
        
        CGSize stringSize = [contentString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(260.0f, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        minus = stringSize.height + 25.0f;
        contentString = (NSMutableString *)[contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([contentString length] == 0) {
            minus = 0;
        }
    } else {
        minus = ((self.view.frame.size.height > 480) ? 100 : 150);
    }
    
    CGPoint point = [_mapView.projection pointForCoordinate:marker.position];
    point.y = point.y - minus;
    GMSCameraUpdate *camera =
    [GMSCameraUpdate setTarget:[_mapView.projection coordinateForPoint:point]];
    [_mapView animateWithCameraUpdate:camera];
    
    return YES;
}

- (void) mapView:		(GMSMapView *) 	mapView
didTapInfoWindowOfMarker:		(GMSMarker *) 	marker
{
    NSLog(@"Marker Info Window Tapped");
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *data = marker.userData;
    
    [itemsToShare addObject:image];
    
    
    NSString *idTrafficUpdate = [[data objectForKey:@"idTrafficUpdate" ] substringFromIndex:3];
    
    NSString *strDescription = [data objectForKey:@"strDescription"];
    
    
    [itemsToShare addObject:@"For more details, please go to this link"];
    
    NSString *urlToShare = [NSString stringWithFormat:@"http://plustrafik.plus.com.my/livetraffic/index/%@", idTrafficUpdate ];;
    [itemsToShare addObject:urlToShare];
    
        
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [activityVC setValue:[NSString stringWithFormat:@"PLUS Expressways - %@", strDescription] forKey:@"subject"];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    if (!marker.userData) {
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
        return blankView;
    }
    
    NSDictionary *markerUserData = marker.userData;
    
    GMSAnnotationView *customView = [[GMSAnnotationView alloc] initWithFrame:CGRectZero];
    
    if (mapTypeIndex != 13) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [contentLabel setNumberOfLines:0];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [contentLabel setTextColor:[UIColor whiteColor]];
        [contentLabel setShadowColor:[UIColor darkTextColor]];
        [contentLabel setShadowOffset:CGSizeMake(0, -1)];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSMutableString *contentString = [NSMutableString stringWithString:@""];
        
        if ([markerUserData objectForKey:@"strTitle"]) {
            [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strTitle"]];
        }
        
        if ([markerUserData objectForKey:@"strDescription"]) {
            [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
        }
        
        if (mapTypeIndex == 6) {
            if ([markerUserData objectForKey:@"intSpeedLimit"]) {
                [contentString appendFormat:@"Wind Speed - %@ km/h\n", [markerUserData objectForKey:@"intSpeedLimit"]];
            }
            
            if ([markerUserData objectForKey:@"intWaterLevel"]) {
                [contentString appendFormat:@"Water Level - %@ cm\n", [markerUserData objectForKey:@"intWaterLevel"]];
            }
        } else if (mapTypeIndex == 7) {
            contentString = [NSMutableString stringWithString:@""];
            
            if ([markerUserData objectForKey:@"intSpeedLimit"]) {
                [contentString appendFormat:@"Speed Limit - %@ km/h\n", [markerUserData objectForKey:@"intSpeedLimit"]];
            }
            
            if ([markerUserData objectForKey:@"strDescription"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
            }
        } else if (mapTypeIndex == 12) {
            contentString = [NSMutableString stringWithString:@""];
            
            if ([markerUserData objectForKey:@"strTitle"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strTitle"]];
            }
            
            if ([markerUserData objectForKey:@"strDescription"]) {
                [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strDescription"]];
            }
        }
        
        CGSize stringSize = [contentString sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(260.0f, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        
        [customView setFrame:CGRectMake(0, 0, stringSize.width + 20.0f, stringSize.height + 25.0f)];
        [contentLabel setFrame:CGRectMake(10.0f, 5.0f, stringSize.width, stringSize.height)];
        [contentLabel setText:contentString];
        [customView addSubview:contentLabel];
        
        contentString = (NSMutableString *)[contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([contentString length] == 0) {
            [customView setFrame:CGRectZero];
        }
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 241.0f, 194.0f)];
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
