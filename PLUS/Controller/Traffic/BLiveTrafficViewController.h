//
//  BLiveTrafficViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DDList.h"
#import "PassValueDelegate.h"
#import "DropDownScroll.h"

#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"

#import "Place.h"
#import "PlaceMark.h"

#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "RegexKitLite.h"
#import "CheckNetwork.h"
#import "GMSAnnotationView.h"
#import "HttpData.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"

@interface BLiveTrafficViewController : BaseViewController<PassValueDelegate,DropDownScrollDelegate,GMSMapViewDelegate,ZZMKAnnotationDelegate>
{
    UIView *backgroundView;
    DDList *_ddList;
    BOOL isDDListHidden;
    DropDownScroll *_dropScroll;
    BOOL isDropScrollHidden;
    
    NSInteger highWayIndex;
    UIButton *highWayBtn;
    UILabel *highWayLabel;
    GMSMapView* _mapView;
    GMSPolyline *routeLine;
    UIImageView *heavyVehicleRestrictionView;
    
    ASIHTTPRequest *request;
    
    NSMutableArray *mapAnnotations;
    NSMutableArray *itemsAnnotations;
    
    NSMutableArray *highWayArray;
    NSMutableArray *tempArray;
    NSMutableArray *liveUpdateArray;
    NSMutableArray *markerArray;
    
    int mapTypeIndex;
    int intParentType;
    
    UIButton *control_ddListHidden_Btn;
    
    BOOL isPushMode;
}

@property(nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableArray *itemsAnnotations;
@property (nonatomic,retain) NSArray* routes;
@property (nonatomic) BOOL videoFeed;


- (void)creatUI;
- (void)creatMap;
- (void)setDDListHidden:(BOOL)hidden;

- (void)creaRoute;
- (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
- (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t;
- (void) centerMap;

- (void)setHighwayIndex:(NSInteger)index;
- (void)setPushMode:(BOOL)pushMode;
- (void)makePolylineWithLocations:(NSArray *)newLocations;@end
