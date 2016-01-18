//
//  BInformationCCTVDetailViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BInformationCCTVDetailViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
@interface BInformationCCTVDetailViewController ()

@end

@implementation BInformationCCTVDetailViewController
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = [NSString stringWithFormat: @"Live Feed-%@", [data objectForKey:@"strDescription"]];
    [self creatUI];

    int padding = 10;
    if (IS_IPAD) {
        padding = 20;
    }
    
    NSString *strURL = [[data objectForKey:@"strURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, self.view.frame.size.width-padding*2, 240/320.0f*(self.view.frame.size.width-padding*2))];
    [imageView setImage:[UIImage imageNamed:@"no_image.png"]];
    
    UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:strURL]]; //Img_URL is NSString of your image URL
    if (img) {       //If image is previously downloaded set it and we're done.
        [imageView setImage:img];
        [[SDImageCache sharedImageCache] removeImageForKey:strURL fromDisk:YES];
    }else{
        [imageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"VideoPlaceholder.png"] success:^(UIImage *image, BOOL cached) {
            NSLog(@"Success");
        } failure:^(NSError *error) {
            NSLog(@"Error=%@", error);
        }];
    }

    [pictureScrollView addSubview:imageView];
    
    CLLocationCoordinate2D moveToCoordinate = CLLocationCoordinate2DMake([[data objectForKey:@"floLat"] floatValue], [[data objectForKey:@"floLong"] floatValue]);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:moveToCoordinate];
    marker.icon = [UIImage imageNamed:@"liveTrafficType13Marker.png"];
    marker.title = [data objectForKey:@"strDescription"];
    marker.map = _mapView;
    
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:moveToCoordinate.latitude
                                longitude:moveToCoordinate.longitude
                                     zoom:14];
    [_mapView animateToCameraPosition:camera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UI

- (void)creatUI{
    
    float picutureHeight = 240.0f;
    if (IS_IPAD) {
        picutureHeight = 240.0/320.0 *self.view.frame.size.width;
        
    }
    pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, picutureHeight)];
	pictureScrollView.contentSize = CGSizeMake(1 * self.view.frame.size.width, pictureScrollView.frame.size.height);
	pictureScrollView.pagingEnabled = YES;
	pictureScrollView.delegate = self;
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    pictureScrollView.backgroundColor = [UIColor blackColor];
    [pictureScrollView setTag:111];
    [self.view addSubview:pictureScrollView];
    
    [self creatMap];
}
-(void)creatMap
{
    CGRect rect=CGRectMake(0, pictureScrollView.frame.origin.y + pictureScrollView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - pictureScrollView.frame.origin.y - pictureScrollView.frame.size.height);
	
    _mapView = [[GMSMapView alloc] initWithFrame:rect];
    _mapView.myLocationEnabled = YES;
    _mapView.trafficEnabled = NO;
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
    int buttonSize = 32;
    int padding = 10;
    if (IS_IPAD) {
        buttonSize = 64;
        padding = 20;
    }
    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLocationBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding, buttonSize, buttonSize);
    [currentLocationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [currentLocationBtn setBackgroundColor:[UIColor whiteColor]];
    [currentLocationBtn addTarget:self action:@selector(goToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationBtn];
    
    UIButton *roadOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    roadOptionBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding+buttonSize+1, buttonSize, buttonSize);
    [roadOptionBtn setImage:[UIImage imageNamed:@"traffic.png"] forState:UIControlStateNormal];
    [roadOptionBtn setBackgroundColor:[UIColor whiteColor]];
    [roadOptionBtn addTarget:self action:@selector(changeTrafficOption) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:roadOptionBtn];
    
    UIButton *mapOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapOptionBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, _mapView.frame.origin.y+padding+buttonSize+1+buttonSize+1, buttonSize, buttonSize);
    [mapOptionBtn setImage:[UIImage imageNamed:@"satellite.png"] forState:UIControlStateNormal];
    [mapOptionBtn setBackgroundColor:[UIColor whiteColor]];
    [mapOptionBtn addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapOptionBtn];
    
    
    UIButton *zoomOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomOutBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, self.view.frame.size.height-padding-buttonSize-1-buttonSize, buttonSize, buttonSize);
    [zoomOutBtn setImage:[UIImage imageNamed:@"map_plus.png"] forState:UIControlStateNormal];
    [zoomOutBtn setBackgroundColor:[UIColor whiteColor]];
    [zoomOutBtn addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoomOutBtn];
    
    UIButton *zoomInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomInBtn.frame = CGRectMake(self.view.frame.size.width-padding-buttonSize, self.view.frame.size.height-padding-buttonSize, buttonSize, buttonSize);
    [zoomInBtn setImage:[UIImage imageNamed:@"map_minus.png"] forState:UIControlStateNormal];
    [zoomInBtn setBackgroundColor:[UIColor whiteColor]];
    [zoomInBtn addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoomInBtn];
}

- (void)changeTrafficOption
{
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        _mapView.trafficEnabled = !_mapView.trafficEnabled;
    }
}
- (void)changeMapType
{
    if (_mapView.mapType == kGMSTypeSatellite) {
        _mapView.mapType = kGMSTypeNormal;
    }else{
        _mapView.mapType = kGMSTypeSatellite;
    }
}

- (void)zoomIn
{
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        [_mapView animateToZoom:(_mapView.camera.zoom/1.2)];
    }
}
- (void)zoomOut
{
    NSLog(@"Zoom=%f", _mapView.camera.zoom);
    if(_mapView){
        [_mapView animateToZoom:(_mapView.camera.zoom * 1.2)];
    }
}

#pragma mark - UIButton

- (void)goToCurrentLocation{
    
    if ([CheckNetwork connectedToNetwork]) {
        NSLog(@"Lat=%f, Lng=%f", _mapView.myLocation.coordinate.latitude, _mapView.myLocation.coordinate.longitude);
        [_mapView animateToLocation:_mapView.myLocation.coordinate];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end