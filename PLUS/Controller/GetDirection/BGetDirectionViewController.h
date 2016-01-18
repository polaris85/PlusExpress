//
//  BGetDirectionViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "Place.h"
#import "PlaceMark.h"

#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"

#import "DDList.h"
#import "PassValueDelegate.h"

#import "RegexKitLite.h"

#import "RNSwipeBar.h"
#import "RNBarView.h"

#import "CheckNetwork.h"
@interface BGetDirectionViewController : BaseViewController<MKMapViewDelegate,PassValueDelegate,RNBarViewDelegate, RNSwipeBarDelegate,CLLocationManagerDelegate>{
    
    MKMapView* _mapView;
    MKPolyline *routeLine;
    
    ASIHTTPRequest *request;
    
    NSMutableArray *mapAnnotations;
    
    NSMutableArray *tollPlazaArray;
    
    DDList *startList;
    DDList *endList;
    
    BOOL isDDlistStartHidden;
    BOOL isDDlistEndHidden;
    
    int startIndex;
    int endIndex;
    
    BOOL isTableDisplay;
    
    CLLocation *startLocation;
    CLLocation *currentLocation;
    CLLocation *endLocation;
    
    NSString *startLocationName;
    NSString *endLocationName;
    
    BOOL isGetLoc;
}

@property(nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableArray *tollPlazaArray;
@property (nonatomic, retain) NSString *startLocationName;
@property (nonatomic, retain) NSString *endLocationName;
@property double decLat;
@property double decLon;
@property int intParentType;
@property (nonatomic,retain) RNSwipeBar *swipeBar;
@property (nonatomic,retain) RNBarView *barView;
@property (nonatomic,retain) NSArray* routes;

@property (nonatomic,retain) CLLocation *startLocation;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) CLLocation *endLocation;

@property (nonatomic, retain) CLLocationManager *locationManager;


- (void)creatUI;
- (void)creatMap;

- (void)setDDListStartHidden;
- (void)setDDListEndHidden;

- (void)CreatLocationManager;

- (void)creaRoute:(CLLocation *)startL endLocation:(CLLocation *)endL;
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t ;
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t ;
-(void) centerMap;

- (MKPolyline *)makePolylineWithLocations:(NSArray *)newLocations;

@end
