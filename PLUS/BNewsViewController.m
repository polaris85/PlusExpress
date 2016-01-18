

#import "BNewsViewController.h"
#import "Constants.h"
@interface BNewsViewController ()

@end

@implementation BNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Twitter";
    //[self creatAnnouncements];

    [self creatUI];
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

#pragma mark - UI

- (void)creatUI{

    CGRect webRect = CGRectMake(0,TOP_HEADER_HEIGHT+statusBarHeight,self.view.frame.size.width,self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight);
    
    float buttonSize = 16.0;
    if (IS_IPAD) {
        buttonSize = 32.0;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonSize, buttonSize)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBar setLeftButton:button];
    
    [backButton setHidden:YES];
    myWebView = [[UIWebView alloc] initWithFrame:webRect];
    myWebView.scalesPageToFit = YES;
    myWebView.delegate = self;
    NSString *urlStr = @"http://www.twitter.com/PLUSTrafik";
    //NSString *urlStr =  @"http://www.baidu.com";
    [self.view addSubview:myWebView];
   
    NSURL *url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if ([CheckNetwork connectedToNetwork]) {
        [myWebView loadRequest:request];
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected.Twitter is not accessible at the moment." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIButton

- (void)refresh{

    if (![CheckNetwork connectedToNetwork]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected.Twitter is not accessible at the moment." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    NSString *urlStr = @"http://www.twitter.com/PLUSTrafik";
   // NSString *urlStr =  @"http://www.baidu.com";
    NSURL *url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // NSLog(@"webViewDidStartLoad");
    
     [self creatHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    //[self creatHUDOnlyText:@"Success" isSuccess:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	//NSLog(@"Error: %@",error);
    [self hideHud];
    
    //[self creatHUDOnlyText:@"Fail" isSuccess:NO];
}
@end
