

#import "BJourneySearchResultVC.h"
#import "BInformationViewController.h"
#import "TblTollFareEntry.h"
#import "TblTollPlazaEntry.h"
#import "TblRouteDetails.h"
#import "TblCSC.h"
#import "TblRSA.h"
#import "TblPetrolStation.h"
#import "Constants.h"
@interface BJourneySearchResultVC ()
{
    int headerHeight;
    int fontSize;
    int fontSize1;
    int labelHeight;
    int roadImageWidth;
    int padding;
    int exitWidth;
    int lineHeight;
    int lineSpace;
    int lineWidth;
    int delta;
}
@end

@implementation BJourneySearchResultVC
@synthesize carIndex;

@synthesize idTollPlazaFromDic;
@synthesize idTollPlazaToDic;
@synthesize routesArray;
@synthesize strDirection;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // titleStr = [NSString stringWithFormat:@"%@-%@",idTollPlazaFromStr,idTollPlazaToStr];
    
    NSLog(@"TollPlazaFromDic=%@", idTollPlazaFromDic);
    
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",[idTollPlazaFromDic objectForKey:@"strName"],[idTollPlazaToDic objectForKey:@"strName"]];
    
    roadImageWidth = 131;
    headerHeight = 20;
    exitWidth = 50;
    labelHeight = 13;
    fontSize = 13;
    fontSize1 = 11;
    lineHeight = 46;
    lineSpace = 37;
    lineWidth = 5;
    delta = 7;
    if (IS_IPAD) {
        roadImageWidth = 262;
        headerHeight = 40;
        exitWidth = 100;
        labelHeight = 30;
        fontSize = 24;
        fontSize1 = 20;
        lineHeight = 92;
        lineSpace = 74;
        lineWidth = 10;
        delta = 14;
    }
    //[self creatAnnouncements];
    
    [self creatUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -  UI

- (void)creatUI{
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:routesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    for (int i = 0; i<7; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"journeyTableViewBG"]];
        imageView.frame = CGRectMake(self.view.frame.size.width-roadImageWidth-13+5, statusBarHeight+TOP_HEADER_HEIGHT+headerHeight+(self.view.frame.size.height-statusBarHeight-TOP_HEADER_HEIGHT-headerHeight)/7*i, roadImageWidth, (self.view.frame.size.height-statusBarHeight-TOP_HEADER_HEIGHT-headerHeight)/7);
        [self.view addSubview:imageView];
    }
    
    
    for (int i = 0; i<4; i++) {
        
        UIImageView *whiteLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteLine"]];
        whiteLineImageView.frame = CGRectMake(self.view.frame.size.width-roadImageWidth/2+delta, statusBarHeight+TOP_HEADER_HEIGHT+headerHeight+(lineHeight+lineSpace)*i, lineWidth, lineHeight);
        [self.view addSubview:whiteLineImageView];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"class%dCarTop",carIndex] ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *carImageView = [[UIImageView alloc] initWithImage:image];
    carImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    carImageView.center = CGPointMake(self.view.frame.size.width-roadImageWidth/2+delta, self.view.frame.size.height-image.size.height/2-padding+statusBarHeight);
    [self.view addSubview:carImageView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return routesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(exitWidth, 6+labelHeight*i, self.view.frame.size.width-roadImageWidth-13-exitWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        
        switch (i) {
            case 0:
            {
                
                int intParentType;
                
                if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 0) {
                    intParentType = 0;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 1) {
                    intParentType = 1;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 2){
                    intParentType = 2;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 3){
                    intParentType = 3;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 4){
                    intParentType = 0;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 5){
                    intParentType = 0;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 6){
                    intParentType = 0;
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 7){
                    intParentType = 0;
                }else{
                    intParentType = 0;
                }
                
                
                NSMutableDictionary *dic;
                if (intParentType == 0) {
                    //RSA
                    dic = [NSMutableDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                }else if (intParentType == 1) {
                    //Petrol Station
                    dic = [NSMutableDictionary dictionaryWithDictionary:[TblPetrolStation searchPetrolStation:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                }else if (intParentType == 2) {
                    //CSC
                    dic = [NSMutableDictionary dictionaryWithDictionary:[TblCSC searchCSC:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                }else if (intParentType == 3) {
                    //Toll Plaza
                    dic = [NSMutableDictionary dictionaryWithDictionary:[TblTollPlazaEntry searchTollPlaza:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                }
                //                NSLog(@"intParentType===%d",intParentType);
                //                NSLog(@"====%@",[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]);
                //                NSLog(@"=====%@",dic);
                label.text = [dic objectForKey:@"strName"];
                label.font = [UIFont boldSystemFontOfSize:fontSize];
                label.textColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1];
            }
                break;
            case 1:
            {  /*
                0-RSA
                1-Petrol Station
                2-CSC
                3-Toll Plaza
                4-OBR
                5-Lay-by
                6-Interchange
                7-Tunnel
                8-vista point
                */
                
                if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 0) {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                    if ([[dic objectForKey:@"strType"] intValue] == 3) {
                        label.text = @"RSA Signature";
                    }else {
                        label.text = @"RSA";
                    }
                    
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 1) {
                    label.text = @"Petrol Station";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 2){
                    label.text = @"CSC";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 3){
                    label.text = @"Toll Plaza";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 4){
                    label.text = @"OBR";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 5){
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
                    if ([[dic objectForKey:@"strType"] intValue] == 1) {
                        label.text = @"RSA Signature";
                    }else {
                        label.text = @"Lay-by";
                    }
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 6){
                    label.text = @"Interchange";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 7){
                    label.text = @"Tunnel";
                }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 8){
                    label.text = @"Vista Point";
                }
                
                label.font = [UIFont systemFontOfSize:fontSize1];
                label.textColor = [UIColor grayColor];
                
            }
                break;
            case 2:
            {
                label.text = [NSString stringWithFormat:@"KM%.2lf",[[[routesArray objectAtIndex:indexPath.row] objectForKey:@"decLocation"] doubleValue]];
                
                label.font = [UIFont systemFontOfSize:fontSize1];
                label.textColor = [UIColor darkGrayColor];
            }
                break;
                
            default:
                break;
        }
        label.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:label];
    }
    
    if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"strExit"] length] > 0) {
        
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 23, 60, 20)];
        tagLabel.backgroundColor = [UIColor colorWithRed:.96 green:.89 blue:.25 alpha:1];
        tagLabel.textColor = [UIColor blackColor];
        tagLabel.text = [[routesArray objectAtIndex:indexPath.row] objectForKey:@"strExit"];
        tagLabel.font = [UIFont boldSystemFontOfSize:12];
        tagLabel.layer.masksToBounds = YES;
        //tagLabel.layer.cornerRadius = 6.0;
        //tagLabel.layer.borderWidth = 1;
        //tagLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:tagLabel];
    }
    
    if (indexPath.row == 0) {
        UIImageView *whiteLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangleImage.png"]];
        whiteLineImageView.frame = CGRectMake(self.view.frame.size.width-roadImageWidth-13+32+5, 18, 12, 18);
        whiteLineImageView.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:whiteLineImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int intParentType;
    int intStrType;
    
    if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 0) {
        intParentType = 0;
        intStrType = 2;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 1) {
        intParentType = 1;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 2){
        intParentType = 2;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 3){
        intParentType = 3;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 4){
        intParentType = 0;
        intStrType = 7;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 5){
        intParentType = 0;
        intStrType = 0;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 6){
        intParentType = 0;
        intStrType = 4;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 7){
        intParentType = 0;
        intStrType = 5;
    }else if ([[[routesArray objectAtIndex:indexPath.row] objectForKey:@"intType"] intValue] == 8){
        intParentType = 0;
        intStrType = 6;
    }
    
    
    NSMutableDictionary *dic;
    
    if (intParentType == 0) {
        //RSA
        dic = [NSMutableDictionary dictionaryWithDictionary:[TblRSA searchTblRSA:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
    }else if (intParentType == 1) {
        //Petrol Station
        dic = [NSMutableDictionary dictionaryWithDictionary:[TblPetrolStation searchPetrolStation:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
    }else if (intParentType == 2) {
        //CSC
        dic = [NSMutableDictionary dictionaryWithDictionary:[TblCSC searchCSC:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
    }else if (intParentType == 3) {
        //Toll Plaza
        dic = [NSMutableDictionary dictionaryWithDictionary:[TblTollPlazaEntry searchTollPlaza:[[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"]]];
    }
    
    // NSLog(@"%@",dic);
    
    BInformationViewController *information = [self.storyboard instantiateViewControllerWithIdentifier:@"binformationViewController"];
    
    information.strName = [dic objectForKey:@"strName"];
    information.decLocation = [dic objectForKey:@"decLocation"];
    information.intParentType = intParentType;
    information.strDirection = [dic objectForKey:@"strDirection"];
    information.idParent = [[routesArray objectAtIndex:indexPath.row] objectForKey:@"idRouteItem"];
    
    //information.intStrType = intStrType;
    information.intStrType = [[dic objectForKey:@"strType"] intValue];
    
    if (intParentType == 0) {
        information.strSignatureName = [dic objectForKey:@"strSignatureName"];
    }else if (intParentType == 2) {
        information.strOperationHour = [dic objectForKey:@"strOperationHour"];
    }
    
    [self.navigationController pushViewController:information animated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight-headerHeight)/6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    view.backgroundColor = [UIColor colorWithRed:.57 green:.57 blue:.58 alpha:1];
    
    UILabel *ratesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    if ([[[TblTollFareEntry searchDecTollAmt:[idTollPlazaFromDic objectForKey:@"idParent"] idTollPlazaTo:[idTollPlazaToDic objectForKey:@"idParent"] decTollAmtNum:carIndex] objectForKey:@"decTollAmt"] length] > 0) {
        ratesLabel.text = [NSString stringWithFormat:@"Rates:RM%@",[[TblTollFareEntry searchDecTollAmt:[idTollPlazaFromDic objectForKey:@"idParent"] idTollPlazaTo:[idTollPlazaToDic objectForKey:@"idParent"] decTollAmtNum:carIndex] objectForKey:@"decTollAmt"]];
    }else {
        ratesLabel.text = [NSString stringWithFormat:@"Rates:(Not Available)"];
    }
    ratesLabel.textColor = [UIColor whiteColor];
    ratesLabel.backgroundColor = [UIColor clearColor];
    ratesLabel.textAlignment = NSTextAlignmentCenter;
    ratesLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    [view addSubview:ratesLabel];
    
    /*
     NSDictionary *fromDic = [[NSDictionary alloc] initWithDictionary:[TblTollPlazaEntry searchTollPlaza:[[routesArray objectAtIndex:routesArray.count - 1] objectForKey:@"idRouteItem"] decLocation:[[routesArray objectAtIndex:routesArray.count - 1] objectForKey:@"decLocation"]]];
     CLLocationDegrees fromLatitude = [[fromDic objectForKey:@"decLat"] doubleValue];
     CLLocationDegrees fromLongitude = [[fromDic objectForKey:@"decLong"] doubleValue];
     [fromDic release];
     
     CLLocationCoordinate2D fromCoordinate = CLLocationCoordinate2DMake(fromLatitude, fromLongitude);
     
     
     NSDictionary *toDic = [[NSDictionary alloc] initWithDictionary:[TblTollPlazaEntry searchTollPlaza:[[routesArray objectAtIndex:0] objectForKey:@"idRouteItem"] decLocation:[[routesArray objectAtIndex:0] objectForKey:@"decLocation"]]];
     CLLocationDegrees toLatitude = [[toDic objectForKey:@"decLat"] doubleValue];
     CLLocationDegrees toLongitude = [[toDic objectForKey:@"decLong"] doubleValue];
     [toDic release];
     
     CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(toLatitude, toLongitude);
     
     NSString *distance = [self calculateRoutesFrom:fromCoordinate to:toCoordinate];
     
     
     UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 180, 20)];
     distanceLabel.text = [NSString stringWithFormat:@"Toll Distance:%@KM",distance];
     distanceLabel.textAlignment  = UITextAlignmentCenter;
     distanceLabel.backgroundColor = [UIColor clearColor];
     distanceLabel.textColor = [UIColor whiteColor];
     distanceLabel.font = [UIFont boldSystemFontOfSize:13];
     [view addSubview:distanceLabel];
     [distanceLabel release];
     */
    
    return view;
}




@end
