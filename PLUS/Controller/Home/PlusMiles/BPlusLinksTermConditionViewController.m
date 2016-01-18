//
//  BPlusLinksTermConditionViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksTermConditionViewController.h"
#import "Constants.h"
@interface BPlusLinksTermConditionViewController ()

@end

@implementation BPlusLinksTermConditionViewController

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
    self.title = NSLocalizedString(@"Terms and Conditions", nil);
    
    [self createUI];
}

- (void)createUI {
    
    UIWebView *termWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight)];
    [termWebView setDelegate:self];
    [termWebView setScalesPageToFit:TRUE];
    [[self view] addSubview:termWebView];
    
    NSString* url = @"http://www.plusmiles.com.my/Member/PopUpTermsAndConditions.aspx";
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [termWebView loadRequest:request];
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
