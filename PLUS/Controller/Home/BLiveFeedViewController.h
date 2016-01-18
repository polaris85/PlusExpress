//
//  BLiveFeedViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/20/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"

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

#import "SwipeView.h"
#import "CheckNetwork.h"
#import "GMSAnnotationView.h"
#import "HttpData.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "DDList.h"
#import "PassValueDelegate.h"

#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BLiveFeedViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, SwipeViewDataSource, SwipeViewDelegate, PassValueDelegate, GMSMapViewDelegate,ZZMKAnnotationDelegate>
{
    UIView *backgroundView;
    DDList *_ddList;
    BOOL isDDListHidden;
    int highWayIndex;
    UIButton *highWayBtn;
    UILabel *highWayLabel;
    UIImageView *heavyVehicleRestrictionView;
    UIButton *control_ddListHidden_Btn;
    
    NSMutableArray *mapAnnotations;
    NSMutableArray *itemsAnnotations;
    
    ASIHTTPRequest *request;
    NSMutableArray *highWayArray;
    NSMutableArray *tempArray;
    NSMutableArray *liveUpdateArray;
    
    NSMutableArray *markerArray;
    GMSMapView* _mapView;
    GMSPolyline *routeLine;
    
    int mapTypeIndex;
    int intParentType;
    int segmentIndex;
    NSMutableArray *btnArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet SwipeView *swipeView;

@property(nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableArray *itemsAnnotations;
@property (nonatomic,retain) NSArray* routes;

- (void)creatUI;

@end
