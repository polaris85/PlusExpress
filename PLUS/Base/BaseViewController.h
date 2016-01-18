

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"
#import "MBProgressHUD.h"
#import "JHTickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "HttpData.h"
#import "JSON.h"
#import "RESideMenu.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>
{

    CustomNavigationBar *navigationBar;
        
    MBProgressHUD *HUD;
    
    NSString *titleStr;
    
    UILabel *titleLabel;
        
    UIView *titleView;
    
    JHTickerView *tickerView;
    
    UIAlertView *_alertView;
    
    CGFloat statusBarHeight;
    
    UIButton *backButton;
    
    int deviceType;
}
@property(nonatomic,retain) JHTickerView *tickerView;

- (void)creatAnnouncements;
- (void)creatHUD;
- (void)creatHUDOnlyText:(NSString *)result isSuccess:(BOOL)isSuccess;
- (void)hideHud;
- (void)showLoadingAlertWithTitle:(NSString *)aTitle;
- (void)showAlertViewWithTitle:(NSString *)aTitle duration:(CGFloat)duration;
- (void)showAlertViewWithTitle:(NSString *)aTitle message:(NSString *)aMessage duration:(CGFloat)duration;
- (void)hideAlertView;
- (void)back;
- (double)heightOfString:(NSString *)string withLabel:(UILabel *)currentLabel;

@end
