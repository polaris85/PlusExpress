//
//  BPlusLinksRewardHistoryViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksRewardHistoryViewController.h"
#import "Constants.h"
@interface BPlusLinksRewardHistoryViewController ()

@end

@implementation BPlusLinksRewardHistoryViewController
@synthesize cardNumber = _cardNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titleLabel.text = @"PLUSMiles - Reward History";
    
    [self createUI];
    
    [self retrieveRedemptionHistory];
}

- (void)createUI {
    
    int labelFontSize;
    int textFontSize;
    int labelWidth;
    int labelHeight;
    int textHeight;
    int padding;
    int paddingLeft;
    int paddingTop;
    
    int mainScrollSize;
    int registerButtonWidth;
    int registerButtonHeight;
    int labelWidth1;
    
    labelFontSize = 13;
    textFontSize = 14;
    labelHeight = 18;
    textHeight = 16;
    padding = 5;
    paddingLeft = 25;
    paddingTop = 20;
    mainScrollSize = 630;
    registerButtonHeight = 20;
    registerButtonWidth = 100;
    labelWidth1 = 50;
    labelWidth = 200;
    if (IS_IPAD) {
        labelFontSize = 22;
        textFontSize = 24;
        labelHeight = 36;
        textHeight = 32;
        padding = 10;
        paddingLeft = 50;
        paddingTop = 40;
        mainScrollSize = 1300;
        registerButtonWidth = 200;
        registerButtonHeight = 40;
        labelWidth1 = 150;
        labelWidth = 300;
    }
    
    attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-labelWidth-paddingLeft, TOP_HEADER_HEIGHT+statusBarHeight+padding, labelWidth, labelHeight)];
    [attributedLabel setFont:[UIFont boldSystemFontOfSize:labelFontSize]];
    [attributedLabel setText:NSLocalizedString(@"[ Edit Profile | Logout ]", nil)];
    [attributedLabel setDelegate:self];
    attributedLabel.textAlignment = NSTextAlignmentRight;
    //attributedLabel.backgroundColor = [UIColor grayColor];
    [[self view] addSubview:attributedLabel];
    
    NSRange editProfileRange = [attributedLabel.text rangeOfString:@"Edit Profile"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"EditProfile"] withRange:editProfileRange];
    
    NSRange logoutRange = [attributedLabel.text rangeOfString:@"Logout"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"Logout"] withRange:logoutRange];
    
    hiddenTableView = FALSE;
    rewardArray = [[NSArray alloc] init];
    rewardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, self.view.frame.size.width, self.view.frame.size.height - (attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding)) style:UITableViewStylePlain];
    [rewardTableView setDelegate:self];
    [rewardTableView setDataSource:self];
    [[self view] addSubview:rewardTableView];
}

- (void)retrieveRedemptionHistory {
    [self creatHUD];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proxy = [[PlusMilesServiceProxy alloc] initWithUrl:kURL AndDelegate:self];
    [proxy Get3MonthsRewards:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :@"" :@"" :@"" :[self cardNumber]];
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    [self hideHud];
    
    hiddenTableView = TRUE;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [rewardTableView reloadData];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    [self hideHud];
    
    ResultOfMemberMonthsRewardso_PHb66yK *result = (ResultOfMemberMonthsRewardso_PHb66yK *)data;
    hiddenTableView = TRUE;
    
    if (result.responseCode == 0) {
        MemberMonthsRewards *memberMonthsRewards = (MemberMonthsRewards *)result.data;
        
        rewardArray = [[NSArray alloc] initWithArray:memberMonthsRewards.cardMonthsRewardsBalances];
    }
    
    [rewardTableView reloadData];
}

#pragma mark UITableViewDelegate + UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rewardArray count] == 0 ? 1 : [rewardArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RewardCell";
    static NSString *emptyIdentifier = @"EmptyCell";
    
    if ([rewardArray count] > 0) {
        BRewardCell *cell = (BRewardCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setRewardInfo:[rewardArray objectAtIndex:indexPath.row]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rewardTableView.frame.size.width, rewardTableView.frame.size.height)];
        [label setText:@"Items not available"];
        [label setHidden:!hiddenTableView];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [[cell contentView] addSubview:label];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([rewardArray count] > 0) {
        static NSString *identifier = @"RewardCell";
        
        BRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setRewardInfo:[rewardArray objectAtIndex:indexPath.row]];
        return cell.totalHeight;
    } else {
        return rewardTableView.frame.size.height;
    }
}

#pragma mark TTTAtributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url absoluteString] isEqualToString:@"EditProfile"]) {
        BPlusLinksEditProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editprofileViewController"];
        [self.navigationController pushViewController:profileVC animated:YES];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:@"Plus.isKeepLogin"]) {
            NSArray *fieldArray = [NSArray arrayWithObjects:@"Plus.LoginId", @"Plus.Password", @"Plus.ICNo", @"Plus.CardNumber", @"Plus.MobilePhone", @"Plus.PassportNo", @"Plus.MemberRewards", nil];
            for (NSString *fieldString in fieldArray) {
                [defaults removeObjectForKey:fieldString];
            }
            [defaults synchronize];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
