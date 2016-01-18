

#import <UIKit/UIKit.h>

typedef enum{
    DDlistFrom,
    DDlistTo,
    DDlistClass,
} DDlistTag;

@protocol JourneyDDlistDelegate <NSObject>

- (void)passValue:(int)value listTag:(int)tag;

@end
@interface JourneyDDList : UITableViewController {
	NSArray	*_resultList;
	id <JourneyDDlistDelegate>	_delegate;
    
    int ddlistTag;
}
@property (nonatomic, retain)NSArray	*_resultList;
@property (assign) id <JourneyDDlistDelegate> _delegate;
@property int ddlistTag;
@end
