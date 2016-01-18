//
//  BPlusLinksRedemptionViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksRedemptionViewController.h"
#import "Constants.h"
@interface BPlusLinksRedemptionViewController ()

@end

@implementation BPlusLinksRedemptionViewController

@synthesize cardNumber = _cardNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titleLabel.text = @"Redemption History";
    
    [self createUI];
    
    [self retrieveRedemptionHistory];
}

- (void)createUI {
    
    int fontSize;
    int labelWidth;
    int labelHeight;
    int padding;
    int paddingTop;
    int paddingLeft;
    int labelWidth1;
    int buttonWidth;
    int tabHeight;
    fontSize = 13;
    labelHeight = 20;
    labelWidth = 200;
    paddingTop = 5;
    padding = 20;
    paddingLeft = 25;
    labelWidth1 = 150;
    buttonWidth=130;
    tabHeight = 35;
    if (IS_IPAD) {
        fontSize = 26;
        labelWidth = 300;
        labelHeight = 40;
        padding = 40;
        paddingLeft = 50;
        paddingTop = 10;
        labelWidth1 = 250;
        buttonWidth = 300;
        tabHeight = 35;
    }
    
    attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-labelWidth-paddingLeft, TOP_HEADER_HEIGHT+statusBarHeight+paddingTop, labelWidth, labelHeight)];
    [attributedLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [attributedLabel setText:NSLocalizedString(@"[ Edit Profile | Logout ]", nil)];
    [attributedLabel setDelegate:self];
    attributedLabel.textAlignment = NSTextAlignmentRight;
    [[self view] addSubview:attributedLabel];
    
    NSRange editProfileRange = [attributedLabel.text rangeOfString:@"Edit Profile"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"EditProfile"] withRange:editProfileRange];
    
    NSRange logoutRange = [attributedLabel.text rangeOfString:@"Logout"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"Logout"] withRange:logoutRange];
    
    hiddenTableView = FALSE;
    redemptionArray = [[NSArray alloc] init];
    redemptionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, self.view.frame.size.width, self.view.frame.size.height - (attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding)) style:UITableViewStylePlain];
    [redemptionTableView setDelegate:self];
    [redemptionTableView setDataSource:self];
    [[self view] addSubview:redemptionTableView];
}

- (void)retrieveRedemptionHistory {
    [self creatHUD];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proxy = [[PlusMilesServiceProxy alloc] initWithUrl:kURL AndDelegate:self];
    [proxy Get3MonthsRedemptions:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :@"" :@"" :@"" :[self cardNumber]];
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    [self hideHud];
    
    hiddenTableView = TRUE;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [redemptionTableView reloadData];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    [self hideHud];
    
    ResultOfMemberMonthsRedemptionso_PHb66yK *result = (ResultOfMemberMonthsRedemptionso_PHb66yK *)data;
    hiddenTableView = TRUE;
    
    if (result.responseCode == 0) {
        MemberMonthsRedemptions *memberRedemptions = (MemberMonthsRedemptions *)result.data;
        
        redemptionArray = [[NSArray alloc] initWithArray:memberRedemptions.cardMonthsRedemptions];
    }
    
    [redemptionTableView reloadData];
}

#pragma mark UITableViewDelegate + UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [redemptionArray count] == 0 ? 1 : [redemptionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RedemptionCell";
    static NSString *emptyIdentifier = @"EmptyCell";
    
    if ([redemptionArray count] > 0) {
        BRedemptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BRedemptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cell setRedemptionInfo:[redemptionArray objectAtIndex:indexPath.row]];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, redemptionTableView.frame.size.width, redemptionTableView.frame.size.height)];
        [label setText:@"Items not available"];
        [label setHidden:!hiddenTableView];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [[cell contentView] addSubview:label];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([redemptionArray count] > 0) {
        CardMonthsRedemption *cardMonths = (CardMonthsRedemption *)[redemptionArray objectAtIndex:indexPath.row];
        
        UILabel *dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 5.0f, 175.0f, 15.0f)];
        [dateValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [dateValueLabel setNumberOfLines:0];
        [dateValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        double dateHeight = [self heightOfString:cardMonths.redemptionDate withLabel:dateValueLabel];
        [dateValueLabel setFrame:CGRectMake(dateValueLabel.frame.origin.x, dateValueLabel.frame.origin.y, dateValueLabel.frame.size.width, dateHeight)];
        [dateValueLabel setText:cardMonths.redemptionDate];
        
        UILabel *productValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 25.0f, 175.0f, 15.0f)];
        [productValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [productValueLabel setNumberOfLines:0];
        [productValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        double productHeight = [self heightOfString:cardMonths.redemptionProduct withLabel:productValueLabel];
        [productValueLabel setFrame:CGRectMake(productValueLabel.frame.origin.x, dateValueLabel.frame.origin.y + dateValueLabel.frame.size.height + 5.0f, productValueLabel.frame.size.width, productHeight)];
        
        double height = 0;
        if (![cardMonths.redemptionType isEqualToString:@"S"]) {
            UILabel *rebateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 45.0f, 175.0f, 15.0f)];
            [rebateValueLabel setFrame:CGRectMake(rebateValueLabel.frame.origin.x, productValueLabel.frame.origin.y + productValueLabel.frame.size.height + 5.0f, rebateValueLabel.frame.size.width, rebateValueLabel.frame.size.height)];
            height = rebateValueLabel.frame.origin.y + rebateValueLabel.frame.size.height + 5.0f;
        } else {
            height = productValueLabel.frame.origin.y + productValueLabel.frame.size.height + 5.0f;
        }
        
        UILabel *pointValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 65.0f, 175.0f, 15.0f)];
        [pointValueLabel setFrame:CGRectMake(pointValueLabel.frame.origin.x, height, pointValueLabel.frame.size.width, pointValueLabel.frame.size.height)];
        height = pointValueLabel.frame.origin.y + pointValueLabel.frame.size.height + 5.0f;
        
        if ([cardMonths.redemptionType isEqualToString:@"S"]) {
            UILabel *staffSubsidyValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 85.0f, 175.0f, 15.0f)];
            [staffSubsidyValueLabel setFrame:CGRectMake(staffSubsidyValueLabel.frame.origin.x, pointValueLabel.frame.origin.y + pointValueLabel.frame.size.height + 5.0f, staffSubsidyValueLabel.frame.size.width, staffSubsidyValueLabel.frame.size.height)];
            height = staffSubsidyValueLabel.frame.origin.y + staffSubsidyValueLabel.frame.size.height + 5.0f;
        }
        
        return height;
    } else {
        return redemptionTableView.frame.size.height;
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
