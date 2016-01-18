//
//  BFacilitiesViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DropDownScroll.h"
#import "SEFilterControl.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BFacilitiesViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource, DropDownScrollDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *highWayArray;
    NSMutableArray *highWayDetailArray;
    NSMutableArray *petrolArray;
    NSMutableArray *atmArray;
    NSMutableArray *facilityArray;
    NSMutableArray *facilityTypeArray;
    
    int segmentIndex;
    int facilityIndex;
    NSMutableArray *btnArray;
    UITableView *table;
    
    CLLocation *currentLocation;
    
    CLLocationManager *locManager;
    
    BOOL isGetLoc;
    
    UISlider *distanceFilter;
    
    float currentDistance;
    
    int tapCount;
}

@property (nonatomic,retain) CLLocationManager *locManager;
@property (nonatomic,retain) CLLocation *currentLocation;
- (void)creatFacilityArray:(float)distance location:(CLLocation *)location;
- (void)creatRsaData;
- (void)creatUI;
@end
