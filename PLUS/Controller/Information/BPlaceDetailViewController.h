

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

@interface BPlaceDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate> {
    NSMutableArray *menuArray;
    
    CLLocation *currentLocation;
    CLLocationManager *locManager;
    BOOL isGetLoc;
}

@property (nonatomic,copy)  NSDictionary *nearbyDict;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) CLLocationManager *locManager;

@end
