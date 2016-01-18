

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BTollFareOSVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *highWayArray;
    NSMutableArray *highWayDetailArray;
    NSMutableArray *tollFareOSArray;
}

- (void)creatTollFareOSData;
- (void)creatUI;
- (void)updateHeadView;
@end
