//
//  WebViewController.m
//  PLUS
//
//  Created by Ben Folds on 10/9/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"
@interface WebViewController ()

@end

@implementation WebViewController

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
    
    titleLabel.text = @"About Us";
    
    [self createUI];
    
}
- (void)createUI {
   
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.aviven.net/"]]];
    [[self view] addSubview:webView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
