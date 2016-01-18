//
//  AppDelegate.m
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "AppDelegate.h"
#import "DBUpdate.h"
#import "DBMigration.h"
#import "BLiveTrafficViewController.h"
#import "BHomeViewController.h"
#import "ResultOfArrayOfCodeo_PHb66yK.h"
#import "TblNotification.h"

@implementation AppDelegate
@synthesize tabBarController;
@synthesize myStoryBoard;
@synthesize agreeVc;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"livetrafficViewController"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSDictionary *aps = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSDictionary *userInfo = [aps objectForKey:@"aps"];
    NSLog(@"UserInfo=%@", userInfo);
    
    if (userInfo != nil) {
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        NSString *strMessage = [[userInfo objectForKey:@"aps" ] objectForKey:@"alert"];
        NSLog(@"%@", strMessage);
        
        NSString *idLiveTraffic = [userInfo objectForKey:@"idLiveTraffic" ];
        NSString *idHighway = [userInfo objectForKey:@"idHighway" ];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dateString = [dateFormat stringFromDate:today];
        NSLog(@"date: %@", dateString);
        
        [DBUpdate insert:@"tblNotification" columnName:@"strMessage, idLiveTraffic, idHighway, dtReceived" values:[NSString stringWithFormat:@"%@,%@,%@,%@", strMessage, idLiveTraffic, idHighway, dateString]];
    }
    
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy GetCountryCodes:kAccessCode :kAccessPassword];
    
    // Google Maps
    //[GMSServices provideAPIKey:@"AIzaSyCSxIQoP803mArXAtKbBK9nFtrEpTPE1RQ"];
    [GMSServices provideAPIKey:@"AIzaSyCu8HOMWOOg3MPSbIOY36WMh5_-2F1hMQg"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstInstall"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Setting.SyncData"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Google" forKey:@"Setting.Map"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[self uuid] forKey:@"uuid"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"phaseTwoUpdate"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"phaseTwoUpdate"];
    }
      
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-46832443-2"];
    
    return YES;
}

- (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"token : %@", token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"pushToken"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    
    UIApplicationState state = [application applicationState];
    NSLog(@"%@", userInfo);
    
    if (userInfo) {
        
        NSString *strMessage = [[userInfo objectForKey:@"aps" ] objectForKey:@"alert"];
        NSLog(@"%@", strMessage);
        
        NSInteger idLiveTraffic = [[userInfo objectForKey:@"idLivetraffic"] integerValue];
        NSInteger idHighway = [[userInfo objectForKey:@"idHighway" ] integerValue];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dateString = [dateFormat stringFromDate:today];
        NSLog(@"date: %@", dateString);
        
        NSString *condition = [NSString stringWithFormat:@"idHighway='%ld' and idLiveTraffic='%ld' and strMessage='%@'", (long)idHighway, (long)idLiveTraffic, strMessage ];
        
        [condition stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([DBUpdate checkWithTableName:@"tblNotification" condition:condition]) {
            
        }else{
            [DBUpdate insert:@"tblNotification" columnName:@"strMessage, idLiveTraffic, idHighway, dtReceived" values:[NSString stringWithFormat:@"'%@','%ld','%ld','%@'", strMessage, (long)idLiveTraffic, (long)idHighway, dateString]];
        }
        [vc dismissViewControllerAnimated:NO completion:nil];
        
        [vc setHighwayIndex:idHighway];
        [vc setPushMode:YES];
        UIViewController *root = self.window.rootViewController;
        [root presentViewController:vc animated:YES completion:nil];
        
    }
    
    if(state == UIApplicationStateActive){
        
        NSString *message = [[userInfo valueForKey:@"aps" ] valueForKey: @"alert"];
        NSLog(@"%@", message);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Proxy Delegate

//if service recieve an error this method will be called
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    proxy = nil;
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    ResultOfArrayOfCodeo_PHb66yK *result = (ResultOfArrayOfCodeo_PHb66yK *)data;
    NSData *codesData = [NSKeyedArchiver archivedDataWithRootObject:result.data];
    if ([method isEqualToString:@"GetCountryCodes"]) {
        [defaults setObject:codesData forKey:@"Plus.CountryCodes"];
        [proxy GetStateCodes:kAccessCode :kAccessPassword];
    } else if ([method isEqualToString:@"GetStateCodes"]) {
        [defaults setObject:codesData forKey:@"Plus.StateCodes"];
        [proxy GetNationalityCodes:kAccessCode :kAccessPassword];
    } else {
        [defaults setObject:codesData forKey:@"Plus.NationalityCodes"];
    }
    [defaults synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
