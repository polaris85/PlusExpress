
#import "BaseViewController.h"
#import <MapKit/MapKit.h> 

@interface BSettingViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate> {
    UITableView *_tableView;
    UITextField *emailField;
    UITextField *pinField;
    
    UISwitch *GmapSwitchView;
    UISwitch *WazeSwitchView;
    
    CLLocation *currentLocation;
    CLLocationManager *locManager;
    BOOL isGetLoc;
    
    NSArray *highwayArr;
    
    BOOL isSettingMode;
}

@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locManager;

- (void)setSettingMode:(BOOL)mode;
@end
