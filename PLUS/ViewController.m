//
//  ViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *mapView_;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}
- (void) viewWillAppear:(BOOL)animated{
    //BAgreementViewController *agreeView = [[BAgreementViewController alloc] init];
    //[self presentViewController:agreeView animated:NO completion:nil];
    //if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        //[self performSegueWithIdentifier:@"go_accept" sender:nil];
    //}else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Setting.SyncData"]) {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Setting.SyncData"])
        [self performSegueWithIdentifier:@"go_splash" sender:nil];
    //}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
