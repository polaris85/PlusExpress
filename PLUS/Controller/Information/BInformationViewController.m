
//
//  BInformationViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BInformationViewController.h"
#import "BGetDirectionViewController.h"
#import "AppDelegate.h"
#import "TblFacilitiesEntry.h"
#import "TblFacilityTypeEntry.h"
#import "TblBrandEntry.h"
#import "TblHighwayEntry.h"
#import "TblCSC.h"
#import "TblRSA.h"
#import "TblTollPlazaEntry.h"
#import "TblPetrolStation.h"
#import "TblBrandEntry.h"
#import "TblConfig.h"
#import "BInformationPhotoDetailViewController.h"
#import "ImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "Constants.h"
@interface BInformationViewController (){
    BOOL isMapShow;
    UILabel *distanceLabel;
    NSMutableArray *cctvResults;
}

@end

@implementation BInformationViewController
@synthesize infoDic;
@synthesize infoPictureArr;
@synthesize infoPicture;

@synthesize serVicesArray;

@synthesize strName,decLocation,strDirection,strSignatureName,strOperationHour;
@synthesize intParentType;
@synthesize isFromFacility;
@synthesize currentLocation;
@synthesize locManager;

@synthesize idParent;
@synthesize intStrType;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Information";
    //[self creatAnnouncements];
    // NSLog(@"%@",self.serVicesArray);
    isMapShow = NO;
    
    currentViewOption = 0;
    
    [self CreatLocationManager];
    [self creatData];
    [self creatUI];
    [self loadContentView:nil];
    
    //[self retrieveCCTV];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.infoDic = nil;
    self.infoPicture = nil;
    self.infoPictureArr = nil;
    self.serVicesArray = nil;
    self.idParent = nil;
    self.locManager = nil;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    
    [locManager stopUpdatingLocation];
    [locManager setDelegate:nil];
}

#pragma mark -  Data

- (void)creatData{
    if (isFromFacility) {
        
        self.infoDic = [NSDictionary dictionaryWithDictionary:[TblFacilitiesEntry searchFacilityDicByStrName:strName intParentType:intParentType decLocation:decLocation strDirection:strDirection]];
    }else {
        
        if (intParentType == 0) {
            //RSA
            self.infoDic = [NSDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:self.idParent]];
            self.intStrType = [[self.infoDic objectForKey:@"strType"] integerValue];
            self.strSignatureName = [self.infoDic objectForKey:@"strSignatureName"];
            
            @try {
                NSString *newIdParent = [self.idParent substringFromIndex:10];
                self.infoPictureArr = [NSMutableArray arrayWithArray:[TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]]];
                pictureLoadCount = [self.infoPictureArr count];
                for (NSDictionary *dict in self.infoPictureArr) {
                    [self loadImageWithUrl:[dict objectForKey:@"strURL"] withType:@"2"];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }else if (intParentType == 1) {
            //Petrol Station
            self.infoDic = [NSDictionary dictionaryWithDictionary:[TblPetrolStation searchPetrolStation:self.idParent]];
        }else if (intParentType == 2) {
            //CSC
            self.infoDic = [NSDictionary dictionaryWithDictionary:[TblCSC searchCSC:strName decLocation:decLocation strDirection:strDirection]];
            strOperationHour = [self.infoDic objectForKey:@"strOperationHour"];
        }else if (intParentType == 3) {
            //Toll Plaza
            self.infoDic = [NSDictionary dictionaryWithDictionary:[TblTollPlazaEntry searchTollPlaza:strName decLocation:decLocation strDirection:strDirection]];
        }
        
        
        if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
            self.infoPicture = [NSMutableDictionary dictionaryWithObject:[self.infoDic objectForKey:@"strPicture"]
                                                                  forKey:@"strPicture"];
            
            [self loadImageWithUrl:[self.infoPicture objectForKey:@"strPicture"] withType:@"1"];
        } else if ([self.infoPictureArr count] > 0) {
            
            [self loadImageWithUrl:[[self.infoPictureArr objectAtIndex:0] objectForKey:@"strURL"] withType:@"1"];
        }
        
                NSLog(@"%@", self.infoDic);
    }
    
    if (intParentType == 1) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[TblFacilitiesEntry searchPetrolFacilityByIdParent:idParent intParentType:intParentType]];
        
        NSLog(@"arr=======%@",arr);
        [arr addObject:self.infoDic];
        
        self.serVicesArray = [NSMutableArray arrayWithArray:arr];
        
    }else {
        self.serVicesArray = [NSMutableArray arrayWithArray:[TblFacilitiesEntry searchFacilityByIdParent:idParent intParentType:intParentType]];
    }
     NSLog(@"%@",self.serVicesArray);
}

#pragma mark -  UI

- (void)creatUI{
    
    int paddingLeft = 10;
    int paddingBottom = 10;
    int fontSize1 = 17;
    int addressLabelHeight = 20;
    int subLabelHeight = 15;
    int rsaSignatureImageSize = 60;
    int fontSize2 = 14;
    int scrollHeight = 35;
    int locationLabelSize = 75;
    
    int buttonSize = 20;
    if (IS_IPAD) {
        paddingLeft = 20;
        paddingBottom = 20;
        fontSize1 = 30;
        fontSize2 = 25;
        addressLabelHeight = 40;
        subLabelHeight = 30;
        rsaSignatureImageSize = 152;
        scrollHeight = 60;
        locationLabelSize = 150;
        buttonSize = 40;
    }
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    UILabel *addressName = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom, self.view.frame.size.width-paddingLeft*2, addressLabelHeight)];
    addressName.text = strName;
    addressName.textColor = [UIColor whiteColor];
    addressName.font = [UIFont systemFontOfSize:fontSize1];
    addressName.backgroundColor = [UIColor clearColor];
    [self.view addSubview:addressName];
    
    int count;
    if (strSignatureName.length > 0) {
        count =2;
    }else {
        count = 2;
    }
    
    for (int i = 0; i<count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft*2,  TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*i, self.view.frame.size.width-paddingLeft*4, subLabelHeight)];
        label.textColor = [UIColor colorWithRed:229/255.0 green:109/255.0 blue:30/255.0 alpha:1];
        
        if (i == 0) {
            if ([[[TblHighwayEntry searchHighwayByIdHighway:[infoDic objectForKey:@"idHighway"]] objectForKey:@"strName"] length] > 0) {
                
                label.text = [[TblHighwayEntry searchHighwayByIdHighway:[infoDic objectForKey:@"idHighway"]] objectForKey:@"strName"];
            }else {
                label.text = @"Not Available";
                label.textColor = [UIColor redColor];
            }
        }else if(i == 1){
            
            if (isFromFacility) {
                
                if (intParentType == 0){
                    label.text = @"RSA";
                }else if (intParentType == 1){
                    label.text = @"Petrol Station";
                }else if (intParentType == 2){
                    label.text = @"CSC";
                }else if (intParentType == 3){
                    label.text = @"Toll Plaza";
                }else if (intParentType == 4){
                    label.text = @"OBR";
                }else if (intParentType == 5){
                    label.text = @"Lay-by";
                }else if (intParentType == 6){
                    label.text = @"Interchange";
                }else if (intParentType == 7){
                    label.text = @"Tunnel";
                }else if (intParentType == 8){
                    label.text = @"Vista Point";
                }
            }else {
                if (intParentType == 0) {
                    /*
                     0- Lay-By
                     1- Layby Signature
                     2-RSA
                     3- RSA Signature
                     4- Interchange
                     5- Tunnel
                     6-Vista
                     7-OBR
                     */
                    if (intStrType == 0){
                        label.text = @"Lay-By";
                    }else if (intStrType == 1){
                        label.text = @"LayBy Signature";
                    }else if (intStrType == 2){
                        label.text = @"RSA";
                    }else if (intStrType == 3){
                        label.text = @"RSA Signature";
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:((IS_IPAD) ? @"rsa_signature_logo.png":@"rsa_signature_logo.png")]];
                        imageView.frame = CGRectMake(self.view.frame.size.width - rsaSignatureImageSize - paddingLeft*2, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom, rsaSignatureImageSize, rsaSignatureImageSize);
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        [self.view addSubview:imageView];
                        
                    }else if (intStrType == 4){
                        label.text = @"Interchange";
                    }else if (intStrType == 5){
                        label.text = @"Tunnel";
                    }else if (intStrType == 6){
                        label.text = @"Vista Point";
                    }else if (intStrType == 7){
                        label.text = @"OBR";
                    }
                    
                }else if (intParentType == 1) {
                    label.text = @"Petrol Station";
                }else if (intParentType == 2){
                    label.text = @"CSC";
                }else if (intParentType == 3){
                    label.text = @"Toll Plaza";
                }
                
            }
            
            if (strSignatureName.length>0) {
                label.text = [NSString stringWithFormat:@"%@ - %@",label.text,strSignatureName];
            }
        }else if (i == 2) {
            label.text = strSignatureName;
        }
        label.font = [UIFont systemFontOfSize:fontSize2];
        
        [label setAdjustsFontSizeToFitWidth:YES];
        if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
            [label setFont:[UIFont systemFontOfSize:fontSize2]];
            [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, self.view.frame.size.width, label.bounds.size.height)];
        } else if ([self.infoPictureArr count] > 0) {
            [label setFont:[UIFont systemFontOfSize:fontSize2]];
            [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y,
                                       self.view.frame.size.width, label.bounds.size.height)];
        }
        
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    float operationHourHeight;
    if (strOperationHour.length > 0) {
        operationHourHeight = 15;
    }else {
        operationHourHeight = 0;
    }
    
    UILabel *operationHourLabel = [[UILabel alloc] init];
    if (strSignatureName.length > 0) {
        operationHourLabel.frame = CGRectMake(paddingLeft*2, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2, self.view.frame.size.width-paddingLeft*4, operationHourHeight);
    }else {
        operationHourLabel.frame = CGRectMake(paddingLeft*2, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2, self.view.frame.size.width-paddingLeft*4, operationHourHeight);
    }
    operationHourLabel.text = [NSString stringWithFormat:@"Operating Hours: %@",strOperationHour];
    operationHourLabel.textColor = [UIColor whiteColor];
    operationHourLabel.font = [UIFont systemFontOfSize:fontSize2];
    operationHourLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:operationHourLabel];
    
    UILabel *locationTitle = [[UILabel alloc] init];
    if (strSignatureName.length > 0) {
        locationTitle.frame = CGRectMake(paddingLeft*2, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2+operationHourHeight, locationLabelSize, subLabelHeight);
    }else {
        locationTitle.frame = CGRectMake(paddingLeft*2, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2+operationHourHeight, locationLabelSize, subLabelHeight);
    }
    locationTitle.text = @"Location:";
    locationTitle.textColor = [UIColor whiteColor];
    locationTitle.font = [UIFont systemFontOfSize:fontSize2];
    locationTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:locationTitle];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    if (strSignatureName.length > 0) {
        locationLabel.frame = CGRectMake(locationTitle.frame.origin.x + locationTitle.frame.size.width, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2+operationHourHeight, 230, subLabelHeight);
    }else {
        locationLabel.frame = CGRectMake(locationTitle.frame.origin.x + locationTitle.frame.size.width, TOP_HEADER_HEIGHT + statusBarHeight+paddingBottom+addressLabelHeight+subLabelHeight*2+operationHourHeight, 230, subLabelHeight);
    }
    locationLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.font = [UIFont systemFontOfSize:fontSize2];
    locationLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:locationLabel];
    
    UILabel *distanceTitle = [[UILabel alloc] init];
    if (strSignatureName.length > 0) {
        distanceTitle.frame = CGRectMake(paddingLeft*2, locationTitle.frame.origin.y + locationTitle.frame.size.height+10, locationLabelSize, subLabelHeight);
    }else {
        distanceTitle.frame = CGRectMake(paddingLeft*2, locationTitle.frame.origin.y + locationTitle.frame.size.height+10, locationLabelSize, subLabelHeight);
    }
    distanceTitle.text = @"Distance:";
    distanceTitle.textColor = [UIColor whiteColor];
    distanceTitle.font = [UIFont systemFontOfSize:fontSize2];
    distanceTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:distanceTitle];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[self.infoDic objectForKey:@"decLat"] doubleValue] longitude:[[self.infoDic objectForKey:@"decLong"] doubleValue]];
    
    distanceLabel = [[UILabel alloc] init];
    
    if (strSignatureName.length > 0) {
        distanceLabel.frame = CGRectMake(distanceTitle.frame.origin.x + distanceTitle.frame.size.width, locationLabel.frame.origin.y + locationLabel.frame.size.height+10, 230, subLabelHeight);
    }else {
        distanceLabel.frame = CGRectMake(distanceTitle.frame.origin.x + distanceTitle.frame.size.width, locationLabel.frame.origin.y + locationLabel.frame.size.height+10, 230, subLabelHeight);
    }
    
    // NSString *distanceStr = [self calculateRoutesFrom:self.currentLocation.coordinate to:location.coordinate];
    NSString *distanceStr = [NSString stringWithFormat:@"%f",[self.currentLocation distanceFromLocation:location]];
    
    if (distanceStr.length > 0) {
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.text = [NSString stringWithFormat:@"%.02fKM",[distanceStr floatValue]/1000];
    }else {
        distanceLabel.text = @"Not Available";
        distanceLabel.textColor = [UIColor redColor];
    }
    
    distanceLabel.font = [UIFont systemFontOfSize:fontSize2];
    distanceLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:distanceLabel];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    
    scroll.frame = CGRectMake(0,distanceLabel.frame.origin.y + distanceLabel.frame.size.height+paddingBottom,self.view.frame.size.width,scrollHeight);
    scroll.contentSize = CGSizeMake(paddingLeft*2+scrollHeight * self.serVicesArray.count, scrollHeight);
    scroll.scrollEnabled = YES;
    scroll.alpha = 0.8;
    scroll.bounces = NO;
    
    int i=0;
    for (NSDictionary *service in self.serVicesArray) {
        
        NSLog(@"Service=%@", service);
        if([[service objectForKey:@"intFacilityType"] intValue] == 11)
            continue;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.frame = CGRectMake(paddingLeft*2+((scrollHeight+5)*i), 0, scrollHeight, scrollHeight);
        
        if ([[service objectForKey:@"idBrand"] length] > 5) {
            
            //brand logo
            NSString *brandPicUrl = @"http://plus.aviven.net/push/public/upload/ad/";
            NSString *strPicture = [[TblBrandEntry searchBrandByIdBrand:[service objectForKey:@"idBrand"]] objectForKey:@"strPicture"];
            NSString *brandImageUrlStr = [NSString stringWithFormat:@"%@%@",brandPicUrl,strPicture];
            NSURL *brandImageUrl = [NSURL URLWithString:brandImageUrlStr];
            // NSLog(@"%@",brandImageUrl);
            [btn setImageWithURL:brandImageUrl placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[service objectForKey:@"idBrand"]]]];
            
        }else {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:((IS_IPAD)?@"intFacilityType%d_ipad.png":@"intFacilityType%d.png"),[[service objectForKey:@"intFacilityType"] intValue]]] forState:UIControlStateNormal];
        }
        //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
        [scroll addSubview:btn];
        i++;
    }
    
    [self.view addSubview:scroll];
    
    i=0;
    //    if (intParentType == 0) {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y + scroll.frame.size.height+paddingBottom, self.view.frame.size.width, scrollHeight)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_bar.png"]];
    imageView.frame = CGRectMake(paddingLeft, 0, self.view.frame.size.width-paddingLeft*2, scrollHeight);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    btn.frame = CGRectMake(paddingLeft*2+(scrollHeight*i), 8, buttonSize, buttonSize);
    [btn setBackgroundImage:[UIImage imageNamed:@"map_icon.png"] forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    i++;
    
    if (intParentType == 0){
        NSString *newIdParent = [idParent substringFromIndex:10];
        NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
        if ([cctvRSA count] > 0) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = YES;
            btn.frame = CGRectMake(paddingLeft*2+(scrollHeight*i), 8, buttonSize, buttonSize);
            [btn setBackgroundImage:[UIImage imageNamed:@"cctv_icon.png"] forState:UIControlStateNormal];
            //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
            btn.tag = 2;
            [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            i++;
        }
    }else{
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = YES;
        btn.frame = CGRectMake(paddingLeft*2+(scrollHeight*i), 8, buttonSize, buttonSize);
        [btn setBackgroundImage:[UIImage imageNamed:@"cctv_icon.png"] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
        btn.tag = 2;
        [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        i++;
    }
    //}
    if ([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11) {
        
        NSDictionary *facility;
        int count = 0;
        for(facility in self.serVicesArray){
            if ([[facility objectForKey:@"intFacilityType"] intValue] == 11) {
                NSMutableArray *facilityImageArr = [TblFacilitiesEntry searchFacilityImagesByIdFacilities:[[facility objectForKey:@"idFacilities"] intValue]];
                count = [facilityImageArr count];
                if(count > 0)
                    break;
            }
        }
        
        if(count > 0){
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = YES;
            btn.frame = CGRectMake(paddingLeft*2+(scrollHeight*i), 8, buttonSize, buttonSize);
            [btn setBackgroundImage:[UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png":@"intFacilityType11.png")] forState:UIControlStateNormal];
            btn.tag = 1;
            [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            i++;
        }
    }
    
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = YES;
        btn.frame = CGRectMake(paddingLeft*2+(scrollHeight*i), 8, buttonSize, buttonSize);
        [btn setBackgroundImage:[UIImage imageNamed:@"direction_icon.png"] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
        btn.tag = 3;
        [btn addTarget:self action:@selector(getDirection) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        i++;
        
        [self.view addSubview:view];
/*
    }else if(intParentType == 3){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = YES;
        btn.frame = CGRectMake(10, TOP_HEADER_HEIGHT + statusBarHeight+180+operationHourHeight, 300, 25);
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setTitle:@"Get Direction" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(getDirection) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
*/    
    
    /*
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight+40, self.view.frame.size.width, 140) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
     */
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + view.frame.size.height+ paddingBottom, self.view.frame.size.width, self.view.frame.size.height-view.frame.origin.y - view.frame.size.height - paddingBottom)];
    
    [self.view addSubview:contentView];
}


#pragma mark - UIButton

- (void)getDirection{
    
    // NSLog(@"===========getDirection");
    // AppDelegate *dele = [UIApplication sharedApplication].delegate;
    if (![CheckNetwork connectedToNetwork]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet connection is not detected. Route information will not be available" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([[infoDic objectForKey:@"decLat"] length] >0 && [[infoDic objectForKey:@"decLong"] length] > 0) {
        double decLat = [[infoDic objectForKey:@"decLat"] doubleValue];
        double decLon = [[infoDic objectForKey:@"decLong"] doubleValue];
        
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
        /*
        
         BGetDirectionViewController *getDirection = [[BGetDirectionViewController alloc] init];
         getDirection.decLat = [[infoDic objectForKey:@"decLat"] doubleValue];
         getDirection.decLon = [[infoDic objectForKey:@"decLong"] doubleValue];
         getDirection.endLocationName = [infoDic objectForKey:@"strName"];
         getDirection.intParentType = intParentType;
         [self.navigationController pushViewController:getDirection animated:YES];
         
         */
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Geolocation information not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (void)pictureViewClicked:(id)sender {
    [self showPictureViewer];
}

#pragma mark - Picture Viewer
- (void)CreatPictureViewer {
    pictureViewer = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [pictureViewer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pictureViewer];
    
    UIView *backgroundColor = [[UIView alloc] initWithFrame:pictureViewer.bounds];
    [backgroundColor setBackgroundColor:[UIColor blackColor]];
    [backgroundColor setAlpha:0.8];
    [pictureViewer addSubview:backgroundColor];
    
    pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 60.0f, self.view.frame.size.width, 300.0f)];
	pictureScrollView.contentSize = CGSizeMake(1 * 320.0f, pictureScrollView.frame.size.height);
	pictureScrollView.pagingEnabled = YES;
	pictureScrollView.delegate = self;
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    [pictureScrollView setBackgroundColor:[UIColor clearColor]];
    [pictureScrollView setTag:111];
    [pictureViewer addSubview:pictureScrollView];
    
    picturePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10.0f, 320.0f, self.view.frame.size.width, 20.0f)];
    picturePageControl.numberOfPages = 0;
	picturePageControl.currentPage = 0;
	[picturePageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [pictureViewer addSubview:picturePageControl];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setFrame:CGRectMake(240, 16, 60, 30)];
    [close addTarget:self action:@selector(hidePictureViewer) forControlEvents:UIControlEventTouchUpInside];
    [pictureViewer addSubview:close];
    
    [pictureViewer setHidden:YES];
}

- (void)reloadPictureViewer {
    
    if (currentViewOption == 0) {
        int count = [infoPictureArr count];
        if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
            count += 1;
        }
        
        pictureScrollView.contentSize = CGSizeMake(count * pictureScrollView.frame.size.width,
                                                   pictureScrollView.frame.size.height);
        [pictureScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        picturePageControl.numberOfPages = count;
        
        for (int i = 0; i < count; i++) {
            // set up box frame
            //UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(i * 320+20, 0, 280, pictureScrollView.frame.size.height)];
            UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(i * contentView.frame.size.width, 0, contentView.frame.size.width, contentView.frame.size.height-35)];
            [boxView setBackgroundColor:[UIColor clearColor]];
            
            UIImage *picture = nil;
            if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
                if (i==0) {
                    picture = (UIImage *)[infoPicture objectForKey:@"image_data"];
                } else {
                    NSDictionary *dict = [infoPictureArr objectAtIndex:i-1];
                    picture = (UIImage *)[dict objectForKey:@"image_data"];
                }
            } else {
                NSDictionary *dict = [infoPictureArr objectAtIndex:i];
                picture = (UIImage *)[dict objectForKey:@"image_data"];
            }
            
            if (!picture || picture == nil) {
                //CGSize pictureViewSize = CGSizeMake(280, pictureScrollView.frame.size.height);
                //CGSize pictureViewSize = CGSizeMake(320, 240);
                CGSize pictureViewSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height-35);
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0f,
                                                                                       pictureViewSize.width,
                                                                                       pictureViewSize.height)];
                [imageView setImage:[UIImage imageNamed:@"no_image.png"]];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [boxView addSubview:imageView];
                
                [pictureScrollView addSubview:boxView];
            } else {
                //CGSize pictureViewSize = CGSizeMake(280, pictureScrollView.frame.size.height);
                CGSize pictureViewSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height-35);
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0f,
                                                                                       pictureViewSize.width,
                                                                                       pictureViewSize.height)];
                [imageView setImage:picture];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.clipsToBounds = YES;
                [boxView addSubview:imageView];
                
                [pictureScrollView addSubview:boxView];
            }
        }
    }else if(currentViewOption == 1){
        
        if([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11){
            
            NSDictionary *facility;
            int count = 0;
            NSMutableArray *facilityImageArr = [[NSMutableArray alloc] initWithCapacity:0];
            for(facility in self.serVicesArray){
                if ([[facility objectForKey:@"intFacilityType"] intValue] == 11) {
                    facilityImageArr = [TblFacilitiesEntry searchFacilityImagesByIdFacilities:[[facility objectForKey:@"idFacilities"] intValue]];
                    count = [facilityImageArr count];
                    if(count > 0)
                        break;
                }
            }
            
            pictureScrollView.contentSize = CGSizeMake(count * pictureScrollView.frame.size.width,
                                                       pictureScrollView.frame.size.height);
            [pictureScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            picturePageControl.numberOfPages = count;
            
            for (int i = 0; i < count; i++) {
                // set up box frame
                UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(i * contentView.frame.size.width, 0, contentView.frame.size.width, contentView.frame.size.height-35)];
                [boxView setBackgroundColor:[UIColor clearColor]];
                
                
                NSDictionary *dict = [facilityImageArr objectAtIndex:i];
                NSString *pictureURL = (NSString *)[dict objectForKey:@"strPicture"];
                NSLog(@"PictureURL=%@", pictureURL);
                
                UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:pictureURL]]; //Img_URL is NSString of your image URL
                
                //CGSize pictureViewSize = CGSizeMake(320, 240);
                CGSize pictureViewSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height-35);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0f,
                                                                                       pictureViewSize.width,
                                                                                       pictureViewSize.height)];
                if (img) {       //If image is previously downloaded set it and we're done.
                    [imageView setImage:img];
                    [[SDImageCache sharedImageCache] removeImageForKey:pictureURL fromDisk:YES];
                }else{
                    [imageView setImageWithURL:[NSURL URLWithString:pictureURL] placeholderImage:[UIImage imageNamed:@"no_image.png"] success:^(UIImage *image, BOOL cached) {
                    } failure:^(NSError *error) {
                        
                    }];
                }
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [boxView addSubview:imageView];
                
                [pictureScrollView addSubview:boxView];
            }
        }
        
    }else if (currentViewOption == 2) {
        int count = [cctvResults count];
        
        pictureScrollView.contentSize = CGSizeMake(count * pictureScrollView.frame.size.width,
                                                   pictureScrollView.frame.size.height);
        [pictureScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        picturePageControl.numberOfPages = count;
        
        for (int i = 0; i < count; i++) {
            // set up box frame
            UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(i * contentView.frame.size.width, 0, contentView.frame.size.width, contentView.frame.size.height-35)];
            [boxView setBackgroundColor:[UIColor clearColor]];
            
            NSDictionary *cctvData = [cctvResults objectAtIndex:i] ;
            NSString *pictureUrl = [cctvData objectForKey:@"strURL"];
            
            //CGSize pictureViewSize = CGSizeMake(280, pictureScrollView.frame.size.height);
            //CGSize pictureViewSize = CGSizeMake(320, 240);
            CGSize pictureViewSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height-35);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0f,
                                                                                   pictureViewSize.width,
                                                                                   pictureViewSize.height)];
            
            UIImage *picture = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:pictureUrl]]; //Img_URL is NSString of your image URL
            if (picture) {       //If image is previously downloaded set it and we're done.
                [imageView setImage:picture];
                [[SDImageCache sharedImageCache] removeImageForKey:pictureUrl fromDisk:YES];
            }else{
                [imageView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:[UIImage imageNamed:@"no_image.png"] success:^(UIImage *image, BOOL cached) {
                } failure:^(NSError *error) {
                    
                }];
            }
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.clipsToBounds = YES;
            [boxView addSubview:imageView];
            [pictureScrollView addSubview:boxView];
        }
    }
}

- (void)showPictureViewer {
    [self reloadPictureViewer];
    
    [pictureScrollView setContentOffset:CGPointMake(0, 0)];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[pictureViewer setHidden:NO];
	[UIView commitAnimations];
}

- (void)hidePictureViewer {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[pictureViewer setHidden:YES];
	[UIView commitAnimations];
}
- (void) pageTurn: (UIPageControl *) aPageControl
{
    int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	pictureScrollView.contentOffset = CGPointMake(pictureScrollView.bounds.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
    if ([aScrollView tag] == 111) {
        CGPoint offset = aScrollView.contentOffset;
        picturePageControl.currentPage = offset.x / pictureScrollView.bounds.size.width;
    }
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (!isGetLoc) {
        
        isGetLoc = YES;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        //CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
        
        self.currentLocation = location;
        
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[self.infoDic objectForKey:@"decLat"] doubleValue] longitude:[[self.infoDic objectForKey:@"decLong"] doubleValue]];
        NSString *distanceStr = [NSString stringWithFormat:@"%f",[self.currentLocation distanceFromLocation:location1]];
        
        if (distanceStr.length > 0) {
            distanceLabel.text = [NSString stringWithFormat:@"%.02fKM",[distanceStr floatValue]/1000];
        }else {
            distanceLabel.textColor = [UIColor redColor];
        }
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    // NSLog(@"Location manager error: %@", [error description]);
    isGetLoc = NO;
    [manager stopUpdatingLocation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
    self.currentLocation = location;
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[self.infoDic objectForKey:@"decLat"] doubleValue] longitude:[[self.infoDic objectForKey:@"decLong"] doubleValue]];
    NSString *distanceStr = [NSString stringWithFormat:@"%f",[self.currentLocation distanceFromLocation:location1]];
    
    if (distanceStr.length > 0) {
        distanceLabel.text = [NSString stringWithFormat:@"%.02fKM",[distanceStr floatValue]/1000];
    }else {
        distanceLabel.textColor = [UIColor redColor];
    }

    //[table reloadData];
}

#pragma mark - Distance

-(NSString *) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false", saddr, daddr];
    //NSString* apiUrlStr = @"http://maps.google.com/maps/api/directions/json?origin=3.077834,101.672236&destination=6.512241,100.419978&sensor=true";
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	//NSLog(@"api url: %@", apiUrl);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:apiUrl];
    [request startSynchronous];
    NSString *apiResponse = [request responseString];
    // NSLog(@"%@",[apiResponse JSONValue]);
    NSDictionary *dic_data=[apiResponse JSONValue];
    
    NSArray *dic_routes =[dic_data objectForKey:@"routes"];
    if (dic_routes.count == 0) {
        return nil;
    }
    NSArray *legs=[[dic_routes objectAtIndex:0] objectForKey:@"legs"];
    // NSLog(@"legs=%@",legs);
    NSDictionary *distance1 = [[legs objectAtIndex:0] objectForKey:@"distance"];
    //NSLog(@"distance===%@",distance);
    NSString *value = [NSString stringWithFormat:@"%@",[distance1 objectForKey:@"value"]];
	return value;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.serVicesArray.count;
    }else {
        return 0;
    }
     */
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    /*
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
     */
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    switch (indexPath.section) {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
            break;
        case 1:{
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            int i=0;
            //if (intParentType == 0) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = YES;
                btn.frame = CGRectMake(10+((32+5)*i), 2.5, 32, 32);
                [btn setImage:[UIImage imageNamed:@"map_icon.png"] forState:UIControlStateNormal];
                //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
                btn.tag = 0;
                [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                i++;
                if ([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11) {
                    
                    btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.userInteractionEnabled = YES;
                    btn.frame = CGRectMake(10+((32+5)*i), 2.5, 32, 32);
                    [btn setImage:[UIImage imageNamed:@"intFacilityType11.png"] forState:UIControlStateNormal];
                    //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
                    btn.tag = 1;
                    [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                    i++;
                }
                
                NSString *newIdParent = [idParent substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.userInteractionEnabled = YES;
                    btn.frame = CGRectMake(10+((32+5)*i), 2.5, 32, 32);
                    [btn setImage:[UIImage imageNamed:@"cctv.png"] forState:UIControlStateNormal];
                    //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
                    btn.tag = 2;
                    [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                    i++;
                }
                
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = YES;
                btn.frame = CGRectMake(10+((32+5)*i), 2.5, 32, 32);
                [btn setImage:[UIImage imageNamed:@"direction.png"] forState:UIControlStateNormal];
                //[btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
                btn.tag = 3;
                [btn addTarget:self action:@selector(loadContentView:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                i++;
                
                /*

                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = NO;
                btn.frame = CGRectMake(10+((40+5)*0), 2.5, 40, 40);
                [btn setImage:[UIImage imageNamed:@"map_icon.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn];
                
                int i=1;
                for (NSDictionary *service in self.serVicesArray) {
                    
                    NSLog(@"Service=%@", service);
                    if([[service objectForKey:@"intFacilityType"] intValue] != 11)
                        continue;
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.userInteractionEnabled = NO;
                    btn.frame = CGRectMake(10+((40+5)*i), 2.5, 40, 40);
                    
                    if ([[service objectForKey:@"idBrand"] length] > 5) {
                        
                        //brand logo
                        NSString *brandPicUrl = @"http://plus.aviven.net/push/public/upload/ad/";
                        NSString *strPicture = [[TblBrandEntry searchBrandByIdBrand:[service objectForKey:@"idBrand"]] objectForKey:@"strPicture"];
                        NSString *brandImageUrlStr = [NSString stringWithFormat:@"%@%@",brandPicUrl,strPicture];
                        NSURL *brandImageUrl = [NSURL URLWithString:brandImageUrlStr];
                        // NSLog(@"%@",brandImageUrl);
                        [btn setImageWithURL:brandImageUrl placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[service objectForKey:@"idBrand"]]]];
                        
                    }else {
                        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"intFacilityType%d.png",[[service objectForKey:@"intFacilityType"] intValue]]] forState:UIControlStateNormal];
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"facilityBtnBG.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:btn];
                    i++;
                }
                 */
            /*
            }else if(intParentType == 3){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = YES;
                btn.frame = CGRectMake(10, 2.5, 300, 25);
                [btn setBackgroundColor:[UIColor lightGrayColor]];
                [btn setTitle:@"Get Direction" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn addTarget:self action:@selector(getDirection) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
            */
        }
            break;
        default:
            break;
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.section == 1) {
        if ([[[self.serVicesArray objectAtIndex:indexPath.row] objectForKey:@"intFacilityType"] intValue] == 11) {
            NSInteger idFacilities = [[[self.serVicesArray objectAtIndex:indexPath.row] objectForKey:@"idFacilities"] intValue];
            NSMutableArray *result = [NSMutableArray arrayWithArray:[TblFacilitiesEntry searchFacilityImagesByIdFacilities:idFacilities]];
            
            if (result && [result count] > 0) {
                BInformationPhotoDetailViewController *vc = [[BInformationPhotoDetailViewController alloc] init];
                vc.infoPictureArr = result;
                [[self navigationController] pushViewController:vc animated:YES];
            }
        }
    }
     */
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        float operationHourHeight;
        if (strOperationHour.length > 0) {
            operationHourHeight = 25;
        }else {
            operationHourHeight = 0;
        }
        
        if (strSignatureName.length > 0) {
            return 100+operationHourHeight;
        }else {
            return 100+operationHourHeight;
        }
    }else{
/*
        NSString *strDescription = [[self.serVicesArray objectAtIndex:indexPath.row] objectForKey:@"strDescription"];
        
        strDescription = [strDescription stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
        
        CGSize strDescriptionSize  = [strDescription sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        // NSLog(@"strDescriptionSize.height==%f",strDescriptionSize.height);
       
        if (strDescriptionSize.height == 0) {
            return 30;
        }else {
            return 30+strDescriptionSize.height-5;
        }
  */
        return 35;
    }
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==  0) {
        return 0;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.backgroundColor = [UIColor colorWithRed:0.50 green:0.51 blue:0.52 alpha:1];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:11];
        label.text = @"Services";
        [view addSubview:label];
        
        return view;
    }
}
*/
        
#pragma mark - ImageCache
- (void)loadImageWithUrl:(NSString *)url withType:(NSString *)type {
	
	if (url && [url length] > 0) {
		NSString *_cacheKey = [[NSString alloc] initWithFormat:@"icon_%@", url];
		if ( [[ImageCache sharedImageCache] hasImageWithKey:_cacheKey] ) {
			// if cache exist, load from cache
            
            if ([type isEqualToString:@"1"]){
                if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
                    [self.infoPicture setObject:[[ImageCache sharedImageCache] imageForKey:_cacheKey] forKey:@"image_data"];
                } else {
                    for (NSMutableDictionary *new in self.infoPictureArr) {
                        if ([url isEqualToString:[new objectForKey:@"strURL"]]) {
                            [new setObject:[[ImageCache sharedImageCache] imageForKey:_cacheKey] forKey:@"image_data"];
                        }
                    }
                }
                //[table reloadData];
                
            }
		} else {
			NSMutableDictionary *_imageDictionary = [NSMutableDictionary dictionary];
			[_imageDictionary setObject:url forKey:@"photoUrl"];
            [_imageDictionary setObject:type forKey:@"type"];
			[self performSelectorInBackground:@selector(loadImageInSubThread:) withObject:_imageDictionary];
		}
	}
}

- (void)loadImageInSubThread:(NSMutableDictionary *)imageDictionary {
	
	NSURL *_url = [NSURL URLWithString:[imageDictionary objectForKey:@"photoUrl"]];
	NSData *_imageData = [[NSData alloc] initWithContentsOfURL:_url];
	if (_imageData) {
		UIImage *_image = [[UIImage alloc] initWithData:_imageData];
		if (_image)
			[imageDictionary setObject:_image forKey:@"image"];
	}
    
	[self performSelectorOnMainThread:@selector(processShowImage:) withObject:imageDictionary waitUntilDone:YES];
}

- (void)processShowImage:(NSMutableDictionary *)imageDictionary {
    
    NSString *type = [imageDictionary objectForKey:@"type"];
	UIImage *image = [imageDictionary objectForKey:@"image"];
	if (image) {
		NSString *url = [imageDictionary objectForKey:@"photoUrl"];
        
        if ([type isEqualToString:@"1"]){
            NSString *_cacheKey = [[NSString alloc] initWithFormat:@"icon_%@", url];
            [[ImageCache sharedImageCache] storeImage:image withKey:_cacheKey];
            
            if (![[self.infoDic objectForKey:@"strPicture"] isEqualToString:@""] && [self.infoDic objectForKey:@"strPicture"] != nil) {
                [self.infoPicture setObject:[[ImageCache sharedImageCache] imageForKey:_cacheKey] forKey:@"image_data"];
            } else {
                for (NSMutableDictionary *new in self.infoPictureArr) {
                    if ([url isEqualToString:[new objectForKey:@"strURL"]]) {
                        [new setObject:[[ImageCache sharedImageCache] imageForKey:_cacheKey] forKey:@"image_data"];
                    }
                }
            }
            [table reloadData];
        } else if ([type isEqualToString:@"2"]){
            pictureLoadCount--;
            for (NSMutableDictionary *new in self.infoPictureArr) {
                if ([url isEqualToString:[new objectForKey:@"strURL"]]) {
                    [new setObject:image forKey:@"image_data"];
                }
            }
            
            [self performSelector:@selector(reloadPictureViewer)];
        }
	}
}

#pragma mark  - HttpData

- (void)retrieveCCTV {
    
    [self creatHUD];
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didRetrieveCCTVDataFinished:);
        httpData.didFailed = @selector(didRetrieveCCTVDataFinishedError);
        
        [self creatHUD];
        int facilityType = intParentType;
        if (intParentType == 0) {
            facilityType = 1;
        }else if(intParentType == 3)
            facilityType = 2;
        
        NSString *newIdParent = [idParent substringFromIndex:3];
        [httpData getFacilityCCTV:facilityType idFacility:newIdParent intDeviceType:deviceType strDeviceId:strUniqueId];
    }
}

- (void)didRetrieveCCTVDataFinished:(id)data {
    [self hideHud];
    NSLog(@"Data=%@", data);
    
    cctvResults = [[NSMutableArray alloc] initWithCapacity:0];
    int retrieveCount = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"intCount"] intValue];
    NSArray *dataArr = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"strResults"] JSONValue];
    for (NSDictionary *dic in dataArr) {
        if (([[dic objectForKey:@"intVisible"] integerValue] == 1) && ([[dic objectForKey:@"intStatus"] integerValue] == 1)) {
            [cctvResults addObject:dic];
        }
    }
    if(retrieveCount == 0)
        return;
    //[self pictureViewClicked:nil];
    [self createPictureView];
}

- (void)didRetrieveCCTVDataFinishedError {
    [self hideHud];
}

- (void) loadContentView:(UIButton *)sender
{
    //if (intParentType == 0) {
        if (sender) {
            if (currentViewOption == sender.tag) {
                if (sender.tag != 0)
                    return;
                else

                    isMapShow = !isMapShow;
            }
            currentViewOption = sender.tag;
        }
        /*
        [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        pictureViewer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
        [pictureViewer setBackgroundColor:[UIColor clearColor]];
        
        UIView *backgroundColor = [[UIView alloc] initWithFrame:pictureViewer.bounds];
        [backgroundColor setBackgroundColor:[UIColor clearColor]];
        [backgroundColor setAlpha:0.8];
        [pictureViewer addSubview:backgroundColor];
        
        pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pictureViewer.frame.size.width, pictureViewer.frame.size.height-35)];
        pictureScrollView.contentSize = CGSizeMake(1 * contentView.frame.size.width, pictureScrollView.frame.size.height);
        pictureScrollView.pagingEnabled = YES;
        pictureScrollView.delegate = self;
        pictureScrollView.showsHorizontalScrollIndicator = NO;
        [pictureScrollView setBackgroundColor:[UIColor clearColor]];
        [pictureScrollView setTag:111];
        [pictureViewer addSubview:pictureScrollView];
        
        picturePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, pictureViewer.frame.size.height-35, pictureViewer.frame.size.width, 20.0f)];
        picturePageControl.numberOfPages = 0;
        picturePageControl.currentPage = 0;
        picturePageControl.backgroundColor = [UIColor clearColor];
        [picturePageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [pictureViewer addSubview:picturePageControl];
        */
        if (currentViewOption == 0) {
            
            
            if (!isMapShow) {
                [self createPictureView];
               
            }else{
                CGRect rect= CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height-5);
                
                float lat = [[self.infoDic objectForKey:@"decLat"] floatValue];
                float lng = [[self.infoDic objectForKey:@"decLong"] floatValue];
                
                int type = [[self.infoDic objectForKey:@"strType"] intValue];
                
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                        longitude:lng
                                                                             zoom:6];
                _mapView = [GMSMapView mapWithFrame:rect camera:camera];
                _mapView.myLocationEnabled = YES;
                _mapView.trafficEnabled = YES;
                [_mapView setDelegate:self];
                [contentView addSubview:_mapView];
                
                CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
                GMSMarker *fmarker = [GMSMarker markerWithPosition:position];
                
                fmarker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"mapAnnotionType%d",type]];
                fmarker.userData = self.infoDic;
                fmarker.map = _mapView;
                fmarker.title = [self.infoDic objectForKey:@"strTitle"];
            }
        }else if(currentViewOption == 1){
            [self createPictureView];
        }else if(currentViewOption == 2){
            [self retrieveCCTV];
            //[contentView addSubview:pictureViewer];
            //[self pictureViewClicked:nil];
        }else{
            [self getDirection];
        }
    /*
    }else if(intParentType == 3){
        
        [contentView addSubview:pictureViewer];
        
        [self retrieveCCTV];
    }
    */
}

- (void) mapView:		(GMSMapView *) 	mapView
didTapInfoWindowOfMarker:		(GMSMarker *) 	marker
{
    NSLog(@"Marker Info Window Tapped");
}

-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    NSLog(@"try");
    [self getDirection];
    return YES;
}

-(void) createPictureView
{
    [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    pictureViewer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [pictureViewer setBackgroundColor:[UIColor clearColor]];
    
    UIView *backgroundColor = [[UIView alloc] initWithFrame:pictureViewer.bounds];
    [backgroundColor setBackgroundColor:[UIColor clearColor]];
    [backgroundColor setAlpha:0.8];
    [pictureViewer addSubview:backgroundColor];
    
    pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pictureViewer.frame.size.width, pictureViewer.frame.size.height-35)];
    pictureScrollView.contentSize = CGSizeMake(1 * contentView.frame.size.width, pictureScrollView.frame.size.height);
    pictureScrollView.pagingEnabled = YES;
    pictureScrollView.delegate = self;
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    [pictureScrollView setBackgroundColor:[UIColor clearColor]];
    [pictureScrollView setTag:111];
    [pictureViewer addSubview:pictureScrollView];
    
    picturePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, pictureViewer.frame.size.height-35, pictureViewer.frame.size.width, 20.0f)];
    picturePageControl.numberOfPages = 0;
    picturePageControl.currentPage = 0;
    picturePageControl.backgroundColor = [UIColor clearColor];
    [picturePageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [pictureViewer addSubview:picturePageControl];
    
    [contentView addSubview:pictureViewer];
    [self pictureViewClicked:nil];
}

-(IBAction)showDetail:(id)sender
{
    NSLog(@"Marker InfoWindow Clicked");
    
}

@end
