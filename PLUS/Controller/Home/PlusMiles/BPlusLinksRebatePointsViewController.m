//
//  BPlusLinksRebatePointsViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksRebatePointsViewController.h"
#import "Constants.h"
@interface BPlusLinksRebatePointsViewController ()

@end

@implementation BPlusLinksRebatePointsViewController

@synthesize cardNumber = _cardNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    titleLabel.text = @"Rebate Points";
    
    [self createUI];
    
    [self retrieveRebatePoints];
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
    
    UILabel *rebateEmail = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, labelWidth1, labelHeight)];
    [rebateEmail setText:@"Rebate"];
    [rebateEmail setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [rebateEmail setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:rebateEmail];
    
    rebateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth1, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, labelWidth, labelHeight)];
    [rebateValueLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [[self view] addSubview:rebateValueLabel];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, rebateEmail.frame.origin.y + rebateEmail.frame.size.height + padding, labelWidth1, labelHeight)];
    [pointLabel setText:@"Point"];
    [pointLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [pointLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:pointLabel];
    
    pointValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth1, rebateEmail.frame.origin.y + rebateEmail.frame.size.height + padding, labelWidth, labelHeight)];
    [pointValueLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [[self view] addSubview:pointValueLabel];
    
    staffCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, pointLabel.frame.origin.y + pointLabel.frame.size.height + padding, labelWidth1, labelHeight)];
    [staffCardLabel setText:@"Staff Card Subsidy"];
    [staffCardLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [staffCardLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:staffCardLabel];
    
    staffCardValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth1, pointLabel.frame.origin.y + pointLabel.frame.size.height + padding, labelWidth, labelHeight)];
    [staffCardValueLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [[self view] addSubview:staffCardValueLabel];
}

- (void)retrieveRebatePoints {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MemberRewardsBalance *memberRewards  = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.MemberRewards"]];
    
    for (int i = 0; i < [memberRewards.cardRewardsBalances count]; i++) {
        CardRewardsBalance *cardRewards = [memberRewards.cardRewardsBalances objectAtIndex:i];
        
        if ([[self cardNumber] isEqualToString:[cardRewards cardNumber]]) {
            
            [rebateValueLabel setText:cardRewards.rebateBalance];
            [pointValueLabel setText:[NSString stringWithFormat:@"%d", cardRewards.pointsBalance]];
            
            if (!cardRewards.subsidyBalanceSpecified) {
                [staffCardLabel setHidden:TRUE];
                [staffCardValueLabel setHidden:TRUE];
            }
        }
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
