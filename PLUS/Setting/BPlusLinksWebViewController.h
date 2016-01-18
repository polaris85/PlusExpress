

#import "BaseViewController.h"

@interface BPlusLinksWebViewController : BaseViewController<UIWebViewDelegate>{

    NSString *urlStr;
    NSString *plusLinksWebVCTitleStr;
}

@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *plusLinksWebVCTitleStr;

- (void)creatUI;
@end
