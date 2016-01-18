

#import "MapViewController.h"
#import "Constants.h"
@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    map.mapType = MKMapTypeStandard;
    
    /****ok*****/
    
    CLLocationCoordinate2D theCoordinate;
    
    theCoordinate.longitude=101.68730833333333;
    theCoordinate.latitude=3.04663611111111;
    
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.1;
    theSpan.longitudeDelta=0.1;
    
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    
    [map setRegion:theRegion];
    [self.view addSubview:map];
    
    
    MKPointAnnotation *ann=[[MKPointAnnotation alloc] init];
    ann.coordinate=theCoordinate;
    [map addAnnotation:ann];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.86, 20, 50, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_remove"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];

}
- (void)doBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
