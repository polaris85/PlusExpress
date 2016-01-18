

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h> 
#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface BJourneySearchResultVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    
    NSInteger carIndex;
    
    NSDictionary *idTollPlazaFromDic;
    NSDictionary *idTollPlazaToDic;
    
    NSMutableArray *routesArray;
    
    CLLocation *currentLocation;
    
    int runIndex;
    
    NSString *strDirection;
}

@property NSInteger carIndex;
@property (nonatomic,copy)NSDictionary *idTollPlazaFromDic;
@property (nonatomic,copy)NSDictionary *idTollPlazaToDic;
@property (nonatomic,copy) NSMutableArray *routesArray;
@property (nonatomic,copy)  NSString *strDirection;

- (void)creatUI;
@end
