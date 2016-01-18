//
//  BRsaViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BRsaViewController.h"
#import "MCSegmentedControl.h"
#import "TblHighwayEntry.h"
#import "TblRSA.h"
#import "TblFacilitiesEntry.h"
#import "CustomButton.h"
#import "Constants.h"
#import "BInformationViewController.h"
@interface BRsaViewController ()

@end

@implementation BRsaViewController

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
    titleLabel.text = @"RSA";
    //[self creatAnnouncements];
    
    segmentIndex = 0;
    btnArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self creatRsaData];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"RSA Screen"];
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

- (void)creatRsaData{
    
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblRSA searchIdHighwayFromRSA]];
    highWayDetailArray = [[NSMutableArray alloc] initWithCapacity:2];
    
      NSLog(@"highWayArray:%@",highWayArray);
    
    
    rsaArray = [[NSMutableArray alloc] initWithCapacity:2];
    laybyArray = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i<highWayArray.count; i++) {
        
        NSString *highWayStr = [highWayArray objectAtIndex:i];
          NSLog(@"%@",[TblHighwayEntry searchHighwayByIdHighway:highWayStr]);
        [highWayDetailArray addObject:[TblHighwayEntry searchHighwayByIdHighway:highWayStr]];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblRSA searchRSAByIdHighway:highWayStr]];
         NSLog(@"++++++++%@",array);
        NSMutableArray *rsa = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *layby = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i<[array count]; i++) {
            if ([[[array objectAtIndex:i] objectForKey:@"strType"] intValue] == 0 || [[[array objectAtIndex:i] objectForKey:@"strType"] intValue] == 1) {
                [layby addObject:[array objectAtIndex:i]];
            }else if ([[[array objectAtIndex:i] objectForKey:@"strType"] intValue] == 2 || [[[array objectAtIndex:i] objectForKey:@"strType"] intValue] == 3) {
                [rsa addObject:[array objectAtIndex:i]];
            }
        }
        if (rsa.count > 0) {
            [rsaArray addObject:rsa];
        }
        
        if (layby.count >0) {
            [laybyArray addObject:layby];
        }
          NSLog(@"rsaArray:%@",rsaArray);
          NSLog(@"laybyArray:%@",laybyArray);
        
    }
     //NSLog(@"tollPlazaDic===%@",tollPlazaDic);
    
}

#pragma mark -  UI

- (void)creatUI{
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    int height = 35;
    int fontSize = 13;
    int padding = 10;
    int margin = 0;
    
    if (deviceType == DEVICE_TYPE_IPAD) {
        height = 70;
        fontSize = 23;
        padding = 30;
        margin = 10;
    }
    for (int i = 0; i<2; i++) {
        CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2*i, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width/2, height)];
        btn.tag = i;
        if (i == 0) {
            [btn setButtonColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setButtonColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setTitle:@"RSA-rest, services arena" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            btn.selected = YES;
        }else {
            [btn setButtonColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setButtonColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setTitle:@"Lay-By" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btnArray addObject:btn];
    }
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(margin, TOP_HEADER_HEIGHT+statusBarHeight+height+padding, self.view.frame.size.width-margin*2, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-height-padding) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - UIButtonClick
- (void)click:(UIButton *)sender{
    
    sender.selected = YES;
    
    if (sender.tag == 0) {
        titleLabel.text = @"RSA";
        segmentIndex = 0;
        [[btnArray objectAtIndex:1] setSelected:NO];
    }else {
        titleLabel.text = @"Lay-by";
        segmentIndex = 1;
        [[btnArray objectAtIndex:0] setSelected:NO];
    }
    
    [table reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //return highWayArray.count;
    
    if (segmentIndex == 0) {
        // NSLog(@"rsaArray.count;%d",rsaArray.count);
        
        return rsaArray.count;
    }else {
        //  NSLog(@"laybyArray.count;%d",laybyArray.count);
        
        return laybyArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (segmentIndex == 0) {
        return [[rsaArray objectAtIndex:section] count];
    }
    return [[laybyArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int fontSize = 15;
    int cellHeight = 45;
    int padding = 10;
    int padding1 =10;
    int padding2 = 2;
    int imageSize = 20;
    if (deviceType == DEVICE_TYPE_IPAD) {
        fontSize = 30;
        cellHeight = 90;
        padding = 20;
        imageSize = 56;
        padding1 = 30;
        padding2 = 5;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSString *strName;
    if (segmentIndex == 0) {
        strName = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
    }else {
        strName = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        
    }
    
    CGSize size = [strName sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel *strNameLabel = [[UILabel alloc] init];
    
    // NSLog(@"%@",[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]);
    
    // NSLog(@"%@",[TblFacilitiesEntry searchIntFacilityType:[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]]);
    
    @try {
        if (segmentIndex == 0) {
            
            if ([[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strType"] intValue] == 3) {
                
                //  NSLog(@"========");
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                starImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"rsa_signature_ipad.png" : @"rsa_signature.png")];
                [cell.contentView addSubview:starImageView];
                
                if ([[[TblFacilitiesEntry searchIntFacilityType:[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]] objectForKey:@"intFacilityType"] intValue] == 11) {
                    
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                    [cell.contentView addSubview:foodImageView];
                    
                    NSString *newIdParent = [[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                    NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                    if ([cctvRSA count] > 0) {
                        UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2)*2, (cellHeight-imageSize)/2, imageSize, imageSize)];
                        foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
                        [cell.contentView addSubview:foodImageView];
                    }
                }
            } else if ([[[TblFacilitiesEntry searchIntFacilityType:[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]] objectForKey:@"intFacilityType"] intValue] == 11) {
                
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                [cell.contentView addSubview:foodImageView];
                
                NSString *newIdParent = [[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
                    [cell.contentView addSubview:foodImageView];
                }
            } else {
                NSString *newIdParent = [[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:@"cctv_icon.png"];
                    [cell.contentView addSubview:foodImageView];
                }
            }
            
        }else {
            
            
            if ([[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strType"] intValue] == 1) {
                
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                starImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"rsa_signature_ipad.png" : @"rsa_signature.png")];
                [cell.contentView addSubview:starImageView];
                
                if ([[[TblFacilitiesEntry searchIntFacilityType:[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]] objectForKey:@"intFacilityType"] intValue] == 11) {
                    
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                    [cell.contentView addSubview:foodImageView];
                    
                    NSString *newIdParent = [[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                    NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                    if ([cctvRSA count] > 0) {
                        UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2)*2, (cellHeight-imageSize)/2, imageSize, imageSize)];
                        foodImageView.image = [UIImage imageNamed:@"cctv.png"];
                        [cell.contentView addSubview:foodImageView];
                    }
                }
            }else if ([[[TblFacilitiesEntry searchIntFacilityType:[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"]] objectForKey:@"intFacilityType"] intValue] == 11) {
                
                UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                foodImageView.image = [UIImage imageNamed:((IS_IPAD) ? @"intFacilityType11_ipad.png" : @"intFacilityType11.png")];
                [cell.contentView addSubview:foodImageView];
                
                NSString *newIdParent = [[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width+(imageSize+padding2), (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:@"cctv.png"];
                    [cell.contentView addSubview:foodImageView];
                }
            } else {
                NSString *newIdParent = [[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"] substringFromIndex:10];
                NSArray *cctvRSA = [TblRSA searchRSACCTVByIdParent:[newIdParent integerValue]];
                if ([cctvRSA count] > 0) {
                    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding1+size.width, (cellHeight-imageSize)/2, imageSize, imageSize)];
                    foodImageView.image = [UIImage imageNamed:@"cctv.png"];
                    [cell.contentView addSubview:foodImageView];
                }
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    strNameLabel.frame = CGRectMake(padding, 0, size.width, cellHeight);
    strNameLabel.text = strName;
    strNameLabel.backgroundColor = [UIColor clearColor];
    strNameLabel.font = [UIFont systemFontOfSize:fontSize];
    strNameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:strNameLabel];
    
    //NSLog(@"strName:%@",strName);
    
    
    //    cell.textLabel.text = strName;
    //    cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    
    NSString *decLocation;
    if (segmentIndex == 0) {
        decLocation = [[NSString alloc] initWithString:[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"]] ;
    }else {
        decLocation = [[NSString alloc] initWithString:[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"]];
    }
    //   NSLog(@"decLocation=========%@",decLocation);
    
    CGSize size1 = [[NSString stringWithFormat:@"KM%@",decLocation] sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, cellHeight) lineBreakMode:NSLineBreakByCharWrapping];
                   
    UILabel *decLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-size1.width-padding, 0, size1.width, cellHeight)];
    decLocationLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
    decLocationLabel.textAlignment = NSTextAlignmentCenter;
    decLocationLabel.backgroundColor = [UIColor clearColor];
    decLocationLabel.textColor = [UIColor whiteColor];
    decLocationLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [cell.contentView addSubview:decLocationLabel];
    
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"KM%@",decLocation];
    //    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    //    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    
    BInformationViewController *tollPlaza = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
    
    if (segmentIndex == 0) {
        
        // NSLog(@"%@",[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        
        tollPlaza.strName = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        tollPlaza.strDirection = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
        tollPlaza.decLocation = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        tollPlaza.intParentType = 0;
        tollPlaza.idParent = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        tollPlaza.intStrType = [[[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strType"] intValue];
        tollPlaza.strSignatureName = [[[rsaArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strSignatureName"];
        
    }else {
        
        // NSLog(@"%@",[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        
        tollPlaza.strName = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"];
        tollPlaza.strDirection = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strDirection"];
        tollPlaza.decLocation = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"decLocation"];
        tollPlaza.intParentType = 0;
        tollPlaza.idParent = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"idParent"];
        tollPlaza.intStrType = [[[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strType"] intValue];
        tollPlaza.strSignatureName = [[[laybyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strSignatureName"];
    }
    
    [self.navigationController pushViewController:tollPlaza animated:YES];

}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (deviceType == DEVICE_TYPE_IPAD) {
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding1, 0, tableView.frame.size.width - padding1*2, height - padding2)];
    label.backgroundColor = [UIColor colorWithRed:97/255.0 green:113/255.0 blue:129/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    label.layer.borderColor = [[UIColor colorWithRed:79.0/255 green:221.0/255 blue:156.0/255 alpha:1] CGColor];
    label.layer.borderWidth = 1.0;
    label.text = [NSString stringWithFormat:@"%@",[[highWayDetailArray objectAtIndex:section] objectForKey:@"strName"]];
    
    if (segmentIndex == 0) {
        label.text = [NSString stringWithFormat:@"%@",[[TblHighwayEntry searchHighwayByIdHighway:[[[rsaArray objectAtIndex:section] objectAtIndex:0] objectForKey:@"idHighway"]] objectForKey:@"strName"]];
    }else {
        label.text = [NSString stringWithFormat:@"%@",[[TblHighwayEntry searchHighwayByIdHighway:[[[laybyArray objectAtIndex:section] objectAtIndex:0] objectForKey:@"idHighway"]] objectForKey:@"strName"]];
    }
    [view addSubview:label];
    
    return view;
}


@end
