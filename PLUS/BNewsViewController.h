
#import "BaseViewController.h"
#import "CheckNetwork.h"

@interface BNewsViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *myWebView;
}

- (void)creatUI;
@end
