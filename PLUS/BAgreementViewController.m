//
//  BAgreementViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BAgreementViewController.h"
#import "BSplashViewController.h"
#import "Constants.h"
@interface BAgreementViewController ()

@end

@implementation BAgreementViewController
@synthesize myScrollView;
@synthesize unAcceptBtn;
@synthesize acceptBtn;
@synthesize agreenWebView;
@synthesize navBar;
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
    // Do any additional setup after loading the view.
    
    CGFloat statusBarHeight = 0;
    if (IS_iOS_7_OR_LATER) {
        statusBarHeight = 20;
    }
    
    [navBar setFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, TOP_HEADER_HEIGHT)];
    NSBundle *thisBundle = [NSBundle mainBundle];
	NSString *path = [thisBundle pathForResource:@"agreement" ofType:@"htm"];
    NSLog(@"Path=%@", path);
	NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.agreenWebView setFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    self.agreenWebView.scalesPageToFit = YES;
    [self.agreenWebView loadRequest:request];
    
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    
    int navHeight = 40;
    int buttonSize = 16;
    if (IS_IPAD) {
        navHeight = 84;
        buttonSize = 32;
    }
    
    if (isSettingMode) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(8, statusBarHeight+navHeight, buttonSize, buttonSize);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agree:(UIButton *)sender{
    
    [self firstTimeLoad];
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstInstall"];
    
    //[self dismissViewControllerAnimated:NO completion:nil];
    //if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
    //[self registerDevice];
}

//FirstTimeLoad
- (void)firstTimeLoad{
    
    if ([CheckNetwork connectedToNetwork]){
        
        UIDevice *device = [UIDevice currentDevice];
        int deviceType;
        if ([device.model isEqualToString:@"iPad"]) {
            deviceType = 1;
            
        }else {
            deviceType = 0;
        }
        NSString *strOS = [NSString stringWithFormat:@"IOS %@",device.systemVersion];
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didFirstTimeLoadFinished:);
        httpData.didFailed = @selector(didFirstTimeLoadFinishedError);
        [httpData firstTimeLoad:deviceType strUniqueId:strUniqueId strOS:strOS];
    }
}

- (void)didFirstTimeLoadFinished:(id)data{
    NSLog(@"didFirstTimeLoadFinished:%@",data);
    //if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstInstall"];
        
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"]  animated:NO];
        //[self.navigationController popViewControllerAnimated:NO];
}

- (void)didFirstTimeLoadFinishedError{
    
}

//FirstTimeLoad
- (void)registerDevice{
    
    if ([CheckNetwork connectedToNetwork]){
        
        UIDevice *device = [UIDevice currentDevice];
        int deviceType;
        if ([device.model isEqualToString:@"iPad"]) {
            deviceType = 1;
        }else {
            deviceType = 0;
        }
        NSString *strOS = [NSString stringWithFormat:@"IOS %@",device.systemVersion];
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didFirstTimeLoadFinished:);
        httpData.didFailed = @selector(didFirstTimeLoadFinishedError);
        [httpData registerDevice:deviceType strUniqueId:strUniqueId strOS:strOS];
    }
}

- (void)didRegisterDeviceFinished:(id)data{
    NSLog(@"didRegisterDeviceFinished:%@",data);
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstInstall"];
        
        //BSplashViewController *splash = [[BSplashViewController alloc] init];
        //[self.navigationController pushViewController:splash animated:YES];
        //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"] animated:YES];

    }
}

- (void)didRegisterDeviceFinishedError{
    
}

- (IBAction)colse:(id)sender{
    
    exit(0);
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSettingMode:(BOOL)mode {
    isSettingMode = mode;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat statusBarHeight = 0;
    if (IS_iOS_7_OR_LATER) {
        statusBarHeight = 20;
    }
    
    self.myScrollView.frame = CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight);
    UIScrollView *scrollView = [[webView subviews] objectAtIndex:0];
    
    self.agreenWebView.frame = CGRectMake(10, 0, self.view.frame.size.width-20, scrollView.contentSize.height);
    
    self.acceptBtn.hidden = NO;
    self.acceptBtn.frame = CGRectMake(self.view.frame.size.width-77-11, scrollView.contentSize.height+10, 77, 30);
    
    self.unAcceptBtn.hidden = NO;
    self.unAcceptBtn.frame = CGRectMake(11, scrollView.contentSize.height+10, 139, 30);
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollView.contentSize.height+50);
    
    if (isSettingMode) {
        self.acceptBtn.hidden = YES;
        self.unAcceptBtn.hidden = YES;
    }
}

@end
