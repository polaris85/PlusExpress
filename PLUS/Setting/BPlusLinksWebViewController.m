
#import "BPlusLinksWebViewController.h"
#import "Constants.h"
@interface BPlusLinksWebViewController ()

@end

@implementation BPlusLinksWebViewController
@synthesize urlStr = _urlStr;
@synthesize plusLinksWebVCTitleStr = _plusLinksWebVCTitleStr;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleStr = _plusLinksWebVCTitleStr;
    
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

    CGRect webRect = CGRectMake(0,TOP_HEADER_HEIGHT+statusBarHeight,320,self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight);
    
	UIWebView *myWebView = [[UIWebView alloc] initWithFrame:webRect];
	myWebView.scalesPageToFit = YES;
	myWebView.delegate = self;
   
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"%@",_urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSLog(@"%@",[NSString stringWithFormat:@"http://%@",_urlStr]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
    
	
	[self.view addSubview:myWebView];	
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidStartLoad");    
    [self creatHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
   // NSLog(@"webViewDidFinishLoad");
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
