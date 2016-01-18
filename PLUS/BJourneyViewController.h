

#import "BaseViewController.h"
#import "UIUnderlinedButton.h"
#import "JourneyDDList.h"


@interface BJourneyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,JourneyDDlistDelegate>
{
    UITableView *table;
    
    JourneyDDList *_ddListFrom;
    JourneyDDList *_ddListTo;
    JourneyDDList *_ddListClass;
    BOOL isDDlistFromHidden;
    BOOL isDDlistToHidden;
    BOOL isDDlistClassHidden;
    
    NSArray *fromArray;
    NSArray *toArray;

    int fromIndex;
    int toIndex;
    int carIndex;
}
- (void)creatUI;
- (void)setDDListFromHidden;
- (void)setDDListToHidden;
- (void)setDDListClassHidden;
@end
