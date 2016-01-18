//
//  BFacilitiesViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BFacilitiesViewController.h"
#import "TblHighwayEntry.h"
#import "TblPetrolStation.h"
#import "TblFacilitiesEntry.h"
#import "TblFacilityTypeEntry.h"
#import "TblNearbyCatg.h"
#import "TblNearby.h"
#import "TblRSA.h"
#import "TblCSC.h"
#import "DropDownScroll.h"
#import "Constants.h"
#import "SEFilterControl.h"
#import "BInformationViewController.h"
#import "BPlaceDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface BFacilitiesViewController ()
{
    int intFacilityType;
}

@end

@implementation BFacilitiesViewController
@synthesize currentLocation;
@synthesize locManager;

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
    
    facilityArray = [[NSMutableArray alloc] init];
    highWayDetailArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    titleLabel.text = @"Facilities";
    //[self creatAnnouncements];
    
    segmentIndex = 0;
    facilityIndex = 0;
    btnArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *allFacilitiesArray = [[NSMutableArray alloc] initWithArray:[TblFacilityTypeEntry searchAllFacilityType]];
    facilityTypeArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:2]];    //  ATM
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:0]];    //  Petrol Station
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:3]];    //  Toilet
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:4]];    //  Food Restaurant
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:11]];   //  Food Signature
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:5]];    //  Surau
    [facilityTypeArray addObject: [allFacilitiesArray objectAtIndex:8]];    //  PLUS Miles Reload
    
    NSMutableArray *nearbyCatgArray = [TblNearbyCatg searchNearbyCategory];
    NSLog(@"NearbyCatgArray=%@", nearbyCatgArray);
    for (NSDictionary *nearbyCatgDict in nearbyCatgArray) {
        NSDictionary *addNearbyCatg = [NSDictionary dictionaryWithObjectsAndKeys:@"1000",@"intFacilityType",
                                       [nearbyCatgDict objectForKey:@"strNearbyCatgName"],@"description",
                                       [nearbyCatgDict objectForKey:@"strNearbyCatgImg"],@"picture",
                                       [nearbyCatgDict objectForKey:@"idNearbyCatg"],@"idNearby",nil];
        [facilityTypeArray addObject:addNearbyCatg];
    }
    
    NSDictionary *addRSACatg = [NSDictionary dictionaryWithObjectsAndKeys:@"1001",@"intFacilityType",
                                @"Interchange",@"description",
                                @"4",@"strType",nil];
    [facilityTypeArray addObject:addRSACatg];
    
    addRSACatg = [NSDictionary dictionaryWithObjectsAndKeys:@"1002",@"intFacilityType",
                  @"csc",@"description",
                  @"4",@"strType",nil];
    [facilityTypeArray addObject:addRSACatg];
    
    addRSACatg = [NSDictionary dictionaryWithObjectsAndKeys:@"1001",@"intFacilityType",
                  @"Tunnel",@"description",
                  @"5",@"strType",nil];
    [facilityTypeArray addObject:addRSACatg];
    
    addRSACatg = [NSDictionary dictionaryWithObjectsAndKeys:@"1001",@"intFacilityType",
                  @"Vista",@"description",
                  @"6",@"strType",nil];
    [facilityTypeArray addObject:addRSACatg];
    
    
    //highWayArray = [[NSMutableArray alloc] initWithArray:[TblPetrolStation searchIdHighwayFromPetrolStation]];
    //NSLog(@"HifhWayWaay=%@", highWayArray);
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblHighwayEntry searchHighway]];
    NSLog(@"HifhWayWaay=%@", highWayArray);
    
    currentDistance = 25.0f;
    tapCount = 0;
    intFacilityType = 2;
    
    [self creatFacilityArray:currentDistance location:self.currentLocation];
    [self creatUI];
    
    [self CreatLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Facilities Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
- (void)creatFacilityArray:(float)distance location:(CLLocation *)location
{
    [facilityArray removeAllObjects];
    //[highWayDetailArray removeAllObjects];
    
    //for (NSMutableDictionary *type in facilityTypeArray) {
    
    NSMutableDictionary *type = [facilityTypeArray objectAtIndex:facilityIndex];
    
        //NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if(intFacilityType == 1000){      //  NearBy
            
            NSString *idNearbyCatg = [type objectForKey:@"idNearby"];
            //[temp addObject:[TblNearby searchNearbyByIdNearbyCatg:idNearbyCatg distance:distance location:location]];
            [facilityArray addObjectsFromArray:[TblNearby searchNearbyByIdNearbyCatg:idNearbyCatg distance:distance location:location]];
            
        }else if(intFacilityType == 0){               //  Petrol Station
            
            for (int i = 0; i<highWayArray.count; i++) {
                
                NSString *highWayStr = [[highWayArray objectAtIndex:i] objectForKey:@"idHighway"];
                
                NSMutableSet *tempSet = [NSMutableSet set];
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                
                NSMutableArray *array = [TblPetrolStation searchPetrolStationByIdHighway:highWayStr distance:distance location:location];
                
                for (int i = 0; i<[array count]; i++) {
                    NSString *strName = [[array objectAtIndex:i] objectForKey:@"strName"];
                    
                    if (![tempSet containsObject:strName]) {
                        [temp addObject:[array objectAtIndex:i]];
                    }
                    
                    [tempSet addObject:strName];
                }
                
                if (temp.count > 0) {
                    [facilityArray addObject:temp];
                }
            }
            
            
            
        }else if(intFacilityType == 1001){      //  RSA
            //TblRSA sear
            
            for (int i = 0; i<highWayArray.count; i++) {
                
                NSString *highWayStr = [[highWayArray objectAtIndex:i] objectForKey:@"idHighway"];
                
                NSMutableSet *tempSet = [NSMutableSet set];
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                
                
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblRSA searchRSAByIdHighway:highWayStr strType:[type objectForKey:@"strType"]  distance:distance location:location]];
                
                for (int i = 0; i<[array count]; i++) {
                    NSString *strName = [[array objectAtIndex:i] objectForKey:@"strName"];
                    
                    if (![tempSet containsObject:strName]) {
                        [temp addObject:[array objectAtIndex:i]];
                    }
                    
                    [tempSet addObject:strName];
                }
                
                if (temp.count > 0) {
                    [facilityArray addObject:temp];
                }
            }
        }else if(intFacilityType == 1002){      //  CSC
            for (int i = 0; i<highWayArray.count; i++) {
                
                NSString *highWayStr = [[highWayArray objectAtIndex:i] objectForKey:@"idHighway"];
                
                NSMutableSet *tempSet = [NSMutableSet set];
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblCSC searchCSCByIdHighway:highWayStr distance:distance location:location]];
                
                for (int i = 0; i<[array count]; i++) {
                    NSString *strName = [[array objectAtIndex:i] objectForKey:@"strName"];
                    
                    if (![tempSet containsObject:strName]) {
                        [temp addObject:[array objectAtIndex:i]];
                    }
                    
                    [tempSet addObject:strName];
                }
                
                if (temp.count > 0) {
                    [facilityArray addObject:temp];
                }
            }
        }else{                                  //  Facility
            
            for (int i = 0; i<highWayArray.count; i++) {
                
                NSString *highWayStr = [[highWayArray objectAtIndex:i] objectForKey:@"idHighway"];
                
                NSMutableSet *tempSet = [NSMutableSet set];
                NSMutableArray *temp = [[NSMutableArray alloc] init];

                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblFacilitiesEntry searchFacilityByIntFacilityType: intFacilityType idHighWay:highWayStr distance:distance location:location]];
                
                for (int i = 0; i<[array count]; i++) {
                    NSString *strName = [[array objectAtIndex:i] objectForKey:@"strName"];
                    
                    if (![tempSet containsObject:strName]) {
                        [temp addObject:[array objectAtIndex:i]];
                    }
                    
                    [tempSet addObject:strName];
                }
                
                if (temp.count > 0) {
                    [facilityArray addObject:temp];
                }
            }
        }
        //NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:tempArray, @"facilities", type, @"facilityType", nil];
        //[facilityArray addObject:tempArray];
    //}
    
    NSLog(@"FacilityArray=%@", facilityArray);

}
- (void)creatRsaData{
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblPetrolStation searchIdHighwayFromPetrolStation]];
    highWayDetailArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    petrolArray = [[NSMutableArray alloc] init];
    atmArray = [[NSMutableArray alloc] init];
    
    NSMutableSet *atmSet = [NSMutableSet set];
    
    for (int i = 0; i<highWayArray.count; i++) {
        
        NSString *highWayStr = [highWayArray objectAtIndex:i];
        [highWayDetailArray addObject:[TblHighwayEntry searchHighwayByIdHighway:highWayStr]];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblFacilitiesEntry searchFacilityByIdHighway:highWayStr]];
        NSMutableArray *petrol = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *atm = [[NSMutableArray alloc] initWithCapacity:1];
        
        [petrol addObjectsFromArray:[TblPetrolStation searchPetrolStationByIdHighway:highWayStr]];
        
        for (int i = 0; i<[array count]; i++) {
            if ([[[array objectAtIndex:i] objectForKey:@"intFacilityType"] intValue] == 2) {
                NSString *strName = [[array objectAtIndex:i] objectForKey:@"strName"];
                
                if (![atmSet containsObject:strName]) {
                    [atm addObject:[array objectAtIndex:i]];
                }
                
                [atmSet addObject:strName];
            }
        }
        
        if (petrol.count > 0) {
            [petrolArray addObject:petrol];
        }
        
        if (atm.count > 0) {
            [atmArray addObject:atm];
        }
    }
}

#pragma mark -  UI

- (void)creatUI{
    
    int height = 35;
    int fontSize = 13;
    int padding = 10;
    int margin = 0;
    int labelHeight = 10;
    int labelWidth = 40;
    int scrollHeight = 45;
    
    int imageSize = 16;
    if (deviceType == DEVICE_TYPE_IPAD) {
        height = 70;
        fontSize = 23;
        padding = 30;
        margin = 10;
        labelHeight = 20;
        labelWidth = 80;
        imageSize = 32;
        scrollHeight = 90;
    }
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    float dis = (self.view.frame.size.width-60)/5;
    
    for (int i=0; i<4; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30+(dis-7)*i, TOP_HEADER_HEIGHT+statusBarHeight+10, labelWidth, labelHeight)];
        label.text = [NSString stringWithFormat: @"%dkm", 5*(i+1) ];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(dis*5+10, TOP_HEADER_HEIGHT+statusBarHeight+10, labelWidth, labelHeight)];
    label.text = @"All";
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    distanceFilter = [[UISlider alloc] initWithFrame:CGRectMake(30, TOP_HEADER_HEIGHT+statusBarHeight+10+labelHeight, self.view.frame.size.width-60, labelHeight)];
    
    UIImage *sliderLeftTrackImage = [UIImage imageNamed: @"slider_track_fill.png"];
    UIImage *sliderRightTrackImage = [UIImage imageNamed: @"slider_track.png"];
    
    [distanceFilter setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [distanceFilter setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    [distanceFilter setThumbImage:[UIImage imageNamed:@"slider_cap.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:distanceFilter];
    
    tapCount = 0; // Count tap on Slider
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [distanceFilter addGestureRecognizer:gr];
    
    distanceFilter.maximumValue = 30;
    distanceFilter.minimumValue = 5;
    
    distanceFilter.value = 30;
    // As the slider moves it will continously call the -valueChanged:
    distanceFilter.continuous = NO; // NO makes it call only once you let go
    
    
    [distanceFilter addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    int arrowWidth = 8;
    int arrowHeight = 14;
    if (IS_IPAD) {
        arrowWidth = 16;
        arrowHeight = 28;
    }
    
    UIImageView *prevIV = [[UIImageView alloc] initWithFrame:CGRectMake(padding, distanceFilter.frame.origin.y + distanceFilter.frame.size.height + (scrollHeight-arrowHeight)/2, arrowWidth, arrowHeight)];
    [prevIV setImage:[UIImage imageNamed:@"back_arrow_ipad"]];
    
    UIImageView *nextIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-arrowWidth-(padding), distanceFilter.frame.origin.y + distanceFilter.frame.size.height + (scrollHeight-arrowHeight)/2, arrowWidth, arrowHeight)];
    [nextIV setImage:[UIImage imageNamed:@"next_arrow_ipad"]];
    
    [self.view addSubview:prevIV];
    [self.view addSubview:nextIV];
    
    DropDownScroll *dropScroll = [[DropDownScroll alloc] initWithFrame:CGRectMake(padding+arrowWidth, distanceFilter.frame.origin.y + distanceFilter.frame.size.height, self.view.frame.size.width-(arrowWidth+padding)*2, scrollHeight)];
    dropScroll.dele = self;

    [dropScroll loadData:facilityTypeArray dropDownScrollType:IntFacilityType];
    [self.view addSubview:dropScroll];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(margin, dropScroll.frame.origin.y + dropScroll.frame.size.height+padding, self.view.frame.size.width-margin*2, self.view.frame.size.height-dropScroll.frame.origin.y - dropScroll.frame.size.height-padding) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)sliderTapped:(UIGestureRecognizer *)g
{
    [self creatHUD];
    
    tapCount = tapCount + 1;
    
    /////////////// For TapCount////////////
    
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted){
        [self valueChanged:s];
        return; // tap on thumb, let slider deal with it
    }
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    
    float newStep = roundf(value / 5);
    if (newStep > 4) {
        newStep = 6;
    }
    // Convert "steps" back to the context of the sliders values.
    [distanceFilter setValue:(newStep * 5) animated:YES];
    currentDistance = distanceFilter.value;
    
    [self creatFacilityArray:currentDistance location:self.currentLocation];
    [table reloadData];
    
    [self hideHud];
}

#pragma mark - Slider Delegate
- (void)valueChanged:(UISlider *)sender {
    // round the slider position to the nearest index of the numbers array
    [self creatHUD];
    
   // NSLog(@"sliderIndex: %f", distanceFilter.value);
    
    float newStep = roundf(distanceFilter.value / 5);
    if (newStep > 4) {
        newStep = 6;
    }
    [distanceFilter setValue:(newStep * 5) animated:YES];
    currentDistance = distanceFilter.value;
    
    [self creatFacilityArray:currentDistance location:self.currentLocation];
    
    [table reloadData];
    [self hideHud];
}

#pragma mark - DropDownScrollDelegate
- (void)changeAno:(NSInteger)tag{
    NSLog(@"tag : %d", tag);
    facilityIndex = tag;
    intFacilityType = [[[facilityTypeArray objectAtIndex:facilityIndex ] objectForKey:@"intFacilityType"] intValue];
    [self creatHUD];
    [self creatFacilityArray:currentDistance location:self.currentLocation];
    
    [table reloadData];
    
    [self hideHud];
}

- (void)clickDynamic:(NSInteger)tag{
    NSLog(@"tag : %d", tag);
    facilityIndex = tag;
    intFacilityType = [[[facilityTypeArray objectAtIndex:facilityIndex ] objectForKey:@"intFacilityType"] intValue];
    //[self creatFacilityArray:currentDistance location:self.currentLocation];
    //[table reloadData];
    [self hideHud];
}

- (void)selectHighWay{
    
}

#pragma mark - UIButtonClick
- (void)click:(UIButton *)sender{
    
    sender.selected = YES;
    intFacilityType = [[[facilityTypeArray objectAtIndex:sender.tag ] objectForKey:@"intFacilityType"] intValue];
    if (sender.tag == 0) {
        titleLabel.text = @"Petrol Station";
        segmentIndex = 0;
        [[btnArray objectAtIndex:1] setSelected:NO];
    }else {
        titleLabel.text = @"ATM";
        segmentIndex = 1;
        [[btnArray objectAtIndex:0] setSelected:NO];
    }
    
    [table reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (intFacilityType == 1000) {
        return 1;
    }
    return [facilityArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /*
    if (segmentIndex == 0) {
        return [[petrolArray objectAtIndex:section] count];
    }
    return [[atmArray objectAtIndex:section] count];
     */
    if(intFacilityType == 1000)
        return [facilityArray count];
    return [[facilityArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int fontSize = 13;
    int cellHeight = 45;
    int padding = 10;
    int padding1 =10;
    int padding2 = 3;
    int imageSize = 20;
    int labelWidthLimit = 150;
    
    int nearbyImageSize = 70;
    int nameLabelHeight = 20;
    int addressLabelHeight = 60;
    int addressFontSize = 13;
    if (deviceType == DEVICE_TYPE_IPAD) {
        fontSize = 26;
        cellHeight = 90;
        padding = 20;
        imageSize = 56;
        padding1 = 30;
        padding2 = 5;
        labelWidthLimit = 400;
        
        nearbyImageSize = 120;
        nameLabelHeight = 30;
        addressLabelHeight =90;
        addressFontSize = 24;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    int i=0;
    
    if(intFacilityType == 0 || intFacilityType == 2){
        
        NSDictionary *dic = [[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        NSString *idBrand = [dic objectForKey:@"idBrand"];
        
        UIImageView *brandView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, (cellHeight-imageSize)/2, imageSize, imageSize)];
        brandView.image = [UIImage imageNamed:idBrand];
        [brandView setContentMode:UIViewContentModeScaleToFill];
        [brandView setClipsToBounds:YES];
        [cell.contentView addSubview:brandView];
        
        UILabel *strNameLabel = [[UILabel alloc] init];
        NSString *strName = [dic objectForKey:@"strName"];
        CGSize size = [strName sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByTruncatingTail];
        
        strNameLabel.frame = CGRectMake(padding + (imageSize + padding2), 0, MIN(size.width, labelWidthLimit), cellHeight);
        strNameLabel.text = strName;
        strNameLabel.backgroundColor = [UIColor clearColor];
        strNameLabel.font = [UIFont systemFontOfSize:fontSize];
        strNameLabel.textColor = [UIColor whiteColor];
        strNameLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:strNameLabel];
        
        NSString *decLocation = [[NSString alloc] initWithString:[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"]];
        //   NSLog(@"decLocation=========%@",decLocation);
        
        CGSize size1 = [[NSString stringWithFormat:@"KM%@",decLocation] sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel *decLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-size1.width-padding, 0, size1.width, cellHeight)];
        
        decLocationLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
        decLocationLabel.textAlignment = NSTextAlignmentCenter;
        decLocationLabel.textColor = [UIColor whiteColor];
        decLocationLabel.backgroundColor = [UIColor clearColor];
        
        decLocationLabel.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:decLocationLabel];
        
        NSString *idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        NSInteger intParentType = [[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"intParentType"] intValue];
        
        if (intParentType == 0) {
            NSInteger strType = [[[NSDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:idParent]] objectForKey:@"strType"] integerValue];
            if (strType == 3) {
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"rsa_signature_ipad.png" : @"rsa_signature.png")];
                [cell.contentView addSubview:foodImageView];
                i++;
            }
        }
        if ([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11) {
            
            NSMutableArray *serVicesArray = [NSMutableArray arrayWithArray:[TblFacilitiesEntry searchFacilityByIdParent:idParent intParentType:intParentType]];
            NSDictionary *facility;
            int count = 0;
            for(facility in serVicesArray){
                if ([[facility objectForKey:@"intFacilityType"] intValue] == 11) {
                    NSMutableArray *facilityImageArr = [TblFacilitiesEntry searchFacilityImagesByIdFacilities:[[facility objectForKey:@"idFacilities"] intValue]];
                    count = [facilityImageArr count];
                    if(count > 0)
                        break;
                }
            }
            
            if(count > 0){
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                [cell.contentView addSubview:foodImageView];
                i++;
            }
        }
        
        if (intParentType == 0){
            NSString *newIdParent = [idParent substringFromIndex:10];
            NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
            if ([cctvRSA count] > 0) {
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
                [cell.contentView addSubview:foodImageView];
            }
        }else{
            UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
            foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
            [cell.contentView addSubview:foodImageView];
        }
        
    }else if((intFacilityType>2 && intFacilityType<=11) || (intFacilityType == 1001) || (intFacilityType == 1002)){
        
        NSDictionary *dic = [[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *strName = [dic objectForKey:@"strName"];
        
        CGSize size = [strName sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByTruncatingTail];
        
        UILabel *strNameLabel = [[UILabel alloc] init];
        
        strNameLabel.frame = CGRectMake(padding, 0, MIN(size.width, (labelWidthLimit+imageSize+padding2)), cellHeight);
        strNameLabel.text = strName;
        strNameLabel.backgroundColor = [UIColor clearColor];
        strNameLabel.font = [UIFont systemFontOfSize:fontSize];
        strNameLabel.textColor = [UIColor whiteColor];
        strNameLabel.adjustsFontSizeToFitWidth = YES;
        
        [cell.contentView addSubview:strNameLabel];
        
        NSString *decLocation = [[NSString alloc] initWithString:[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"]];
        //   NSLog(@"decLocation=========%@",decLocation);
        CGSize size1 = [[NSString stringWithFormat:@"KM%@",decLocation] sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel *decLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-size1.width-padding, 0, size1.width, cellHeight)];
        decLocationLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
        decLocationLabel.textAlignment = NSTextAlignmentCenter;
        //decLocationLabel.textColor = [UIColor colorWithRed:76.0/255 green:209.0/255 blue:255.0/255 alpha:1];
        decLocationLabel.textColor = [UIColor whiteColor];
        decLocationLabel.backgroundColor = [UIColor clearColor];
        
        decLocationLabel.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:decLocationLabel];
    
        NSString *idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        NSInteger intParentType = -1;
        if((intFacilityType>2 && intFacilityType<=11)){
            intParentType = [[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"intParentType"] intValue];
            
            if (intParentType == 0) {
                NSInteger strType = [[[NSDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:idParent]] objectForKey:@"strType"] integerValue];
                if (strType == 3) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"rsa_signature_ipad.png" : @"rsa_signature.png")];
                    [cell.contentView addSubview:foodImageView];
                    i++;
                }
            }
        }
        if ([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11) {
            
            NSMutableArray *serVicesArray = [NSMutableArray arrayWithArray:[TblFacilitiesEntry searchFacilityByIdParent:idParent intParentType:intParentType]];
            NSDictionary *facility;
            int count = 0;
            for(facility in serVicesArray){
                if ([[facility objectForKey:@"intFacilityType"] intValue] == 11) {
                    NSMutableArray *facilityImageArr = [TblFacilitiesEntry searchFacilityImagesByIdFacilities:[[facility objectForKey:@"idFacilities"] intValue]];
                    count = [facilityImageArr count];
                    if(count > 0)
                        break;
                }
            }
            
            if(count > 0){
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                [cell.contentView addSubview:foodImageView];
                i++;
            }
        }
        
        /*
        if (intParentType == 0){
            NSString *newIdParent = [idParent substringFromIndex:10];
            NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
            if ([cctvRSA count] > 0) {
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
                [cell.contentView addSubview:foodImageView];
            }
        }else{
            UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
            foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
            [cell.contentView addSubview:foodImageView];
        }
         */
        
        NSString *newIdParent = [idParent substringFromIndex:10];
        NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
        if ([cctvRSA count] > 0) {
            UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(strNameLabel.frame.origin.x+strNameLabel.frame.size.width+i*(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
            foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
            [cell.contentView addSubview:foodImageView];
        }
    }else if(intFacilityType == 1000){
        
        NSDictionary *dic = [facilityArray objectAtIndex:indexPath.row];
        
        UIImageView *picture = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, nearbyImageSize, nearbyImageSize)];
        [picture setContentMode:UIViewContentModeScaleToFill];
        [picture setClipsToBounds:YES];
        [picture setTag:111];
        [cell.contentView addSubview:picture];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + nearbyImageSize + padding, padding, tableView.frame.size.width-padding*2 - nearbyImageSize - padding, nameLabelHeight)];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setTag:222];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + nearbyImageSize + padding, nameLabel.frame.origin.y+nameLabelHeight, tableView.frame.size.width-padding*2 - nearbyImageSize - padding, addressLabelHeight)];
        [addressLabel setFont:[UIFont systemFontOfSize:addressFontSize]];
        [addressLabel setNumberOfLines:3];
        [addressLabel setTextColor:[UIColor whiteColor]];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [addressLabel setTag:333];
        
        //[addressLabel setNumberOfLines:0];
        //[addressLabel sizeToFit];
        [cell.contentView addSubview:addressLabel];
        
        NSString *strURL = [dic objectForKey:@"strLocationImg"];
        UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:strURL]]; //Img_URL is NSString of your image URL
        if (img) {       //If image is previously downloaded set it and we're done.
            [picture setImage:img];
            [[SDImageCache sharedImageCache] removeImageForKey:strURL fromDisk:YES];
        }else{
            [picture setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"no_image.png"] success:^(UIImage *image, BOOL cached) {
            } failure:^(NSError *error) {
                
            }];
        }
        
        [nameLabel setText:[dic objectForKey:@"strTitle"]];
        
        NSString *address = [dic objectForKey:@"strAddress"];
        CGSize addressLabelSize = [address sizeWithFont:addressLabel.font
                                      constrainedToSize:CGSizeMake(210.0f, 60.0f)
                                          lineBreakMode:addressLabel.lineBreakMode];
        /*
        [addressLabel setFrame:CGRectMake(addressLabel.frame.origin.x,
                                          addressLabel.frame.origin.y,
                                          addressLabelSize.width,
                                          addressLabelSize.height)];
         */
        [addressLabel setText:address];
    }
    /*
    if (intFacilityType != 1000) {
        int i=0;
        NSString *idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        if ([[[TblFacilitiesEntry searchIntFacilityType:idParent] objectForKey:@"intFacilityType"] intValue] == 11) {
            
            UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170+i*20, 12, 20, 20)];
            foodImageView.image = [UIImage imageNamed:@"foodSignature.png"];
            [cell.contentView addSubview:foodImageView];
            i++;
            
            NSInteger intParentType = [[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"intParentType"] intValue];
            
            if (intParentType == 0) {
                ∂∂
                NSString *newIdParent = [[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170+i*20, 12, 20, 20)];
                    foodImageView.image = [UIImage imageNamed:@"cctv.png"];
                    [cell.contentView addSubview:foodImageView];
                }
     
            }
        }
    }
    */
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(intFacilityType == 0){
        BInformationViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
        tollPlaza.strName = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        tollPlaza.strDirection = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
        tollPlaza.decLocation = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        tollPlaza.idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        tollPlaza.intParentType = 1;
        [self.navigationController pushViewController:tollPlaza animated:YES];
    }else if(intFacilityType == 1000){
        
        BPlaceDetailViewController *tollPlaza1 = [self.storyboard instantiateViewControllerWithIdentifier:@"placedetailViewController"];
        [tollPlaza1 setNearbyDict:[facilityArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:tollPlaza1 animated:YES];
    }else if(intFacilityType == 1002){
        
        BInformationViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
        tollPlaza.strName = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        tollPlaza.strDirection = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
        tollPlaza.decLocation = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        tollPlaza.idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        tollPlaza.intParentType = 2;
        [self.navigationController pushViewController:tollPlaza animated:YES];

    }else{
        
        BInformationViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
        tollPlaza.strName = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        tollPlaza.strDirection = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
        tollPlaza.decLocation = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        tollPlaza.idParent = [[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        
        tollPlaza.intParentType = [[[[facilityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"intParentType"] intValue];
        [self.navigationController pushViewController:tollPlaza animated:YES];
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        if (intFacilityType == 1000) {
            return 180;
        }
        return 90;
    }
    if (intFacilityType == 1000) {
        return 90;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        return 80;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    int height = 40;
    int padding1 = 10;
    int padding2 = 4;
    int fontSize = 15;
    if (deviceType == DEVICE_TYPE_IPAD) {
        height = 80;
        padding1 = 10;
        padding2 = 8;
        fontSize = 30;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding1, 0, tableView.frame.size.width - padding1*2, height - padding2)];
    
    label.backgroundColor = [UIColor colorWithRed:83/255.0 green:96/255.0 blue:111/255.0 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    
    label.layer.borderColor = [[UIColor colorWithRed:79.0/255 green:221.0/255 blue:156.0/255 alpha:1] CGColor];
    label.layer.borderWidth = 1.0;
    
    /*
    label.text = [NSString stringWithFormat:@"%@",[[TblHighwayEntry searchHighwayByIdHighway:[[[[facilityArray objectAtIndex:facilityIndex ] objectAtIndex:section] objectAtIndex:0] objectForKey:@"idHighway"]] objectForKey:@"strName"]];
     */
    if (intFacilityType == 1000)
        label.text = @"Across All Highway";
    else
        label.text = [NSString stringWithFormat:@"%@",[[highWayArray objectAtIndex:section] objectForKey:@"strName"]];
//    label.text = @"Hello";
    [view addSubview:label];

    return view;
}

#pragma mark - CreatLocationManager

- (void)CreatLocationManager{
    
    CLLocationManager *temp = [[CLLocationManager alloc] init];
    self.locManager = temp;
    
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    
    locManager.pausesLocationUpdatesAutomatically = NO;
    
    [self.locManager startUpdatingLocation];
}

#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (!isGetLoc) {
        
        isGetLoc = YES;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        //CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
        self.currentLocation = location;
        
        [self creatFacilityArray:currentDistance location:self.currentLocation];
        
        [table reloadData];
    }
    
    [manager stopUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    isGetLoc = NO;
    
    [manager stopUpdatingLocation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:3.059342672138269 longitude:101.67370319366455];
    self.currentLocation = location;
    
    [self creatFacilityArray:currentDistance location:self.currentLocation];
    
    [table reloadData];
}
@end
