//
//  BSplashViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HttpData.h"
#import "JSON.h"

#import "CheckNetwork.h"

@interface BSplashViewController : UIViewController<CLLocationManagerDelegate>
{
    
    //UIImageView *progressImageView;
    UIActivityIndicatorView *activity;
    UILabel *loadingLabel;
    
    UIDevice *device;
    NSString *strOS;
    NSString *strUniqueId;
    int deviceType;
    
    CLLocation *currentLocation;
    CLLocationManager *locManager;
    BOOL isGetLoc;
    
    MPMoviePlayerController *player;
}

@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locManager;

- (void)creatUI;
- (void)retrieveAnnouncement;

- (void)goToTabbar;
@end
