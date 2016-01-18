//
//  BFindMeViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/22/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "CheckNetwork.h"

#import "Place.h"
#import "PlaceMark.h"
#import "GMSAnnotationView.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BFindMeViewController : BaseViewController<GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    GMSMapView* _mapView;
    BOOL isFirstLocation;
}

@end
