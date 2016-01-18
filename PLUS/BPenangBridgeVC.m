
#import "BPenangBridgeVC.h"
#import "BVehiclesClassVC.h"
#import "BTollFareOSVC.h"
#import "Constants.h"

@interface BPenangBridgeVC ()

@end

@implementation BPenangBridgeVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Penang Bridge and Others";
    //[self creatAnnouncements];

    array = [[NSArray alloc ] initWithObjects:@"Vehicle Class",@"Toll Fare - Open System", nil];
    
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
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, 320, self.view.frame.size.height-TOP_HEADER_HEIGHT - statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];

    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            BVehiclesClassVC *vehiclesClass = [[BVehiclesClassVC alloc] init];
            [self.navigationController pushViewController:vehiclesClass animated:YES];
        }
            break;
        case 1:
        {
            BTollFareOSVC *tollFareOS = [self.storyboard instantiateViewControllerWithIdentifier:@"tollfareosViewController"];
            [self.navigationController pushViewController:tollFareOS animated:YES];
        }
            break;  
        default:
            break;
    }
}


@end
