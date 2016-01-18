//
//  BInformationViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "CheckNetwork.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UIButton+WebCache.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GMSAnnotationView.h"

@interface BInformationViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, GMSMapViewDelegate>
{
    UITableView *table;
    UIView *contentView;
    
    UIView *pictureViewer;
    UIScrollView *pictureScrollView;
    UIPageControl *picturePageControl;
    int pictureLoadCount;
    
    CLLocation *currentLocation;
    CLLocationManager *locManager;
    BOOL isGetLoc;
    
    int currentViewOption;
    GMSMapView* _mapView;
}
@property (nonatomic,retain) NSDictionary *infoDic;
@property (nonatomic,retain) NSMutableArray *infoPictureArr;
@property (nonatomic,retain) NSMutableDictionary *infoPicture;
@property (nonatomic,retain) NSMutableArray *serVicesArray;

@property (nonatomic,retain) NSString *strName;
@property (nonatomic,retain) NSString *decLocation;
@property (nonatomic,retain) NSString *strDirection;
@property (nonatomic,retain) NSString *strSignatureName;
@property (nonatomic,retain) NSString *strOperationHour;

@property (nonatomic,retain) NSString *idParent;

@property NSInteger intParentType;
@property NSInteger intStrType;

@property BOOL isFromFacility;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locManager;


- (void)creatData;
- (void)creatUI;
-(NSString *) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;

@end