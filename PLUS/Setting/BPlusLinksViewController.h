
#import "BaseViewController.h"

@interface BPlusLinksViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *urlArray;
    NSArray *urlTitle;
    NSArray *urlIcon;
    NSArray *urlIcon_iPad;
    NSArray *urlActive;
}
- (void)creatUI;
@end
