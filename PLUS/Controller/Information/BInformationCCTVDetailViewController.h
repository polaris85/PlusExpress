//
//  BInformationCCTVDetailViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CheckNetwork.h"
@interface BInformationCCTVDetailViewController : BaseViewController<UIScrollViewDelegate, UIWebViewDelegate, GMSMapViewDelegate> {
    UIScrollView *pictureScrollView;
    UIPageControl *picturePageControl;
    GMSMapView* _mapView;
    
    int pictureLoadCount;
    
    UILabel *descriptionView;
}

@property (nonatomic,retain) NSDictionary *data;

- (void)creatUI;
- (void)creatMap;
@end
