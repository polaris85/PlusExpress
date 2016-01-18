//
//  BFindMeViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/22/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BFindMeViewController.h"
#import "Constants.h"
#import "TblFacilitiesEntry.h"
#import "TblCSC.h"
#import "TblTollPlazaEntry.h"
#import "TblNearBy.h"

@interface BFindMeViewController (){
    BOOL alertShowing;
}

@end

@implementation BFindMeViewController

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
    
    alertShowing = false;
    // Do any additional setup after loading the view.
    titleLabel.text = @"Find Me";
    isFirstLocation = YES;
    [self creatMap];
}

- (void)creatMap{
    CGRect rect=CGRectMake(0,TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT-statusBarHeight);
	
    _mapView = [[GMSMapView alloc] initWithFrame:rect];
    //_mapView.myLocationEnabled = YES;
    _mapView.trafficEnabled = NO;
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        _mapView.myLocationEnabled = YES;
    });
    
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
    [_mapView animateToZoom:9.0];
    int padding = 10;
    int buttonSize = 32;
    
    if (IS_IPAD) {
        padding = 20;
        buttonSize = 64;
    }
    
    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLocationBtn.frame = CGRectMake(self.view.frame.size.width-buttonSize-padding, TOP_HEADER_HEIGHT+statusBarHeight+padding, buttonSize, buttonSize);

    [currentLocationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [currentLocationBtn setBackgroundColor:[UIColor whiteColor]];
    [currentLocationBtn addTarget:self action:@selector(goToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationBtn];
    
    /*
    UIView *callView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 140, self.view.frame.size.width, 140)];
    callView.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    backIV.backgroundColor = [UIColor colorWithRed:67.0/255 green:115.0/255 blue:114.0/255 alpha:0.4];
    
    [callView addSubview:backIV];
    
    
    UIButton *contactPlustBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactPlustBtn.frame = CGRectMake(15, 20, 137, 40);
    [contactPlustBtn setTitle:@"Contact PLUS" forState:UIControlStateNormal];
    //[contactPlustBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [contactPlustBtn setBackgroundColor:[UIColor whiteColor]];
    [contactPlustBtn addTarget:self action:@selector(dialCall:) forControlEvents:UIControlEventTouchUpInside];
    [contactPlustBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:202.0/255 blue:1 alpha:1] forState:UIControlStateNormal];
    contactPlustBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    contactPlustBtn.tag = 990;
    [callView addSubview: contactPlustBtn];
    
    UIButton *callPolicetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callPolicetBtn.frame = CGRectMake(168, 20, 137, 40);
    [callPolicetBtn setTitle:@"Call Police" forState:UIControlStateNormal];
    [callPolicetBtn setBackgroundColor:[UIColor whiteColor]];
    [callPolicetBtn addTarget:self action:@selector(dialCall:) forControlEvents:UIControlEventTouchUpInside];
    [callPolicetBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:225.0/255 blue:193.0/255 alpha:1] forState:UIControlStateNormal];
    callPolicetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    callPolicetBtn.tag = 994;
    [callView addSubview: callPolicetBtn];
    
    UIButton *sosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sosBtn.frame = CGRectMake(15, 80, 137, 40);
    [sosBtn setTitle:@"SOS" forState:UIControlStateNormal];
    //[contactPlustBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [sosBtn setBackgroundColor:[UIColor whiteColor]];
    [sosBtn addTarget:self action:@selector(dialCall:) forControlEvents:UIControlEventTouchUpInside];
    [sosBtn setTitleColor:[UIColor colorWithRed:255.0/255 green:43.0/255 blue:12.0/255 alpha:1] forState:UIControlStateNormal];
    sosBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sosBtn.tag = 991;
    [callView addSubview: sosBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(168, 80, 137, 40);
    [callBtn setTitle:@"Call 999" forState:UIControlStateNormal];
    [callBtn setBackgroundColor:[UIColor whiteColor]];
    [callBtn addTarget:self action:@selector(dialCall:) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:225.0/255 blue:193.0/255 alpha:1] forState:UIControlStateNormal];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    callBtn.tag = 999;
    [callView addSubview: callBtn];
    
    [self.view addSubview:callView];
     */
}

- (IBAction)dialCall:(UIButton*)sender
{
    if (sender.tag == 990) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:1800880000"]];
    }else if(sender.tag == 991){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"SOS" message:@"Please input your SOS message!" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * textField = [alert textFieldAtIndex:0];
        
        [textField setBackgroundColor:[UIColor whiteColor]];
        textField.delegate = self;
        textField.frame = CGRectMake(15, 75, 255, 90);
        textField.placeholder = @"Input your message here";
        textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [textField becomeFirstResponder];
        [alert addSubview:textField];
        
        [alert show];
        
    }else if(sender.tag == 994){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:994"]];
    }else if(sender.tag == 999){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:999"]];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    NSString *sms = textField.text;
    NSLog(@"String is: %@", sms); //Put it on the debugger
    if ([textField.text length] <= 0 || buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    if (buttonIndex == 1) {
        [self callSOS:sms];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (isFirstLocation) {
        /*
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
         */
        [self goToCurrentLocation];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"FindMe Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - HttpData
- (void)callSOS:(NSString *)sms {
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didPostSOSFinished:);
        httpData.didFailed = @selector(didRetrieveDataError);
        
        [self creatHUD];
        
        /*
        [httpData postSOS:sms intDeviceType:deviceType deviceId:strUniqueId mobileNo:@"0123126252" to:@"SOS" latitude:_mapView.myLocation.coordinate.latitude longitude:_mapView.myLocation.coordinate.longitude];
          */
        [httpData postSOS:@"Help Me" intDeviceType:0 deviceId:strUniqueId mobileNo:@"0123126252" to:@"SOS" latitude:0 longitude:0];
    }
}
- (void)didPostSOSFinished:(id)data {
    [self hideHud];
    NSLog(@"Result=%@", [[[data JSONValue] objectForKey:@"result"] objectForKey:@"strMessage"]);
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"initStatus"] intValue] == 1) {
        NSLog(@"Result=%@", [[[data JSONValue] objectForKey:@"result"] objectForKey:@"strMessage"]);
    }
}

- (void)didRetrieveDataError {
    [self hideHud];
}

- (void) dealloc
{
    [_mapView removeObserver:self forKeyPath:@"myLocation"];
}
#pragma mark - UIButton

- (void)goToCurrentLocation{
    
    if ([CheckNetwork connectedToNetwork]) {
        NSLog(@"Lat=%f, Lng=%f", _mapView.myLocation.coordinate.latitude, _mapView.myLocation.coordinate.longitude);
        [_mapView animateToLocation:_mapView.myLocation.coordinate];
        
        GMSCircle *circ = [GMSCircle circleWithPosition:_mapView.myLocation.coordinate
                                                 radius:20000];
        
        circ.fillColor = [UIColor colorWithRed:0.0 green:1 blue:246.0/255 alpha:0.2];
        circ.strokeColor = [UIColor colorWithRed:0.0 green:1 blue:246.0/255 alpha:1];
        circ.strokeWidth = 2;
        circ.map = _mapView;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_mapView.myLocation.coordinate.latitude longitude:_mapView.myLocation.coordinate.longitude];
        //NSMutableArray *facilityArray = [[NSMutableArray alloc] initWithArray:[TblFacilitiesEntry searchFacilityByDistance:20 location:location]];
        NSMutableArray *facilityArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *cscArray = [TblCSC searchCSCByDistance:20.0 location:location];
        [facilityArray addObjectsFromArray:cscArray];
        for (NSDictionary *facility in cscArray) {
            float lat = [[facility objectForKey:@"decLat"] floatValue];
            float lng = [[facility objectForKey:@"decLong"] floatValue];
            //int intParentType = [[facility objectForKey:@"intParentType"] intValue];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
            
            //fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",facilityType]];
            fmarker.icon = [UIImage imageNamed:@"mapAnnotionType7"];
            
            fmarker.userData = facility;
            fmarker.map = _mapView;
            
        }
        
        //Toll Plaza
        NSArray *tollPlazaArray = [TblTollPlazaEntry searchTollPlazaByDistance:20.0 location:location];
        [facilityArray addObjectsFromArray:tollPlazaArray];
        
        for (NSDictionary *facility in tollPlazaArray) {
            float lat = [[facility objectForKey:@"decLat"] floatValue];
            float lng = [[facility objectForKey:@"decLong"] floatValue];
            //int intParentType = [[facility objectForKey:@"intParentType"] intValue];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
            
            //fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",facilityType]];
            fmarker.icon = [UIImage imageNamed:@"mapAnnotionType0"];
            
            fmarker.userData = facility;
            fmarker.map = _mapView;
            
        }
        
        NSArray *policeStationArray = [TblNearby searchNearbyByIdNearbyCatg:@"NBC0000000002" distance: 20.0 location:location];
        [facilityArray addObjectsFromArray:policeStationArray];
        
        for (NSDictionary *facility in policeStationArray) {
            float lat = [[facility objectForKey:@"floLatitude"] floatValue];
            float lng = [[facility objectForKey:@"floLongitude"] floatValue];
            //int intParentType = [[facility objectForKey:@"intParentType"] intValue];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
            
            //fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",facilityType]];
            fmarker.icon = [UIImage imageNamed:@"police.png"];
            
            fmarker.userData = facility;
            fmarker.map = _mapView;
            
        }
        
        NSArray *fireStationArray = [TblNearby searchNearbyByIdNearbyCatg:@"NBC0000000003" distance: 20.0 location:location];
        [facilityArray addObjectsFromArray:fireStationArray];
        
        for (NSDictionary *facility in tollPlazaArray) {
            float lat = [[facility objectForKey:@"decLat"] floatValue];
            float lng = [[facility objectForKey:@"decLong"] floatValue];
            //int intParentType = [[facility objectForKey:@"intParentType"] intValue];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
            
            //fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",facilityType]];
            fmarker.icon = [UIImage imageNamed:@"fire.png"];
            
            fmarker.userData = facility;
            fmarker.map = _mapView;
            
        }
        
        NSArray *hospitalArray = [TblNearby searchNearbyByIdNearbyCatg:@"NBC0000000004" distance: 20.0 location:location];
        [facilityArray addObjectsFromArray:hospitalArray];
        
        for (NSDictionary *facility in tollPlazaArray) {
            float lat = [[facility objectForKey:@"decLat"] floatValue];
            float lng = [[facility objectForKey:@"decLong"] floatValue];
            //int intParentType = [[facility objectForKey:@"intParentType"] intValue];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
            
            //fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",facilityType]];
            fmarker.icon = [UIImage imageNamed:@"hospital.png"];
            
            fmarker.userData = facility;
            fmarker.map = _mapView;
            
        }
        
    }else {
        if (!alertShowing) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alertShowing = YES;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertShowing = NO;
}

- (void) mapView:		(GMSMapView *) 	mapView
didTapInfoWindowOfMarker:		(GMSMarker *) 	marker
{
    NSLog(@"Marker Tapped");
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    if (!marker.userData) {
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
        return blankView;
    }
    
    NSDictionary *markerUserData = marker.userData;
    
    GMSAnnotationView *customView = [[GMSAnnotationView alloc] initWithFrame:CGRectZero];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentLabel setNumberOfLines:0];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setShadowColor:[UIColor darkTextColor]];
    [contentLabel setShadowOffset:CGSizeMake(0, -1)];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *decLocationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [decLocationLabel setNumberOfLines:0];
    [decLocationLabel setBackgroundColor:[UIColor clearColor]];
    [decLocationLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [decLocationLabel setTextColor:[UIColor whiteColor]];
    [decLocationLabel setShadowColor:[UIColor darkTextColor]];
    [decLocationLabel setShadowOffset:CGSizeMake(0, -1)];
    [decLocationLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableString *contentString = [NSMutableString stringWithString:@""];
    
    if ([markerUserData objectForKey:@"strName"]) {
        [contentString appendFormat:@"%@\n", [markerUserData objectForKey:@"strName"]];
    }
    
    NSString *decLocationString = [NSMutableString stringWithString:@""];
    
    if ([markerUserData objectForKey:@"decLocation"]) {
        decLocationString = [NSString stringWithFormat:@"KM%@",[markerUserData objectForKey:@"decLocation"]];
    }
        
    CGSize stringSize = [contentString sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(260.0f, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    [customView setFrame:CGRectMake(0, 0, stringSize.width + 20.0f, stringSize.height + 50.0f)];
    [contentLabel setFrame:CGRectMake(10.0f, 5.0f, stringSize.width, stringSize.height)];
    [contentLabel setText:contentString];
    [customView addSubview:contentLabel];
    
    stringSize = [decLocationString sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(260.0f, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    [decLocationLabel setFrame:CGRectMake(10.0f, 25.0f, stringSize.width, stringSize.height)];
    [decLocationLabel setText:decLocationString];
    [customView addSubview:decLocationLabel];
    
    contentString = (NSMutableString *)[contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([contentString length] == 0) {
        [customView setFrame:CGRectZero];
    }
    
    return customView;
}

-(IBAction)showDetail:(id)sender
{
    NSLog(@"Marker InfoWindow Clicked");
    
}
#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    NSLog(@"Location=%@", location);
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Location=%@", @"Error");
}

#pragma mark - Search Facilities by Distance
- (void) searchFacilities
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_mapView.myLocation.coordinate.latitude longitude:_mapView.myLocation.coordinate.longitude];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblFacilitiesEntry searchFacilityByDistance:20 location:location]];
}
@end
