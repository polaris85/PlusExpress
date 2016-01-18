//
//  BPlusLinksAddNewCardViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksAddNewCardViewController.h"
#import "Constants.h"
@interface BPlusLinksAddNewCardViewController ()

@end

@implementation BPlusLinksAddNewCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    titleLabel.text = @"PLUSMiles - Add New Card";
    
    [self createUI];
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
    [[self view] addSubview:attributedLabel];
    
    NSRange editProfileRange = [attributedLabel.text rangeOfString:@"Edit Profile"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"EditProfile"] withRange:editProfileRange];
    
    NSRange logoutRange = [attributedLabel.text rangeOfString:@"Logout"];
    [attributedLabel addLinkToURL:[NSURL URLWithString:@"Logout"] withRange:logoutRange];
    
    UILabel *serialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, attributedLabel.frame.origin.y + attributedLabel.frame.size.height + padding, self.view.frame.size.width, labelHeight)];
    [serialNumberLabel setText:@"Serial/Mfg Card Number"];
    [serialNumberLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [serialNumberLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:serialNumberLabel];
    
    serialCardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, serialNumberLabel.frame.origin.y + serialNumberLabel.frame.size.height + padding, self.view.frame.size.width - paddingLeft*2, labelHeight)];
    [serialCardNumberTextField setDelegate:self];
    [serialCardNumberTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [serialCardNumberTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:serialCardNumberTextField];
    
    UILabel *confirmSerialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, serialCardNumberTextField.frame.origin.y + serialCardNumberTextField.frame.size.height + padding, self.view.frame.size.width, labelHeight)];
    [confirmSerialNumberLabel setText:@"Confirm Serial/Mfg Card Number"];
    [confirmSerialNumberLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [confirmSerialNumberLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:confirmSerialNumberLabel];
    
    confirmSerialCardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, confirmSerialNumberLabel.frame.origin.y + confirmSerialNumberLabel.frame.size.height + padding, self.view.frame.size.width - paddingLeft*2, labelHeight)];
    [confirmSerialCardNumberTextField setDelegate:self];
    [confirmSerialCardNumberTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [confirmSerialCardNumberTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:confirmSerialCardNumberTextField];
    
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton setFrame:CGRectMake((self.view.frame.size.width-registerButtonWidth)/2, confirmSerialCardNumberTextField.frame.origin.y + confirmSerialCardNumberTextField.frame.size.height + padding, registerButtonWidth, labelHeight)];
    [sendButton setTitle:@"Submit" forState:UIControlStateNormal];
    [[sendButton titleLabel] setFont:[UIFont boldSystemFontOfSize:labelFontSize]];
    [sendButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [sendButton addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:sendButton];
    
}

- (void)doSubmit {
    if ([[serialCardNumberTextField text] length] == 0 || [[confirmSerialCardNumberTextField text] length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Serial/Mfg Card or Confirm Serial/Mfg Card cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else if (![[serialCardNumberTextField text] isEqualToString:[confirmSerialCardNumberTextField text]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Serial/Mfg Card and Confirm Serial/Mfg Card are not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        [self creatHUD];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        proxy = [[PlusMilesServiceProxy alloc] initWithUrl:kURL AndDelegate:self];
        [proxy AddNewCard:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :[serialCardNumberTextField text]];
    }
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    [self hideHud];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView setTag:0];
    [alertView show];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    [self hideHud];
    
    ResultOfstring *result = (ResultOfstring *)data;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:result.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView setTag:(result.responseCode == 0) ? 1 : 0];
    [alertView show];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        [[self navigationController] popViewControllerAnimated:TRUE];
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
