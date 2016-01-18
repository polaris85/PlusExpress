//
//  BTabbarViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BTabbarViewController.h"
#import "TabScrollView.h"
#import "ViewController.h"
#import "BHomeViewController.h"
@interface BTabbarViewController ()

@end

@implementation BTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*
        BHomeViewController *homeVC = [[BHomeViewController alloc] init];
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];

        ViewController *mapsVC = [[ViewController alloc] init];
        UINavigationController *mapsNav = [[UINavigationController alloc] initWithRootViewController:mapsVC] ;

        ViewController *liveTrafficVC = [[ViewController alloc] init] ;
        UINavigationController *liveTrafficNav = [[UINavigationController alloc] initWithRootViewController:liveTrafficVC] ;
 
        ViewController *nearbyVC = [[ViewController alloc] init] ;
        UINavigationController *nearbyNav = [[UINavigationController alloc] initWithRootViewController:nearbyVC] ;

        ViewController *journeyVC = [[ViewController alloc] init] ;
        UINavigationController *journeyNav = [[UINavigationController alloc] initWithRootViewController:journeyVC] ;

        ViewController *twitterVC = [[ViewController alloc] init] ;
        UINavigationController *twitterNav = [[UINavigationController alloc] initWithRootViewController:twitterVC] ;
                
        ViewController *moreVC = [[ViewController alloc] init] ;
        UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:moreVC] ;
        
        self.viewControllers = [NSArray arrayWithObjects:homeNav,mapsNav,liveTrafficNav,nearbyNav,journeyNav,twitterNav, moreNav, nil];
        */
        
        [self setSelectedIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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

// Method implementations
- (void)hideTabBar
{
    for (UIView *view in self.tabBar.subviews) {
        [view setHidden:TRUE];
        if([view isKindOfClass:[TabScrollView class]]) {
            [view setHidden:YES];
        }
    }
}

- (void)showTabBar
{
    for(UIView *view in self.tabBar.subviews) {
        if([view isKindOfClass:[TabScrollView class]]) {
            [view setHidden:NO];
        }
    }
}
@end
