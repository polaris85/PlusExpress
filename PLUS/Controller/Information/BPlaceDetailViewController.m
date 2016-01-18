

#import "BPlaceDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "CheckNetwork.h"
#import "DEFacebookComposeViewController.h"
#import "tblNearByCatg.h"
#import "Constants.h"
@interface BPlaceDetailViewController ()

@end

@implementation BPlaceDetailViewController

@synthesize nearbyDict;
@synthesize currentLocation;
@synthesize locManager;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self creatAnnouncements];
    [self creatMenu];
    [self creatUI];
    [self CreatLocationManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
 
    [locManager stopUpdatingLocation];
    [locManager setDelegate:nil];
}

//- (void)creatMenu {
//    menuArray = [[NSMutableArray alloc]init];
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Call", @"name",
//                              [self.nearbyDict objectForKey:@"strContactNo"], @"content",
//                              @"1", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Directions", @"name",
//                              [self.nearbyDict objectForKey:@"floLatitude"], @"floLatitude",
//                              [self.nearbyDict objectForKey:@"floLongitude"], @"floLongitude",
//                              @"2", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"MapView", @"name",
//                              [self.nearbyDict objectForKey:@"floLatitude"], @"floLatitude",
//                              [self.nearbyDict objectForKey:@"floLongitude"], @"floLongitude",
//                              @"3", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"T&Cs", @"name",
//                              [self.nearbyDict objectForKey:@"strTermsConditions"], @"content",
//                              @"4", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"SMS", @"name",
//                              [self.nearbyDict objectForKey:@"strSMSMsg"], @"content",
//                              @"5", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"E-mail", @"name",
//                              [self.nearbyDict objectForKey:@"strEmailMsg"], @"content",
//                              @"6", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Facebook", @"name",
//                              [self.nearbyDict objectForKey:@"strFacebookMsg"], @"content",
//                              @"7", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Twitter", @"name",
//                              [self.nearbyDict objectForKey:@"strTwitterMsg"], @"content",
//                              @"8", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    if (YES) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Website", @"name",
//                              [self.nearbyDict objectForKey:@"strWebsite"], @"content",
//                              @"9", @"type",
//                              nil];
//        [menuArray addObject:dict];
//    }
//    
//}


- (void)creatMenu {
    menuArray = [[NSMutableArray alloc]init];
    if ([self.nearbyDict objectForKey:@"strContactNo"] && ![[self.nearbyDict objectForKey:@"strContactNo"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Call", @"name",
                              [self.nearbyDict objectForKey:@"strContactNo"], @"content",
                              @"1", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"floLatitude"] && ![[self.nearbyDict objectForKey:@"floLatitude"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Directions", @"name",
                              [self.nearbyDict objectForKey:@"floLatitude"], @"floLatitude",
                              [self.nearbyDict objectForKey:@"floLongitude"], @"floLongitude",
                              @"2", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"floLongitude"] && ![[self.nearbyDict objectForKey:@"floLongitude"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"MapView", @"name",
                              [self.nearbyDict objectForKey:@"floLatitude"], @"floLatitude",
                              [self.nearbyDict objectForKey:@"floLongitude"], @"floLongitude",
                              @"3", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strTermsConditions"] && ![[self.nearbyDict objectForKey:@"strTermsConditions"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"T&Cs", @"name",
                              [self.nearbyDict objectForKey:@"strTermsConditions"], @"content",
                              @"4", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strSMSMsg"] && ![[self.nearbyDict objectForKey:@"strSMSMsg"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"SMS", @"name",
                              [self.nearbyDict objectForKey:@"strSMSMsg"], @"content",
                              @"5", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strEmailMsg"] && ![[self.nearbyDict objectForKey:@"strEmailMsg"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"E-mail", @"name",
                              [self.nearbyDict objectForKey:@"strEmailMsg"], @"content",
                              @"6", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strFacebookMsg"] && ![[self.nearbyDict objectForKey:@"strFacebookMsg"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Facebook", @"name",
                              [self.nearbyDict objectForKey:@"strFacebookMsg"], @"content",
                              @"7", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strTwitterMsg"] && ![[self.nearbyDict objectForKey:@"strTwitterMsg"] isEqualToString:@""]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Twitter", @"name",
                              [self.nearbyDict objectForKey:@"strTwitterMsg"], @"content",
                              @"8", @"type",
                              nil];
        [menuArray addObject:dict];
    }
    if ([self.nearbyDict objectForKey:@"strWebsite"] && ![[self.nearbyDict objectForKey:@"strWebsite"] isEqualToString:@""]) {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Website", @"name",
                          [self.nearbyDict objectForKey:@"strWebsite"], @"content",
                          @"9", @"type",
                          nil];
    [menuArray addObject:dict];
    }
    
}

- (void)creatUI{
    float paddingLeft = 10.0;
    float imageSize = 80.0;
    float nameLabelHeight = 48.0;
    float descriptionLabelHeight = 24.0;
    float padding = 10.0;
    float fontSize = 15;
    float fontSize1 = 13;
    if (IS_IPAD) {
        fontSize = 30;
        fontSize1 = 26;
        paddingLeft = 20.0;
        imageSize = 160.0;
        nameLabelHeight = 96.0;
        descriptionLabelHeight = 48.0;
        padding = 20.0;
    }
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    UIImageView *picture = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, TOP_HEADER_HEIGHT+statusBarHeight+padding, imageSize, imageSize)];
    [picture setContentMode:UIViewContentModeScaleToFill];
    [picture setClipsToBounds:YES];
    NSString *strURL = [self.nearbyDict objectForKey:@"strLocationImg"];
    [picture setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"no_image.png"] success:^(UIImage *image, BOOL cached) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [picture setImage:image];
        });
    } failure:nil];
    
    [self.view addSubview:picture];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft+imageSize+padding, TOP_HEADER_HEIGHT+statusBarHeight+padding, self.view.frame.size.width-paddingLeft*3-imageSize, nameLabelHeight)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.numberOfLines = 2;
    [nameLabel setText:[self.nearbyDict objectForKey:@"strTitle"]];
    [self.view addSubview:nameLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft+imageSize+padding, nameLabel.frame.origin.y+nameLabel.frame.size.height+padding, self.view.frame.size.width-paddingLeft*3-imageSize, descriptionLabelHeight)];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionLabel setFont:[UIFont systemFontOfSize:fontSize1]];
    [descriptionLabel setTextColor:[UIColor whiteColor]];
    NSString *strNearByCatgName = [TblNearbyCatg searchNearbyCategoryById:[self.nearbyDict objectForKey:@"idNearbyCatg"]];
    [descriptionLabel setText:strNearByCatgName];
    [self.view addSubview:descriptionLabel];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, picture.frame.origin.y+picture.frame.size.height+padding, self.view.frame.size.width, self.view.frame.size.height-picture.frame.origin.y-picture.frame.size.height-padding) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorColor = [UIColor clearColor];
    table.backgroundColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
}

#pragma mark - CreatLocationManager

- (void)CreatLocationManager{
    
    CLLocationManager *temp = [[CLLocationManager alloc] init];
    self.locManager = temp;
    
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    [self.locManager startUpdatingLocation];
}

#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (!isGetLoc) {
        
        isGetLoc = YES;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        //CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
        self.currentLocation = location;
    }
    
    [manager stopUpdatingLocation];   
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    isGetLoc = NO;
    
    [manager stopUpdatingLocation];
}

#pragma mark - UIButton

- (void)click:(UIButton *)sender{
    int tag = [sender tag];
    NSDictionary *info = [menuArray objectAtIndex:tag];
    if ([[info objectForKey:@"type"] isEqualToString:@"1"]) {
        
        NSString *phoneNum = [info objectForKey:@"content"];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
        
    } else if ([[info objectForKey:@"type"] isEqualToString:@"2"]) {
        
        [self getDirection];
        
    } else if ([[info objectForKey:@"type"] isEqualToString:@"3"]) {
        
        [self showMap];
        
    } else if ([[info objectForKey:@"type"] isEqualToString:@"4"]) {
        /*
        ZZPlaceDetailTnCVC *vc = [[[ZZPlaceDetailTnCVC alloc] init] autorelease];
        [vc setPreloadText:[info objectForKey:@"content"]];
        [[self navigationController] pushViewController:vc animated:YES];
        */
    } else if ([[info objectForKey:@"type"] isEqualToString:@"5"]) {
//        [[UIApplication sharedApplication] openURL: @"sms:98765432"];
        /*
        MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        if([MFMessageComposeViewController canSendText])
            {
            controller.body = [info objectForKey:@"content"];
            controller.recipients = [NSArray arrayWithObjects:[nearbyDict objectForKey:@"strContactNo"], nil];
            controller.messageComposeDelegate = self;
//            [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
            [self presentModalViewController:controller animated:YES];
        }
        */
    } else if ([[info objectForKey:@"type"] isEqualToString:@"6"]) {
        /*
        if ([MFMailComposeViewController canSendMail])
            {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
//            [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
//            controller.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            [controller setSubject:@""];
            [controller setMessageBody:[info objectForKey:@"content"] isHTML:YES];
            [controller setToRecipients:[NSArray arrayWithObjects:@"",nil]];
            [self presentViewController:controller animated:YES completion:NULL];
            }
        */
    } else if ([[info objectForKey:@"type"] isEqualToString:@"7"]) {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion floatValue] >= 6.0) {     // supported ios 6.0
            // Device is able to send a Twitter message
            SLComposeViewController *composeController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [composeController setInitialText:[info objectForKey:@"content"]];
            
            SLComposeViewControllerCompletionHandler completionHandler =
            ^(SLComposeViewControllerResult result) {
                [composeController dismissViewControllerAnimated:YES completion:nil];
            };
            
            [composeController setCompletionHandler:completionHandler];
            [self presentViewController:composeController animated:YES completion:nil];
        } else {
            DEFacebookComposeViewControllerCompletionHandler completionHandler = ^(DEFacebookComposeViewControllerResult result) {
                switch (result) {
                    case DEFacebookComposeViewControllerResultCancelled:
                        NSLog(@"Facebook Result: Cancelled");
                        break;
                    case DEFacebookComposeViewControllerResultDone:
                        NSLog(@"Facebook Result: Sent");
                        break;
                }
                
                [self dismissModalViewControllerAnimated:YES];
            };
            
            DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            [facebookViewComposer setInitialText:[info objectForKey:@"content"]];
            facebookViewComposer.completionHandler = completionHandler;
            [self presentViewController:facebookViewComposer animated:YES completion:nil];
        }
    } else if ([[info objectForKey:@"type"] isEqualToString:@"8"]) {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion floatValue] >= 6.0) {     // supported ios 6.0
            // Device is able to send a Twitter message
            SLComposeViewController *composeController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [composeController setInitialText:[info objectForKey:@"content"]];
            
            SLComposeViewControllerCompletionHandler completionHandler =
            ^(SLComposeViewControllerResult result) {
                [composeController dismissViewControllerAnimated:YES completion:nil];
            };
            
            [composeController setCompletionHandler:completionHandler];
            [self presentViewController:composeController animated:YES completion:nil];
        }
        else {
            // Create the view controller
            TWTweetComposeViewController *composeController = [[TWTweetComposeViewController alloc] init];

            [composeController setInitialText:[info objectForKey:@"content"]];
            
            TWTweetComposeViewControllerCompletionHandler completionHandler =
            ^(TWTweetComposeViewControllerResult result) {
                [composeController dismissModalViewControllerAnimated:YES];
            };
            [composeController setCompletionHandler:completionHandler];
            [self presentModalViewController:composeController animated:YES];
        }
    } else if ([[info objectForKey:@"type"] isEqualToString:@"9"]) {
        /*
        NSString *urlStr = [info objectForKey:@"content"];
        ZZPlusLinksWebVC *vc = [[[ZZPlusLinksWebVC alloc] init] autorelease];
        vc.urlStr = urlStr;
        [[self navigationController] pushViewController:vc animated:YES];
         */
    }
    
}


- (void)getDirection {

    if (![CheckNetwork connectedToNetwork]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([[self.nearbyDict objectForKey:@"floLatitude"] length] >0 && [[self.nearbyDict objectForKey:@"floLongitude"] length] > 0) {
        double decLat = [[self.nearbyDict objectForKey:@"floLatitude"] doubleValue];
        double decLon = [[self.nearbyDict objectForKey:@"floLongitude"] doubleValue];

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Setting.Map"] isEqualToString:@"Google"]) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
                // Open google Maps application
                NSString *stringURL = [NSString stringWithFormat:@"comgooglemaps://??saddr=%g,%g&daddr=%g,%g", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude, decLat, decLon];
                NSURL *url = [NSURL URLWithString:stringURL];
                [[UIApplication sharedApplication] openURL:url];
            } else {
                // Google Maps is not installed. Launch AppStore to install Google Maps app
                [[UIApplication sharedApplication] openURL:[NSURL
                                                            URLWithString:@"http://itunes.apple.com/us/app/id585027354"]];
            }
        } else {
            if ([[UIApplication sharedApplication]
                 canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                
                // Waze is installed. Launch Waze and start navigation
                NSString *urlStr =
                [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
                 decLat, decLon];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                
            } else {
                
                // Waze is not installed. Launch AppStore to install Waze app
                [[UIApplication sharedApplication] openURL:[NSURL
                                                            URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
            }
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Geolocation information not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)showMap {
    double decLat = [[self.nearbyDict objectForKey:@"floLatitude"] doubleValue];
    double decLon = [[self.nearbyDict objectForKey:@"floLongitude"] doubleValue];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        // Open google Maps application
        NSString *place = [[self.nearbyDict objectForKey:@"strTitle"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        place = [place stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *stringURL = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%g,%g", place, decLat, decLon];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        // Google Maps is not installed. Launch AppStore to install Google Maps app
        [[UIApplication sharedApplication] openURL:[NSURL
                                                    URLWithString:@"http://itunes.apple.com/us/app/id585027354"]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([menuArray count]%4 == 0) {
        return [menuArray count]/4;
    }else {
        return [menuArray count]/4+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    int buttonSize = 36;
    int buttonSpace = 35;
    int paddingLeft = 30;
    int paddingTop = 15;
    int fontSize = 12;
    int labelHeight = 25;
    if (IS_IPAD) {
        buttonSize = 72;
        buttonSpace = 70;
        paddingLeft = 20;
        fontSize = 24;
        paddingTop = 30;
        labelHeight = 50;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int count =  [menuArray count]-indexPath.row*4>4?4:[menuArray count]-indexPath.row*4;
    //  NSLog(@"=====%d",count);
    for (int i = 0; i <count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(paddingLeft+(i%4)*(buttonSize+buttonSpace), paddingTop, buttonSize, buttonSize);
        btn.tag = i+indexPath.row*4;
        // NSLog(@"i+indexPath.row*4 =====%d",i+indexPath.row*4);
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Nearby_%@.png",[[menuArray objectAtIndex:i+indexPath.row*4] objectForKey:@"name"]]];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft-buttonSpace/2.0+(i%4)*(buttonSize+buttonSpace), paddingTop+buttonSize, (buttonSize+buttonSpace), labelHeight)];
        label.text = [[menuArray objectAtIndex:i+indexPath.row*4] objectForKey:@"name"];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:fontSize];
        label.textColor = [UIColor whiteColor];
        // label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        return 160;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (IS_IPAD) {
        return 104;
    }
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    int headerHeight = 52;
    int paddingLeft = 10;
    int fontSize = 13;
    if (IS_IPAD) {
        headerHeight = 104;
        paddingLeft = 20;
        fontSize = 26;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, headerHeight)];
    view.backgroundColor = [UIColor colorWithRed:0.50 green:0.51 blue:0.52 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, tableView.frame.size.width-paddingLeft*2, headerHeight)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 2;
    label.text = [nearbyDict objectForKey:@"strAddress"];
    [view addSubview:label];
    
    return view;

}

#pragma mark - MFMessageComposeViewController
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - MFMailComposeViewController
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
