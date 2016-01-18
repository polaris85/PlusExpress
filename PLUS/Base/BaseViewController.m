

#import "BaseViewController.h"
#import "CustomNavigationBar.h"
#import "CycleScrollView.h"
#import "TblAnnouncements.h"
#import "Constants.h"
#define MAX_BACK_BUTTON_WIDTH 80.0

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize tickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    //self.view.backgroundColor = [UIColor whiteColor];
    
    
     navigationBar = [[CustomNavigationBar alloc] init];
    
    /*
    [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(presentLeftMenuViewController:)];
     */
    [self.view addSubview:navigationBar];
    
    statusBarHeight = 0;
    if (IS_iOS_7_OR_LATER) {
        statusBarHeight = 20;
    }
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        deviceType = DEVICE_TYPE_IPAD;
    }else {
        deviceType = DEVICE_TYPE_IPHONE;
    }
    
    // Set the title view to the Instagram logo
    /*
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(125, 12 + statusBarHeight, 105, 20);
    //btn.backgroundColor = [UIColor yellowColor];
    //btn.alpha = 0.5;
    //[btn setTitle:@"1800-88-0000" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithRed:0.38 green:0.39 blue:0.40 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:btn]; 
    */
    
    int width = 320;
    int navHeight = 40;
    int titleHeight = 24;
    int fontSize = 13;
    int padding = 10;
    int backButtonSize = 16;
    NSString *headerImage = @"header_bg.png";
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        width = 768;
        navHeight = 84;
        titleHeight = 48;
        headerImage = @"header_bg_ipad.png";
        fontSize = 25;
        padding = 20;
        backButtonSize = 32;
    }
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight + statusBarHeight, width, titleHeight)];
    //titleView.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView setUserInteractionEnabled:YES];
    [self.view addSubview:titleView];
        
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, backButtonSize)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:titleLabel];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0.0, backButtonSize, backButtonSize)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [backButton addTarget:self
               action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:backButton];
     
}

- (void)creatAnnouncements
{
    
    int width = 320;
    int navHeight = 40;
    int titleHeight = 24;
    int padding = 20;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        width = 768;
        navHeight = 84;
        titleHeight = 48;
        padding = 40;
    }
    
    JHTickerView *ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(padding, navHeight + statusBarHeight, self.view.frame.size.width-padding*2, titleHeight)];
    self.tickerView = ticker;
    self.tickerView.backgroundColor = [UIColor clearColor];
    [self.tickerView setDirection:JHTickerDirectionLTR];
    [self.tickerView setTickerSpeed:75.0f];
    [self.view addSubview:self.tickerView];
    
    NSMutableArray *announcements = [NSMutableArray arrayWithArray:[TblAnnouncements searchAnnouncements]];
    if (announcements.count>0) {
        
        @try {
            if (titleLabel.text.length > 0) {
                [announcements insertObject:titleLabel.text atIndex:0];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"error : %@", exception.reason);
        }
        @finally {
            [self.tickerView setTickerStrings:announcements];
            titleLabel.hidden = YES;
        }
    }
    [self.tickerView start];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatAnnouncementArray:) name:@"StartAnnouncement" object:nil]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}


- (void)creatAnnouncementArray:(NSNotification *)noti{
    
    NSLog(@"Announcement ====%@",[noti object]);

   // [[NSUserDefaults standardUserDefaults] setObject:[noti object] forKey:@"AnnouncementArray"];

    NSMutableArray *array = [NSMutableArray arrayWithArray:[TblAnnouncements searchAnnouncements]];
    if (array.count>0) {
        
        if (titleLabel.text.length > 0) {
            [array insertObject:titleLabel.text atIndex:0];
        }
        [self.tickerView setTickerStrings:array];
        self.tickerView.hidden = NO;
        titleLabel.hidden = YES;
    }else {

        [self.tickerView setTickerStrings:nil];
        self.tickerView.hidden = YES;
        titleLabel.hidden = NO;
    }
}


#pragma mark - UIButton
- (void)makeCall
{
    
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"1800-88-0000"]];
   // NSLog(@"make call, URL=%@", phoneNumberURL);
    [[UIApplication sharedApplication] openURL:phoneNumberURL]; 
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HUD

- (void)creatHUD{
       
    if (!HUD) {
        
       // NSLog(@"+++++++++++++");
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"loading...";
        [self.view addSubview:HUD];
        [HUD show:YES];
    }
}

- (void)creatHUDOnlyText:(NSString *)result isSuccess:(BOOL)isSuccess{

     MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	
    hud.customView = isSuccess?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]]:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Errormark.png"]];
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = self;
    hud.labelText = result;
	//HUD.detailsLabelText = result;
    [hud show:YES];
	[hud hide:YES afterDelay:1.5];
}

- (void)hideHud{
    
    if (HUD) {
        
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
  //  NSLog(@"hudWasHidden === YES");
    
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - Alert

- (void)showLoadingAlertWithTitle:(NSString *)aTitle {
	_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:aTitle
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil];
	UIActivityIndicatorView *_indicatorView = [[UIActivityIndicatorView alloc]
                                               initWithFrame:CGRectMake(125.0f, 50.0f, 30.0f, 30.0f)];
	[_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[_indicatorView setHidesWhenStopped:YES];
	[_indicatorView startAnimating];
	
    [_alertView addSubview:_indicatorView];
	[_alertView show];
}

- (void)showAlertViewWithTitle:(NSString *)aTitle duration:(CGFloat)duration {
	[self showAlertViewWithTitle:aTitle message:nil duration:duration];
}

- (void)showAlertViewWithTitle:(NSString *)aTitle message:(NSString *)aMessage duration:(CGFloat)duration {
	_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:aTitle
                                            message:aMessage
                                           delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil];
	[_alertView show];
	
	[self performSelector:@selector(hideAlertView) withObject:nil afterDelay:duration];
}

- (void)hideAlertView {
	if (_alertView)
		[_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (double)heightOfString:(NSString *)string withLabel:(UILabel *)currentLabel {
    CGRect currentFrame = currentLabel.frame;
    CGSize max = CGSizeMake(currentLabel.frame.size.width, 10000.0f);
    CGSize expected = [string sizeWithFont:currentLabel.font constrainedToSize:max lineBreakMode:currentLabel.lineBreakMode];
    currentFrame.size.height = expected.height;
    return currentFrame.size.height;
}

@end
