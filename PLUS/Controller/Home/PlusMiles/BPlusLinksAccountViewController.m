//
//  BPlusLinksAccountViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksAccountViewController.h"
#import "Constants.h"
@interface BPlusLinksAccountViewController ()
{
    int fontSize;
    int labelWidth;
    int labelHeight;
    int padding;
    int paddingTop;
    int paddingLeft;
    int labelWidth1;
    int buttonWidth;
    int tabHeight;
}
@end

@implementation BPlusLinksAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titleLabel.text = @"PLUSMiles - My Account";
    
    fontSize = 13;
    labelHeight = 20;
    labelWidth = 200;
    paddingTop = 5;
    padding = 20;
    paddingLeft = 25;
    labelWidth1 = 125;
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
    [self createUI];
    
    [self retrieveProfile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[communityInterestView retrieveCommunityInterest];
}

- (void)createUI {
    
    UIImage *selectedLoginImage = [UIImage imageNamed:@"Selected-MyLogin.png"];
    accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountButton setFrame:CGRectMake(0.0f, 0.0f, selectedLoginImage.size.width, tabHeight)];
    [accountButton setBackgroundImage:selectedLoginImage forState:UIControlStateNormal];
    [accountButton setBackgroundImage:selectedLoginImage forState:UIControlStateHighlighted];
    [accountButton setBackgroundImage:selectedLoginImage forState:UIControlStateSelected];
    [accountButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchDown];
    
    UIImage *unselectedMerchantImage = [UIImage imageNamed:@"Unselected-Merchant.png"];
    merchantButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [merchantButton setFrame:CGRectMake(accountButton.frame.size.width, 0.0f, unselectedMerchantImage.size.width, tabHeight)];
    [merchantButton setBackgroundImage:unselectedMerchantImage forState:UIControlStateNormal];
    [merchantButton setBackgroundImage:unselectedMerchantImage forState:UIControlStateHighlighted];
    [merchantButton setBackgroundImage:unselectedMerchantImage forState:UIControlStateSelected];
    [merchantButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchDown];
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, tabHeight)];
    [grayView setBackgroundColor:[UIColor colorWithRed:185.0f/255.0f green:186.0f/255.0f blue:183.0f/255.0f alpha:1.0f]];
    //[grayView addSubview:communityInterestButton];
    [grayView addSubview:merchantButton];
    [grayView addSubview:accountButton];
    [[self view] addSubview:grayView];
    
    accountView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, grayView.frame.origin.y + grayView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - grayView.frame.origin.y - grayView.frame.size.height)];
    
    merchantView = [[BMerchantView alloc] initWithFrame:CGRectMake(0.0f, grayView.frame.origin.y + grayView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (grayView.frame.origin.y + grayView.frame.size.height))];
    [merchantView setHidden:TRUE];
    
    /*
    communityInterestView = [[BCommunityInterestView alloc] initWithFrame:CGRectMake(0.0f, grayView.frame.origin.y + grayView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (grayView.frame.origin.y + grayView.frame.size.height))];
    [communityInterestView setDelegate:self];
    [communityInterestView setHidden:TRUE];
    */
    
    attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-labelWidth-paddingLeft, paddingTop, labelWidth, labelHeight)];
    [attributedLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [attributedLabel setText:NSLocalizedString(@"[ Edit Profile | Logout ]", nil)];
    [attributedLabel setDelegate:self];
    attributedLabel.textAlignment = NSTextAlignmentRight;
    [accountView addSubview:attributedLabel];
    
    NSRange editProfileRange = [attributedLabel.text rangeOfString:@"Edit Profile"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"EditProfile"] withRange:editProfileRange];
    
    NSRange logoutRange = [attributedLabel.text rangeOfString:@"Logout"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"Logout"] withRange:logoutRange];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, labelWidth1, labelHeight)];
    [emailLabel setText:@"Email Address"];
    [emailLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [emailLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [accountView addSubview:emailLabel];
    
    emailValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth1, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, self.view.frame.size.width-labelWidth1, labelHeight)];
    [emailValueLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [accountView addSubview:emailValueLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, emailLabel.frame.origin.y + emailLabel.frame.size.height + padding, labelWidth1, labelHeight)];
    [nameLabel setText:@"Name"];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [nameLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [accountView addSubview:nameLabel];
    
    nameValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth1, emailLabel.frame.origin.y + emailLabel.frame.size.height + padding, self.view.frame.size.width-labelWidth1, labelHeight)];
    [nameValueLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [accountView addSubview:nameValueLabel];
    
    UILabel *serialLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, nameLabel.frame.origin.y + nameLabel.frame.size.height + padding, self.view.frame.size.width, labelHeight)];
    [serialLabel setText:@"Serial / Mfg"];
    [serialLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [serialLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [accountView addSubview:serialLabel];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    
    serialValueTextField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(labelWidth1, nameLabel.frame.origin.y + nameLabel.frame.size.height + padding, self.view.frame.size.width-labelWidth1-paddingLeft, labelHeight)];
    [serialValueTextField setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [serialValueTextField setInputAccessoryView:toolbar];
    [accountView addSubview:serialValueTextField];
    
    UIButton *rebateButton = [[UIButton alloc] init];
    [rebateButton setFrame:CGRectMake(paddingLeft, serialLabel.frame.origin.y + serialLabel.frame.size.height + padding, buttonWidth, labelHeight)];
    [rebateButton setTitle:@"Rebate Points" forState:UIControlStateNormal];
    [rebateButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[rebateButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [rebateButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [rebateButton addTarget:self action:@selector(doRebate) forControlEvents:UIControlEventTouchDown];
    [accountView addSubview:rebateButton];
    
    UIButton *redemptionButton = [[UIButton alloc] init];
    [redemptionButton setFrame:CGRectMake(self.view.frame.size.width-paddingLeft-buttonWidth, serialLabel.frame.origin.y + serialLabel.frame.size.height + padding, buttonWidth, labelHeight)];
    [redemptionButton setTitle:@"Redemption History" forState:UIControlStateNormal];
    [redemptionButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[redemptionButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [redemptionButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [redemptionButton addTarget:self action:@selector(doRedemption) forControlEvents:UIControlEventTouchDown];
    [accountView addSubview:redemptionButton];
    
    UIButton *addNewCardButton = [[UIButton alloc] init];
    [addNewCardButton setFrame:CGRectMake(paddingLeft, rebateButton.frame.origin.y + rebateButton.frame.size.height + padding, buttonWidth, labelHeight)];
    [addNewCardButton setTitle:@"Add New Card" forState:UIControlStateNormal];
    [addNewCardButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[addNewCardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [addNewCardButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [addNewCardButton addTarget:self action:@selector(doAddNewCard) forControlEvents:UIControlEventTouchDown];
    [accountView addSubview:addNewCardButton];
    
    UIButton *rewardHistoryButton = [[UIButton alloc] init];
    [rewardHistoryButton setFrame:CGRectMake(self.view.frame.size.width-paddingLeft-buttonWidth, rebateButton.frame.origin.y + rebateButton.frame.size.height + padding, buttonWidth, labelHeight)];
    [rewardHistoryButton setTitle:@"Reward History" forState:UIControlStateNormal];
    [rewardHistoryButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[rewardHistoryButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [rewardHistoryButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [rewardHistoryButton addTarget:self action:@selector(doRewardHistory) forControlEvents:UIControlEventTouchDown];
    [accountView addSubview:rewardHistoryButton];
    
    [[self view] addSubview:accountView];
    [[self view] addSubview:merchantView];
    //[[self view] addSubview:communityInterestView];
}

- (void)retrieveProfile {
    [self creatHUD];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy GetMemberProfile:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :@"" :@"" :@""];
}

- (void)retrieveRebatePoints {
    [self creatHUD];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    
    [proxy GetRewardsBalance:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :@"" :@"" :@""];
}
/*
- (void)showCommunityInterestReply:(NSDictionary *)communityInterestDictionary {
    BPlusLinksCommunityInterestViewController *communityInterestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"communityinterestViewController"];
    [self.navigationController pushViewController:communityInterestVC animated:YES];
    [communityInterestVC setCommunityInterestDictionary:communityInterestDictionary];
}

- (void)showAddCommunityInterest:(NSString *)idInterestCatg {
    BPlusLinksCommunityInterestAddViewController *communityInterestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"communityinterestaddViewController"];
    [communityInterestVC setIdInterestCatg:idInterestCatg];
    [self.navigationController pushViewController:communityInterestVC animated:YES];
}
*/

- (void)doRebate {
    BPlusLinksRebatePointsViewController *rebateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rebatepointsViewController"];
    [rebateVC setCardNumber:serialValueTextField.text];
    [self.navigationController pushViewController:rebateVC animated:YES];
}

- (void)doRedemption {
    BPlusLinksRedemptionViewController *redemptionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"redemptionViewController"];
    [redemptionVC setCardNumber:serialValueTextField.text];
    [self.navigationController pushViewController:redemptionVC animated:YES];
}

- (void)doAddNewCard {
    BPlusLinksAddNewCardViewController *addNewCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addnewcardViewController"];
    [self.navigationController pushViewController:addNewCardVC animated:YES];
}

- (void)doRewardHistory {
    BPlusLinksRewardHistoryViewController *rewardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardhistoryViewController"];
    [rewardVC setCardNumber:serialValueTextField.text];
    [self.navigationController pushViewController:rewardVC animated:YES];
}

- (void)changeScreen:(UIButton *)button {
    [accountView setHidden:TRUE];
    [merchantView setHidden:TRUE];
    //[communityInterestView setHidden:TRUE];
    
    UIImage *unselectedMyLoginImage = [UIImage imageNamed:@"Unselected-MyLogin.png"];
    [accountButton setImage:unselectedMyLoginImage forState:UIControlStateNormal];
    UIImage *unselectedMerchantImage = [UIImage imageNamed:@"Unselected-Merchant.png"];
    [merchantButton setImage:unselectedMerchantImage forState:UIControlStateNormal];

    //UIImage *unselectedCommunityInterestImage = [UIImage imageNamed:@"Unselected-Community Interest.png"];
    //[communityInterestButton setImage:unselectedCommunityInterestImage forState:UIControlStateNormal];
    
    if (button == accountButton) {
        UIImage *selectedMyLoginImage = [UIImage imageNamed:@"Selected-MyLogin.png"];
        [accountButton setImage:selectedMyLoginImage forState:UIControlStateNormal];
        [accountButton bringSubviewToFront:merchantButton];
        [grayView bringSubviewToFront:accountButton];
        
        [accountView setHidden:NO];
    } else if (button == merchantButton) {
        UIImage *selectedMerchantImage = [UIImage imageNamed:@"Selected-Merchant.png"];
        [merchantButton setImage:selectedMerchantImage forState:UIControlStateNormal];
        [grayView bringSubviewToFront:merchantButton];
        
        [merchantView setHidden:NO];
        [merchantView retrievePromotion];
    }
    /*
     else {
        UIImage *selectedCommunityInterestImage = [UIImage imageNamed:@"Selected-Community Interest.png"];
        [communityInterestButton setImage:selectedCommunityInterestImage forState:UIControlStateNormal];
        [grayView bringSubviewToFront:communityInterestButton];
        
        [communityInterestView setHidden:NO];
    }
     */
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    [self hideHud];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    [self hideHud];
    
    if ([method isEqualToString:@"GetMemberProfile"]) {
        ResultOfMemberProfileo_PHb66yK *result = (ResultOfMemberProfileo_PHb66yK *)data;
        
        if (result.responseCode == 0) {
            MemberProfile *memberProfile = (MemberProfile *)result.data;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [emailValueLabel setText:[defaults objectForKey:@"Plus.LoginId"]];
            [nameValueLabel setText:memberProfile.name];
            [nameValueLabel sizeToFit];
            
            NSData *memberProfileData = [NSKeyedArchiver archivedDataWithRootObject:memberProfile];
            [defaults setObject:memberProfileData forKey:@"Plus.MemberProfile"];
            [defaults synchronize];
            
            [self retrieveRebatePoints];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:result.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        ResultOfMemberRewardsBalanceo_PHb66yK *result = (ResultOfMemberRewardsBalanceo_PHb66yK *)data;
        
        if (result.responseCode == 0) {
            MemberRewardsBalance *memberRewards = (MemberRewardsBalance *)result.data;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *memberRewardsData = [NSKeyedArchiver archivedDataWithRootObject:memberRewards];
            [defaults setObject:memberRewardsData forKey:@"Plus.MemberRewards"];
            [defaults synchronize];
            
            NSMutableArray *cardNumberArray = [NSMutableArray array];
            for (int i = 0; i < [memberRewards.cardRewardsBalances count]; i++) {
                CardRewardsBalance *cardRewards = [memberRewards.cardRewardsBalances objectAtIndex:i];
                [cardNumberArray addObject:cardRewards.cardNumber];
                
                if (i == 0) {
                    [serialValueTextField setText:cardRewards.cardNumber];
                }
            }
            
            [serialValueTextField setItemList:[NSArray arrayWithArray:cardNumberArray]];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:result.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
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

#pragma mark Event Handler Delegate
- (void)doneClicked:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

@end
