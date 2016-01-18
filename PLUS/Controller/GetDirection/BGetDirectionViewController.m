//
//  BGetDirectionViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BGetDirectionViewController.h"
#import "TblTollPlazaEntry.h"
#import "TblRSA.h"
#import "TblCSC.h"
#import "TblFacilitiesEntry.h"
#import "TblHighwayEntry.h"
#import "TblPetrolStation.h"
#import "Constants.h"
@interface BGetDirectionViewController ()

@end

@implementation BGetDirectionViewController

@synthesize request;
@synthesize mapAnnotations;
@synthesize tollPlazaArray;
@synthesize decLat;
@synthesize decLon;
@synthesize startLocationName;
@synthesize endLocationName;
@synthesize intParentType;
@synthesize swipeBar = _swipeBar;
@synthesize barView = _barView;
@synthesize startLocation,currentLocation,endLocation;
@synthesize routes;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Maps";
    //[self creatAnnouncements];
    
    /*
     
     0 Rsa
     1 Petrol Station
     2 CSC
     3 Toll Plaza
     */
    if (intParentType == 0) {
        
        self.tollPlazaArray = [NSMutableArray arrayWithArray:[TblRSA searchAllFromTblRSA]];
        
    }else if (intParentType == 1) {
        
        // self.tollPlazaArray = [[NSMutableArray alloc] initWithArray:[TblFacilitiesEntry searchAllFacilityByIntFacilityType:[[NSUserDefaults standardUserDefaults] objectForKey:@"intFacilityType"] idBrand:[[NSUserDefaults standardUserDefaults] objectForKey:@"idBrand"]]];
        
        self.tollPlazaArray = [NSMutableArray arrayWithArray:[TblPetrolStation searchAllPetrolStation]];
        
    }else if (intParentType == 2) {
        
        self.tollPlazaArray = [NSMutableArray arrayWithArray:[TblCSC searchAllFromTblCSC]];
        
    }else if (intParentType == 3) {
        
        self.tollPlazaArray = [NSMutableArray arrayWithArray:[TblTollPlazaEntry searchAllFromTollPlaza]];
    }
    
    
    startLocationName = @"MY CURRENT";
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    // NSLog(@"mapAnnotations:%@",self.mapAnnotations);
    
    [self creatMap];
    [self creatUI];
    
    [self CreatLocationManager];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mapAnnotations = nil;
    self.tollPlazaArray = nil;
    self.startLocationName = nil;
    self.endLocationName = nil;
    self.startLocation = nil;
    self.currentLocation = nil;
    self.endLocation = nil;
    self.routes = nil;
    self.locationManager = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    
    [locationManager setDelegate:nil];
    [locationManager stopUpdatingLocation];
    
    [_mapView setDelegate:nil];
}

#pragma mark - CreatLocationManager

- (void)CreatLocationManager{
    
    CLLocationManager *temp = [[CLLocationManager alloc] init];
    self.locationManager = temp;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}



#pragma mark - RNSwipeBarDelegate

- (void)mainButtonWasPressed:(id)sender
{
    
    isDDlistStartHidden = YES;
    isDDlistEndHidden = YES;
    
    [self setDDListStartHidden];
    [self setDDListEndHidden];
    
    [self.swipeBar toggle];
}

- (void)swipeBarDidAppear:(id)sender
{
    // NSLog(@"bar did appear");
}

- (void)swipeBarDidDisappear:(id)sender
{
    //  NSLog(@"bar did disappear");
}

- (void)swipebarWasSwiped:(id)sender
{
    // NSLog(@"bar was swiped");
    
    
    isDDlistStartHidden = YES;
    isDDlistEndHidden = YES;
    
    [self setDDListStartHidden];
    [self setDDListEndHidden];
}


- (void)selectStartBtn:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (!startList) {
        
        
        startList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
        startList._delegate = self;
        startList.listTag = 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.tollPlazaArray];
        [array insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"MY CURRENT",@"strName", nil] atIndex:0];
        startList._resultList = array;
        [self.view addSubview:startList.view];
        [startList.view setFrame:CGRectMake(5, 101, 310, 0)];
    }
    [self setDDListStartHidden];
}

- (void)selectEndBtn:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (!endList) {
        
        
        endList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
        endList._delegate = self;
        endList.listTag = 2;
        endList._resultList = self.tollPlazaArray;
        [self.view addSubview:endList.view];
        [endList.view setFrame:CGRectMake(5, 141, 310, 0)];
    }
    [self setDDListEndHidden];
}


#pragma mark - UI

- (void)creatUI{
    
    RNSwipeBar *swipeBar = [[RNSwipeBar alloc] initWithMainView:[self view]];
    [swipeBar setDelegate:self];
    [self setSwipeBar:swipeBar];
    [[self view] addSubview:[self swipeBar]];
    
    RNBarView *barView = [[RNBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+30, 80)];
    barView.startLocationName = startLocationName;
    barView.endLocationName = endLocationName;
    [barView setDelegate:self];
    [self setBarView:barView];
    [swipeBar setBarView:self.barView];
}


- (void)creatMap{
    
    CGRect rect=CGRectMake(0,TOP_HEADER_HEIGHT+statusBarHeight,320,self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight);
	
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    _mapView.showsUserLocation = YES;
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
    
    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLocationBtn.frame = CGRectMake(self.view.frame.size.width-35, self.view.frame.size.height-35, 30, 30);
    currentLocationBtn.layer.cornerRadius = 6.0;
    currentLocationBtn.layer.masksToBounds = YES;
    [currentLocationBtn setImage:[UIImage imageNamed:@"mapLocate.png"] forState:UIControlStateNormal];
    [currentLocationBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [currentLocationBtn addTarget:self action:@selector(goToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationBtn];
}


- (void)setDDListStartHidden{
    
   	NSInteger height = isDDlistStartHidden ? 0 : 150;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[startList.view setFrame:CGRectMake(5, 101, 310, height)];
    [self.view bringSubviewToFront:startList.view];
	[UIView commitAnimations];
    
    isDDlistStartHidden = !isDDlistStartHidden;
}

- (void)setDDListEndHidden{
    
   	NSInteger height = isDDlistEndHidden ? 0 : 150;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[endList.view setFrame:CGRectMake(5, 141, 310, height)];
    // [self.view bringSubviewToFront:startList.view];
	[UIView commitAnimations];
    
    isDDlistEndHidden = !isDDlistEndHidden;
}

#pragma mark - UIButton

- (void)goToCurrentLocation{
    
    if ([CheckNetwork connectedToNetwork]) {
        [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    }
}

- (void)beginSearCh{
    
    CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:[[[self.tollPlazaArray objectAtIndex:endIndex] objectForKey:@"decLat"] doubleValue] longitude:[[[self.tollPlazaArray objectAtIndex:endIndex] objectForKey:@"decLong"] doubleValue]];
    self.endLocation = endLoc;
    
    [self creaRoute:self.startLocation endLocation:self.endLocation];
    
}

#pragma mark - DDListDelegate
- (void)ddlist:(int)value listTag:(int)tag{
    
    if (tag == 1) {
        
        if (value == 0) {
            
            startLocationName = @"MY CURRENT";
            self.startLocation = self.currentLocation;
        }else {
            startIndex = value-1;
            startLocationName = [NSString stringWithString:[[self.tollPlazaArray objectAtIndex:startIndex] objectForKey:@"strName"]];
            
            CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:[[[self.tollPlazaArray objectAtIndex:startIndex] objectForKey:@"decLat"] doubleValue] longitude:[[[self.tollPlazaArray objectAtIndex:startIndex] objectForKey:@"decLong"] doubleValue]];
            self.startLocation = startLoc;
        }
        
        
        self.barView.startLocationName = startLocationName;
        [self.barView reloadTableData];
        
        [self setDDListStartHidden];
        
    }else if (tag == 2) {
        
        endIndex = value;
        endLocationName = [NSString stringWithFormat:@"%@",[[self.tollPlazaArray objectAtIndex:endIndex] objectForKey:@"strName"]];
        
        self.barView.endLocationName = endLocationName;
        [self.barView reloadTableData];
        
        [self setDDListEndHidden];
    }
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneBtn.frame = CGRectMake(15, 0, 40, 20);
    //[doneBtn setBackgroundColor:[UIColor colorWithRed:.78 green:.78 blue:.79 alpha:1]];
    [doneBtn setTitle:@"Find" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [doneBtn setTitleColor:[UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(beginSearCh) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.leftButton = doneBtn;
}


#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Work around a bug in MapKit where user location is not initially zoomed to.
    
    if (!isGetLoc) {
        
        isGetLoc = YES;
        
        CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        self.startLocation = startLoc;
        
        CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        self.currentLocation = currentLoc;
        
        CLLocation *endLoc= [[CLLocation alloc] initWithLatitude:decLat longitude:decLon];
        self.endLocation = endLoc;
        
        [self creaRoute:self.startLocation endLocation:self.endLocation];
        
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    isGetLoc = NO;
    [manager stopUpdatingLocation];
}

#pragma mark - Map

- (void)creaRoute:(CLLocation *)startL endLocation:(CLLocation *)endL{
	
    if ([CheckNetwork connectedToNetwork]) {
        
        [_mapView removeAnnotations:[_mapView annotations]];
        [_mapView removeOverlay:routeLine];
        
        [self.mapAnnotations removeAllObjects];
        
        Place* start = [[Place alloc] init];
        start.name = startLocationName;
        start.latitude = startL.coordinate.latitude;
        start.longitude = startL.coordinate.longitude;
        
        Place* end = [[Place alloc] init];
        end.name = endLocationName;
        end.latitude = endL.coordinate.latitude;
        end.longitude =endL.coordinate.longitude;
        
        PlaceMark* startMark = [[PlaceMark alloc] initWithPlace:start];
        [self.mapAnnotations addObject:startMark];
        
        PlaceMark* endMark = [[PlaceMark alloc] initWithPlace:end];
        [self.mapAnnotations addObject:endMark];
        
        [_mapView addAnnotations:self.mapAnnotations];
        
        self.routes = [NSArray arrayWithArray:[self calculateRoutesFrom:startMark.coordinate to:endMark.coordinate]];
        
        if ([self.routes count] > 0) {
            [_mapView addOverlay:[self makePolylineWithLocations:self.routes]];
            [self centerMap];
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
	
}


- (MKPolyline *)makePolylineWithLocations:(NSArray *)newLocations{
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D)* newLocations.count);
    for(int i = 0; i < newLocations.count; i++)
    {
        // break the string down even further to latitude and longitude fields.
        CLLocation* location = [routes objectAtIndex:i];
        CLLocationCoordinate2D coordinate =location.coordinate;
        pointArray[i] = MKMapPointForCoordinate(coordinate);
    }
    
    routeLine = [MKPolyline polylineWithPoints:pointArray count:newLocations.count];
    free(pointArray);
    return routeLine;
}


-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	//NSLog(@"api url: %@", apiUrl);
    
    self.request = [ASIHTTPRequest requestWithURL:apiUrl];
    [request startSynchronous];
    NSString *apiResponse = [request responseString];
    
    // NSLog(@"%@",apiResponse);
    
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
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];	//printf("[%f,", [latitude doubleValue]);	//printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
    /*
     CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
     CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
     [array insertObject:first atIndex:0];
     [array addObject:end];
     */
	return array;
}
-(void) centerMap {
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < self.routes.count; idx++)
	{
		CLLocation* currentLoc = [self.routes objectAtIndex:idx];
		if(currentLoc.coordinate.latitude > maxLat)
			maxLat = currentLoc.coordinate.latitude;
		if(currentLoc.coordinate.latitude < minLat)
			minLat = currentLoc.coordinate.latitude;
		if(currentLoc.coordinate.longitude > maxLon)
			maxLon = currentLoc.coordinate.longitude;
		if(currentLoc.coordinate.longitude < minLon)
			minLon = currentLoc.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	
	[_mapView setRegion:region animated:YES];
}


#pragma mark mapView delegate functions

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    // NSLog(@"return overLayView...");
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
        routeLineView.layer.borderWidth = 1;
        routeLineView.layer.masksToBounds = YES;
        routeLineView.layer.borderColor = [[UIColor whiteColor]CGColor];
        routeLineView.alpha = 0.8;
        routeLineView.strokeColor=[UIColor purpleColor];
        return routeLineView;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MTDirectionsKitAnnotation"];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MTDirectionsKitAnnotation"];
    } else {
        pin.annotation = annotation;
    }
    
    pin.draggable = YES;
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    
    if (annotation == [self.mapAnnotations objectAtIndex:0]) {
        pin.pinColor = MKPinAnnotationColorGreen;
    } else if (annotation == [self.mapAnnotations objectAtIndex:1]) {
        pin.pinColor = MKPinAnnotationColorRed;
    } else {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pin;
}

@end
