//
//  BPlusLinksPrivacyPolicyViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksPrivacyPolicyViewController.h"
#import "Constants.h"
@interface BPlusLinksPrivacyPolicyViewController ()

@end

@implementation BPlusLinksPrivacyPolicyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Privacy Policy", nil);
    
    [self createUI];
}

- (void)createUI {
    
    UIWebView *privacyWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight)];
    [privacyWebView setDelegate:self];
    [privacyWebView setScalesPageToFit:TRUE];
    [[self view] addSubview:privacyWebView];
    
    NSString* url = @"http://www.plusmiles.com.my/privacy-notice1.aspx";
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [privacyWebView loadRequest:request];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self creatHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
}
@end
