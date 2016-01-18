

#import "BMoreViewController.h"
#import "BSettingViewController.h"
#import "BAgreementViewController.h"
#import "BSettingViewController.h"
#import "BAgreementViewController.h"
#import "BFunctionViewController.h"
#import "BUserGuideViewController.h"
#import "Constants.h"

@implementation BMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = @"More";
    [self creatUI];
    
    //[self creatAnnouncements];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UI

- (void)creatUI {
    [backButton setHidden:YES];
    
    float buttonSize = 16.0;
    if (IS_IPAD) {
        buttonSize = 32.0;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonSize, buttonSize)];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(presentLeftMenuViewController:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //[button setTitle:@"Menu" forState:UIControlStateNormal];
    [navigationBar setLeftButton:button];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.bounds.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    //[_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setScrollEnabled:YES];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
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
    
    int fontSize = 18;
    int imageSize = 32;
    if (IS_IPAD) {
        fontSize = 30;
        imageSize = 64;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    int row = [indexPath row];
    
    if (row == 0) {
        [cell.textLabel setText:@"About"];
        [[cell imageView] setImage:[UIImage imageNamed:((IS_IPAD) ? @"MoreAbout_ipad.png":@"MoreAbout.png")]];
    }
    if (row == 1) {
        [cell.textLabel setText:@"PLUS Link"];
        [[cell imageView] setImage:[UIImage imageNamed:((IS_IPAD) ? @"PLUS_ipad.png":@"PLUS.png")]];
    }
    if (row == 2) {
        [cell.textLabel setText:@"Settings"];
        [[cell imageView] setImage:[UIImage imageNamed:((IS_IPAD) ? @"MoreSetting_ipad.png":@"MoreSetting.png")]];
    }
    if (row == 3) {
        [cell.textLabel setText:@"Term & Conditions"];
        [[cell imageView] setImage:[UIImage imageNamed:((IS_IPAD) ? @"MoreT&Cs_ipad.png":@"MoreT&Cs.png")]];
    }
    if (row == 4) {
        [cell.textLabel setText:@"User Guide"];
        [[cell imageView] setImage:[UIImage imageNamed:((IS_IPAD) ? @"MoreUserGuide_ipad.png":@"MoreUserGuide.png")]];
    }
    
    
    [[cell imageView] setFrame:CGRectMake(0, 0, imageSize, imageSize)];
    
    //cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = [indexPath row];
    if (row == 0) {
        //BFunctionViewController *aboutVC =
        //[aboutVC.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"functionViewController"] animated:YES];
        
    }
    if (row == 1) {
        //BFunctionViewController *aboutVC =
        //[aboutVC.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"pluslinksViewController"] animated:YES];
        
    }
    if (row == 2) {
        BSettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
        [settingVC setSettingMode:YES];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    if (row == 3) {
        BAgreementViewController  *agreeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"agreementViewController"];
        [agreeVC setSettingMode:YES];
        [self.navigationController pushViewController:agreeVC animated:YES];
        
    }
    if (row == 4) {
        BUserGuideViewController *userGuideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userguideViewController"];
        [userGuideVC setHidesBottomBarWhenPushed:TRUE];
        [self.navigationController pushViewController:userGuideVC animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return 130;
    }
    return 65;
}


@end
