
#import "BJourneyViewController.h"
#import "BJourneySearchResultVC.h"
#import "BPenangBridgeVC.h"

#import "TblTollPlazaEntry.h"

#import "TblTollFareEntry.h"
#import "TblRouteDetails.h"

#import "BVehiclesClassVC.h"
#import "BTollFareOSVC.h"

#import "CustomLabel.h"
#import "Constants.h"
@interface BJourneyViewController ()
{
    CustomLabel *fromLabel;
    CustomLabel *toLabel;
    CustomLabel *classLabel;
    
    float paddingLeft;
    float paddingTop;
    float labelHeight;
    float fontSize;
    float buttonSize;
    float padding;
    float searchButtonSize;
    float underButtonSize;
    float dropDownHeight;
}

@end

@implementation BJourneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"My Journey";
    //[self creatAnnouncements];

    float buttonSize1 = 16.0;
    if (IS_IPAD) {
        buttonSize1 = 32.0;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonSize1, buttonSize1)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    [navigationBar setLeftButton:button];
    [backButton setHidden:YES];
    
    fromArray = [[NSArray alloc] initWithArray:[TblTollPlazaEntry searchAllFromTollPlaza]];
    toArray = [[NSArray alloc] initWithArray:[TblTollPlazaEntry searchAllFromTollPlaza]];
    
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
    
    paddingLeft = 20;
    paddingTop = 40;
    labelHeight = 36;
    fontSize = 15;
    buttonSize = 30;
    padding = 10;
    searchButtonSize = 40;
    underButtonSize = 20;
    dropDownHeight = 150;
    if (IS_IPAD) {
        paddingLeft = 40;
        paddingTop = 80;
        labelHeight = 72;
        fontSize = 25;
        buttonSize = 60;
        padding = 20;
        searchButtonSize = 60;
        underButtonSize = 40;
        dropDownHeight = 300;
    }
    
    fromLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(paddingLeft, TOP_HEADER_HEIGHT+statusBarHeight+paddingTop, self.view.frame.size.width-paddingLeft*2, labelHeight)];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1];
    fromLabel.font = [UIFont systemFontOfSize:fontSize];
    [fromLabel setBackgroundColor:[UIColor whiteColor]];
    fromLabel.layer.borderColor = [[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1] CGColor];
    fromLabel.layer.borderWidth = 1;
    fromLabel.text = [[fromArray objectAtIndex:fromIndex] objectForKey:@"strName"];
    fromLabel.userInteractionEnabled = NO;
    [self.view addSubview:fromLabel];
    
    UILabel *line1 = [[CustomLabel alloc] initWithFrame:CGRectMake(fromLabel.frame.origin.x+fromLabel.frame.size.width-buttonSize-1, TOP_HEADER_HEIGHT+statusBarHeight+paddingTop+(labelHeight-buttonSize)/2, 1, buttonSize)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    UIButton *fromButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fromButton.frame = CGRectMake(fromLabel.frame.origin.x+fromLabel.frame.size.width-buttonSize, TOP_HEADER_HEIGHT+paddingTop+statusBarHeight, buttonSize, buttonSize);
    [fromButton setImage:[UIImage imageNamed:@"dropdown1.png"] forState:UIControlStateNormal];
    [fromButton addTarget:self action:@selector(selectFrom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fromButton];
    
    toLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(paddingLeft, fromButton.frame.origin.y+fromButton.frame.size.height+padding, self.view.frame.size.width-paddingLeft*2, labelHeight)];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.textColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1];
    toLabel.font = [UIFont systemFontOfSize:fontSize];
    [toLabel setBackgroundColor:[UIColor whiteColor]];
    toLabel.layer.borderColor = [[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1] CGColor];
    toLabel.layer.borderWidth = 1;
    toLabel.text = [[toArray objectAtIndex:toIndex] objectForKey:@"strName"];
    toLabel.userInteractionEnabled = NO;
    [self.view addSubview:toLabel];
    
    UILabel *line2 = [[CustomLabel alloc] initWithFrame:CGRectMake(toLabel.frame.origin.x+toLabel.frame.size.width-buttonSize-1, fromButton.frame.origin.y+fromButton.frame.size.height + padding+(labelHeight-buttonSize)/2, 1, buttonSize)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    UIButton *toButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toButton.frame = CGRectMake(toLabel.frame.origin.x+toLabel.frame.size.width-buttonSize, fromButton.frame.origin.y+fromButton.frame.size.height + padding, buttonSize, buttonSize);
    [toButton setImage:[UIImage imageNamed:@"dropdown1.png"] forState:UIControlStateNormal];
    [toButton addTarget:self action:@selector(selectTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toButton];
    
    classLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(paddingLeft, toButton.frame.origin.y+toButton.frame.size.height+padding, self.view.frame.size.width-paddingLeft*2, labelHeight)];
    classLabel.backgroundColor = [UIColor clearColor];
    classLabel.textColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1];
    classLabel.font = [UIFont systemFontOfSize:fontSize];
    [classLabel setBackgroundColor:[UIColor whiteColor]];
    classLabel.layer.borderColor = [[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1] CGColor];
    classLabel.layer.borderWidth = 1;
    classLabel.text = [NSString stringWithFormat:@"Class %d",carIndex+1];
    classLabel.userInteractionEnabled = NO;
    [self.view addSubview:classLabel];
    
    UILabel *line3 = [[CustomLabel alloc] initWithFrame:CGRectMake(classLabel.frame.origin.x+classLabel.frame.size.width-buttonSize-1, toButton.frame.origin.y+toButton.frame.size.height+padding+(labelHeight-buttonSize)/2, 1, buttonSize)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3];

    UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(classLabel.frame.origin.x+classLabel.frame.size.width-buttonSize, toButton.frame.origin.y+toButton.frame.size.height+padding, buttonSize, buttonSize);
    [classButton setImage:[UIImage imageNamed:@"dropdown1.png"] forState:UIControlStateNormal];
    [classButton addTarget:self action:@selector(selectClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:classButton];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(paddingLeft, classButton.frame.origin.y+classButton.frame.size.height+paddingTop/2, self.view.frame.size.width-paddingLeft*2, searchButtonSize);
    [searchBtn setTitle:@"Search" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [searchBtn setBackgroundColor:[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1]];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(padding, searchBtn.frame.origin.y+searchBtn.frame.size.height+padding, self.view.frame.size.width-padding, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    UIUnderlinedButton *btnVehicles = [[UIUnderlinedButton alloc] initWithFrame:CGRectMake(paddingLeft,searchBtn.frame.origin.y+searchBtn.frame.size.height+paddingTop, self.view.frame.size.width-paddingLeft*2, underButtonSize)];
    btnVehicles.backgroundColor = [UIColor clearColor];
    [btnVehicles setTitle:@"Vehicle Class" forState:UIControlStateNormal];
    [btnVehicles setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnVehicles setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnVehicles.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnVehicles.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    [btnVehicles addTarget:self action:@selector(goToVehicles) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVehicles];
    
    UIUnderlinedButton *btn2 = [[UIUnderlinedButton alloc] initWithFrame:CGRectMake(paddingLeft, btnVehicles.frame.origin.y+btnVehicles.frame.size.height+padding, self.view.frame.size.width-paddingLeft*2, underButtonSize)];
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 setTitle:@"Penang Bridge And Others" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    [btn2 addTarget:self action:@selector(goToPengBridge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
}


- (void)setDDListFromHidden{
    
   	NSInteger height = isDDlistFromHidden ? 0 : dropDownHeight;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[_ddListFrom.view setFrame:CGRectMake(paddingLeft, fromLabel.frame.origin.y+fromLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, height)];
	[UIView commitAnimations];
    
    isDDlistFromHidden = !isDDlistFromHidden;
}

- (void)setDDListToHidden{
    
   	NSInteger height = isDDlistToHidden ? 0 : dropDownHeight;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[_ddListTo.view setFrame:CGRectMake(paddingLeft, toLabel.frame.origin.y+toLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, height)];
	[UIView commitAnimations];
    
    isDDlistToHidden = !isDDlistToHidden;
}

- (void)setDDListClassHidden{
    
   	NSInteger height = isDDlistClassHidden ? 0 : dropDownHeight;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[_ddListClass.view setFrame:CGRectMake(paddingLeft, classLabel.frame.origin.y+classLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, height)];
	[UIView commitAnimations];
    
    isDDlistClassHidden = !isDDlistClassHidden;
}

#pragma mark - UIButton
- (void)selectFrom{

    if (!_ddListFrom) {
        
       
        _ddListFrom = [[JourneyDDList alloc] initWithStyle:UITableViewStylePlain];
        _ddListFrom._delegate = self;
        _ddListFrom.ddlistTag = 0;
        _ddListFrom._resultList = fromArray;
        [self.view addSubview:_ddListFrom.view];
        [_ddListFrom.view setFrame:CGRectMake(paddingLeft, fromLabel.frame.origin.y+fromLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, 0)];
    }
    
    if (_ddListFrom) {
        [self.view bringSubviewToFront:_ddListFrom.view];
    }
    [self setDDListFromHidden];
    
    isDDlistToHidden = YES;
    isDDlistClassHidden = YES;
    
    [self setDDListToHidden];
    [self setDDListClassHidden];
}

- (void)selectTo{

    if (!_ddListTo) {
        
      
        _ddListTo = [[JourneyDDList alloc] initWithStyle:UITableViewStylePlain];
        _ddListTo._delegate = self;
        _ddListTo.ddlistTag = 1;
        _ddListTo._resultList = toArray;
        [self.view addSubview:_ddListTo.view];
        [_ddListTo.view setFrame:CGRectMake(paddingLeft, toLabel.frame.origin.y+toLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, 0)];
    }
    [self setDDListToHidden];
    
    isDDlistFromHidden = YES;
    isDDlistClassHidden = YES;
    [self setDDListFromHidden];
    [self setDDListClassHidden];

}

- (void)selectClass{

    if (!_ddListClass) {
        
       
        _ddListClass = [[JourneyDDList alloc] initWithStyle:UITableViewStylePlain];
        _ddListClass._delegate = self;
        _ddListClass.ddlistTag = 2;
        _ddListClass._resultList = [NSMutableArray arrayWithObjects:@"Class 1",@"Class 2",@"Class 3",@"Class 4",@"Class 5", nil];
        [self.view addSubview:_ddListClass.view];
        [_ddListClass.view setFrame:CGRectMake(paddingLeft, classLabel.frame.origin.y+classLabel.frame.size.height, self.view.frame.size.width-paddingLeft*2, 0)];
    }

    [self setDDListClassHidden];
    
    isDDlistFromHidden = YES;
    isDDlistToHidden = YES;
    [self setDDListFromHidden];
    [self setDDListToHidden];
}

- (void)search{
  //  NSLog(@"My Journey ======== search");
    
    if (fromIndex == toIndex) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Start location cannot be the same as the destination. Please select a different destination." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSLog(@"formARray : %@", [fromArray objectAtIndex:fromIndex]);
    
    NSMutableArray *idRouteStartArray = [[NSMutableArray alloc] initWithArray:[TblRouteDetails searchIdRouteByIdRouteItem:[[fromArray objectAtIndex:fromIndex] objectForKey:@"idParent"] intType:3 decLocation:[[fromArray objectAtIndex:fromIndex] objectForKey:@"decLocation"]]];
   
    NSMutableArray *idRouteEndArray = [[NSMutableArray alloc] initWithArray:[TblRouteDetails searchIdRouteByIdRouteItem:[[toArray objectAtIndex:toIndex] objectForKey:@"idParent"] intType:3 decLocation:[[toArray objectAtIndex:toIndex] objectForKey:@"decLocation"]]];
    
    if (idRouteStartArray.count == 0||idRouteEndArray.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    int idRoute = 0;
    int startIntSeq = 0;
    int endIntSeq = 0;
    
    for (int i = 0; i<idRouteStartArray.count; i++) {
        
        for (int j = 0; j<idRouteEndArray.count; j++) {
            
            if ([[[idRouteStartArray objectAtIndex:i] objectForKey:@"idRoute"] intValue] == [[[idRouteEndArray objectAtIndex:j] objectForKey:@"idRoute"] intValue]) {
               
                idRoute = [[[idRouteStartArray objectAtIndex:i] objectForKey:@"idRoute"] intValue];
                startIntSeq = [[[idRouteStartArray objectAtIndex:i] objectForKey:@"intSeq"] intValue];
                endIntSeq = [[[idRouteEndArray objectAtIndex:j] objectForKey:@"intSeq"] intValue];
                break;
            }
        }
    }
    
   NSLog(@"%d",idRoute);

    NSMutableArray *routesArray;
    if (startIntSeq < endIntSeq) {
          routesArray= [[NSMutableArray alloc] initWithArray:[TblRouteDetails searchRouteByIdRouteItem:startIntSeq endIntSeq:endIntSeq idRoute:idRoute order:@"desc"]];
    }else {
          routesArray= [[NSMutableArray alloc] initWithArray:[TblRouteDetails searchRouteByIdRouteItem:endIntSeq endIntSeq:startIntSeq idRoute:idRoute order:@"asc"]];
    }
  
   
    if (routesArray.count > 0) {
    
        BJourneySearchResultVC *result = [self.storyboard instantiateViewControllerWithIdentifier:@"journeysearchresultViewController"];
        result.carIndex = carIndex+1;
        result.idTollPlazaFromDic = [fromArray objectAtIndex:fromIndex];
        result.idTollPlazaToDic = [toArray objectAtIndex:toIndex];
        result.routesArray = routesArray;
        if (startIntSeq < endIntSeq) {
            result.strDirection = @"S";
        }else {
            result.strDirection = @"N";
        }
        [self.navigationController pushViewController:result animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (void)goToVehicles{

    BVehiclesClassVC *vehiclesClass = [self.storyboard instantiateViewControllerWithIdentifier:@"vehiclesclassViewController"];
    [self.navigationController pushViewController:vehiclesClass animated:YES];
}

- (void)goToPengBridge{

    BTollFareOSVC *tollFareOS = [self.storyboard instantiateViewControllerWithIdentifier:@"tollfareosViewController"];
    [self.navigationController pushViewController:tollFareOS animated:YES];
}

#pragma mark - PassValue protocol
- (void)passValue:(int)value listTag:(int)tag{
    
    if (tag== 0) {
        fromIndex = value;
        fromLabel.text = [[fromArray objectAtIndex:fromIndex] objectForKey:@"strName"];
        
        [self setDDListFromHidden];
    }else if (tag== 1) {
        toIndex = value;
        toLabel.text = [[toArray objectAtIndex:toIndex] objectForKey:@"strName"];
        [self setDDListToHidden];
    }else if(tag== 2) { 
        carIndex = value;
        classLabel.text = [NSString stringWithFormat:@"Class %d",carIndex+1];
        [self setDDListClassHidden];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];

    
            
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 115;
    }else if (indexPath.section == 3) {
        return 40;
    }
    return 31;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 3) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 3) {
        return nil;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 260, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:1];
        label.font = [UIFont boldSystemFontOfSize:15];
        if (section == 0) {
            label.text = @"FROM";
        }else if (section == 1) {
            label.text = @"TO";
        }else {
            label.text = @"Class";
        }
        [view addSubview:label];
        
        return view;
    }
}
 */

@end
