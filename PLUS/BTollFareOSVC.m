

#import "BTollFareOSVC.h"
#import "TblTollFareOSEntry.h"
#import "TblHighwayEntry.h"
#import "Constants.h"
@interface BTollFareOSVC ()
{
    int cellWidth;
    int nameCellWidth;
    int headerHeight;
    int rowHeight;
    int fontSize1;
    int fontSize2;
    int headHeight;
}
@end

@implementation BTollFareOSVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Toll Fare - Open System";
    
    cellWidth = 34;
    nameCellWidth = 150;
    headerHeight = 20;
    rowHeight = 25;
    headHeight = 27;
    fontSize1 = 11;
    fontSize2 = 13;
    if (IS_IPAD) {
        cellWidth = 68;
        nameCellWidth = 300;
        headerHeight = 40;
        rowHeight = 50;
        headHeight = 54;
        fontSize1 = 22;
        fontSize2 = 26;
    }
    //[self creatAnnouncements];

    [self creatTollFareOSData];
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


#pragma mark - Data

- (void)creatTollFareOSData{
    
    highWayArray = [[NSMutableArray alloc] initWithArray:[TblTollFareOSEntry searchTblTollFareOpenSystem]];
    highWayDetailArray = [[NSMutableArray alloc] initWithCapacity:2];
    
  // NSLog(@"highWayArray:%@",highWayArray);
    
    
    tollFareOSArray = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i<highWayArray.count; i++) {
        
        NSString *highWayStr = [[highWayArray objectAtIndex:i] objectForKey:@"idHighway"];
     //   NSLog(@"%@",[TblHighwayEntry searchHighwayByIdHighway:highWayStr]);
        [highWayDetailArray addObject:[TblHighwayEntry searchHighwayByIdHighway:highWayStr]];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[TblTollFareOSEntry searchTblTollFareOpenSystem:highWayStr]];
       // NSLog(@"array;%@",array);
        [tollFareOSArray addObject:array];
    }
    // NSLog(@"tollPlazaDic===%@",tollPlazaDic);
}

#pragma mark -  UI

- (void)creatUI{
    
    [self updateHeadView];
}

- (void)updateHeadView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT - statusBarHeight)];
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width+cellWidth*3, self.view.frame.size.height-TOP_HEADER_HEIGHT - statusBarHeight);
    [self.view addSubview:scrollView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+cellWidth*3, headHeight)];
    view.backgroundColor = [UIColor colorWithRed:.91 green:.91 blue:.91 alpha:1];
    
    for (int i = 0; i<10; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, nameCellWidth, headHeight);
            label.text= @"TOLL PLAZA";
        }else {
            label.text = [NSString stringWithFormat:@"Class%d",i-1];
            label.frame = CGRectMake(nameCellWidth+cellWidth*(i-1), 0, cellWidth, headHeight);
        }
        
        label.font = [UIFont boldSystemFontOfSize:fontSize1];
        label.layer.masksToBounds = YES;    
        label.layer.borderWidth = 0.5;    
        label.layer.borderColor = [[UIColor lightGrayColor] CGColor];  
        
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    [scrollView addSubview:view];
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, headHeight, self.view.frame.size.width+cellWidth*3, self.view.frame.size.height-TOP_HEADER_HEIGHT - statusBarHeight -headHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [scrollView addSubview:table];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return highWayDetailArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[tollFareOSArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i<10; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, nameCellWidth, rowHeight);
            NSString *name = [NSString stringWithFormat:@"   %@",[[[tollFareOSArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"strName"]];
            label.text= name;
            if ([name length] == 0 ) {
                label.backgroundColor = [UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1];
            }else {
                label.backgroundColor = [UIColor whiteColor];
            }
            label.textAlignment = NSTextAlignmentCenter;

        }else {
            
            NSString *str = [NSString stringWithFormat:@"%@",[[[tollFareOSArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"decTollAmt%d",i-1]]];
            
            label.text = str;
            if ([str length] == 0 ) {
                label.backgroundColor = [UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1];
            }else {
                label.backgroundColor = [UIColor whiteColor];
            }
            label.frame = CGRectMake(nameCellWidth+cellWidth*(i-1), 0, cellWidth, rowHeight);
            label.textAlignment = NSTextAlignmentCenter;
        }
    
        label.font = [UIFont systemFontOfSize:fontSize1];
        label.layer.masksToBounds = YES;    
        label.layer.borderWidth = 0.3;    
        label.layer.borderColor = [[UIColor lightGrayColor] CGColor];  
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [cell.contentView addSubview:label];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+cellWidth*3, headerHeight)];
    view.backgroundColor = [UIColor colorWithRed:0.50 green:0.51 blue:0.52 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    label.backgroundColor = [UIColor colorWithRed:0.50 green:0.51 blue:0.52 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:fontSize1];
    label.text = [NSString stringWithFormat:@"%@",[[highWayDetailArray objectAtIndex:section] objectForKey:@"strName"]];
    [view addSubview:label];
    
    return view;
}


@end
