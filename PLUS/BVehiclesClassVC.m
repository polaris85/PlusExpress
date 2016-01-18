

#import "BVehiclesClassVC.h"
#import "Constants.h"
@interface BVehiclesClassVC ()

@end

@implementation BVehiclesClassVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"Vehicle Class";
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
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    int fontSize = 16;
    int labelHeight = 20;
    int cellHeight = 70;
    int paddingLeft = 20;
    int labelWidth = 80;
    if (IS_IPAD) {
        fontSize = 30;
        labelHeight = 40;
        cellHeight = 140;
        paddingLeft = 40;
        labelWidth = 160;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"class%dCarImage.png",indexPath.row+1]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, (cellHeight-image.size.height)/2, image.size.width, image.size.height)];
    //imageView.center = CGPointMake(100, 35);
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width- labelWidth, (cellHeight-labelHeight)/2, labelWidth, labelHeight)];
    label.text = [NSString stringWithFormat:@"Class%d",indexPath.row+1];
    label.textColor  = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    label.font = [UIFont systemFontOfSize:fontSize];
    [cell.contentView addSubview:label];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        return 140;
    }
    return 70;
}


@end
