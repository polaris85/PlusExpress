//
//  BPlusLinksRegisterViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksRegisterViewController.h"

@interface BPlusLinksRegisterViewController ()
{
    int labelFontSize;
    int textFontSize;
    
    int labelHeight;
    int textHeight;
    int padding;
    int paddingLeft;
    int paddingTop;
    
    int mainScrollSize;
    int registerButtonWidth;
    int registerButtonHeight;
    int labelWidth1;
}
@end

@implementation BPlusLinksRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleLabel.text = @"PLUSMiles - New Registration";
    
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
    }
    
    [self createUI];
    
    [self retrieveCountries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20.0f, 0.0);
    [mainScrollView setContentInset:contentInsets];
    [mainScrollView setScrollIndicatorInsets:contentInsets];
    
    CGRect rect = self.view.frame;
    rect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScrollView.contentInset = contentInsets;
    mainScrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
}

- (void)createUI {
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight)];
    [mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainScrollSize)];
    [[self view] addSubview:mainScrollView];
    
    UILabel *serialMfgCardNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, self.view.frame.size.width-paddingLeft*2, labelHeight)];
    [serialMfgCardNumberLabel setText:@"Serial/Mfg Card Number"];
    [serialMfgCardNumberLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [serialMfgCardNumberLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:serialMfgCardNumberLabel];
    
    serialMfgCardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, serialMfgCardNumberLabel.frame.origin.y+serialMfgCardNumberLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [serialMfgCardNumberTextField setDelegate:self];
    [serialMfgCardNumberTextField setReturnKeyType:UIReturnKeyNext];
    [serialMfgCardNumberTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [serialMfgCardNumberTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:serialMfgCardNumberTextField];
    
    UILabel *confirmSerialLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, serialMfgCardNumberTextField.frame.origin.y+serialMfgCardNumberTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [confirmSerialLabel setText:@"Confirm Serial/Mfg Card Number"];
    [confirmSerialLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [confirmSerialLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:confirmSerialLabel];
    
    confirmSerialMfgCardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, confirmSerialLabel.frame.origin.y+confirmSerialLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [confirmSerialMfgCardNumberTextField setDelegate:self];
    [confirmSerialMfgCardNumberTextField setReturnKeyType:UIReturnKeyNext];
    [confirmSerialMfgCardNumberTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [confirmSerialMfgCardNumberTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:confirmSerialMfgCardNumberTextField];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, confirmSerialMfgCardNumberTextField.frame.origin.y+confirmSerialMfgCardNumberTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [nameLabel setText:@"Name"];
    [nameLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [nameLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, nameLabel.frame.origin.y+nameLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [nameTextField setDelegate:self];
    [nameTextField setReturnKeyType:UIReturnKeyNext];
    [nameTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [nameTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:nameTextField];
    
    UILabel *nationalityLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, nameTextField.frame.origin.y+nameTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [nationalityLabel setText:@"Nationality"];
    [nationalityLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [nationalityLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:nationalityLabel];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    
    nationalityButton = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(paddingLeft, nationalityLabel.frame.origin.y+nationalityLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [nationalityButton setInputAccessoryView:toolbar];
    [nationalityButton setFont:[UIFont systemFontOfSize:textFontSize]];
    [nationalityButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:nationalityButton];
    
    UILabel *icLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, nationalityButton.frame.origin.y+nationalityButton.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [icLabel setText:@"IC No."];
    [icLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [icLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:icLabel];
    
    ic1NoTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, icLabel.frame.origin.y+icLabel.frame.size.height+padding, (self.view.frame.size.width/4), textHeight)];
    [ic1NoTextField setDelegate:self];
    [ic1NoTextField setReturnKeyType:UIReturnKeyNext];
    [ic1NoTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [ic1NoTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:ic1NoTextField];
    
    UILabel *ic1SeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ic1NoTextField.frame.origin.x + ic1NoTextField.frame.size.width, icLabel.frame.origin.y+icLabel.frame.size.height+padding, 15.0f, textHeight)];
    [ic1SeparatorLabel setText:@"-"];
    [ic1SeparatorLabel setTextAlignment:NSTextAlignmentCenter];
    [ic1SeparatorLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [ic1SeparatorLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:ic1SeparatorLabel];
    
    ic2NoTextField = [[UITextField alloc] initWithFrame:CGRectMake(ic1NoTextField.frame.origin.x + ic1NoTextField.frame.size.width + 15.0f, icLabel.frame.origin.y+icLabel.frame.size.height+padding, (self.view.frame.size.width/4), textHeight)];
    [ic2NoTextField setDelegate:self];
    [ic2NoTextField setReturnKeyType:UIReturnKeyNext];
    [ic2NoTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [ic2NoTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:ic2NoTextField];
    
    UILabel *ic2SeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ic2NoTextField.frame.origin.x + ic2NoTextField.frame.size.width, icLabel.frame.origin.y+icLabel.frame.size.height+padding, 15.0f, textHeight)];
    [ic2SeparatorLabel setText:@"-"];
    [ic1SeparatorLabel setTextAlignment:NSTextAlignmentCenter];
    [ic2SeparatorLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [ic2SeparatorLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:ic2SeparatorLabel];
    
    ic3NoTextField = [[UITextField alloc] initWithFrame:CGRectMake(ic2NoTextField.frame.origin.x + ic2NoTextField.frame.size.width + 15.0f, icLabel.frame.origin.y+icLabel.frame.size.height+padding, (self.view.frame.size.width/4), textHeight)];
    [ic3NoTextField setDelegate:self];
    [ic3NoTextField setReturnKeyType:UIReturnKeyNext];
    [ic3NoTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [ic3NoTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:ic3NoTextField];
    
    UILabel *passportLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, ic3NoTextField.frame.origin.y+ic3NoTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [passportLabel setText:@"Passport No."];
    [passportLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [passportLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:passportLabel];
    
    passportNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, passportLabel.frame.origin.y+passportLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [passportNoTextField setDelegate:self];
    [passportNoTextField setReturnKeyType:UIReturnKeyNext];
    [passportNoTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [passportNoTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:passportNoTextField];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, passportNoTextField.frame.origin.y+passportNoTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [mobileLabel setText:@"Mobile Phone"];
    [mobileLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [mobileLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:mobileLabel];
    
    codeMobilePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, mobileLabel.frame.origin.y+mobileLabel.frame.size.height+padding, labelWidth1, textHeight)];
    [codeMobilePhoneTextField setDelegate:self];
    [codeMobilePhoneTextField setReturnKeyType:UIReturnKeyNext];
    [codeMobilePhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [codeMobilePhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:codeMobilePhoneTextField];
    
    UILabel *separatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(codeMobilePhoneTextField.frame.origin.x+codeMobilePhoneTextField.frame.size.width, mobileLabel.frame.origin.y+mobileLabel.frame.size.height+padding, 10.0f, textHeight)];
    [separatorLabel setText:@"-"];
    [separatorLabel setTextAlignment:NSTextAlignmentCenter];
    [separatorLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [separatorLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:separatorLabel];
    
    mobilePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(separatorLabel.frame.origin.x+separatorLabel.frame.size.width, mobileLabel.frame.origin.y+mobileLabel.frame.size.height+padding, self.view.frame.size.width-separatorLabel.frame.origin.x-separatorLabel.frame.size.width-padding-paddingLeft, textHeight)];
    [mobilePhoneTextField setDelegate:self];
    [mobilePhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [mobilePhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:mobilePhoneTextField];
    
    UILabel *businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, mobilePhoneTextField.frame.origin.y+mobilePhoneTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [businessLabel setText:@"Business Phone"];
    [businessLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [businessLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:businessLabel];
    
    codeBusinessPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, businessLabel.frame.origin.y+businessLabel.frame.size.height+padding, labelWidth1, textHeight)];
    [codeBusinessPhoneTextField setDelegate:self];
    [codeBusinessPhoneTextField setReturnKeyType:UIReturnKeyNext];
    [codeBusinessPhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [codeBusinessPhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:codeBusinessPhoneTextField];
    
    UILabel *businessSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(codeBusinessPhoneTextField.frame.origin.x+codeBusinessPhoneTextField.frame.size.width, businessLabel.frame.origin.y+businessLabel.frame.size.height+padding, 10.0f, textHeight)];
    [businessSeparatorLabel setText:@"-"];
    [businessSeparatorLabel setTextAlignment:NSTextAlignmentCenter];
    [businessSeparatorLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [businessSeparatorLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:businessSeparatorLabel];
    
    businessPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(businessSeparatorLabel.frame.origin.x+businessSeparatorLabel.frame.size.width, businessLabel.frame.origin.y+businessLabel.frame.size.height+padding, self.view.frame.size.width-businessSeparatorLabel.frame.origin.x-businessSeparatorLabel.frame.size.width-padding-paddingLeft, textHeight)];
    [businessPhoneTextField setDelegate:self];
    [businessPhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [businessPhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:businessPhoneTextField];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, businessPhoneTextField.frame.origin.y+businessPhoneTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [emailLabel setText:@"Email Address"];
    [emailLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [emailLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:emailLabel];
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, emailLabel.frame.origin.y+emailLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [emailTextField setDelegate:self];
    [emailTextField setReturnKeyType:UIReturnKeyNext];
    [emailTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [emailTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:emailTextField];
    
    UILabel *notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, emailTextField.frame.origin.y+emailTextField.frame.size.height+padding, ((IS_IPAD)? 200:100), labelHeight)];
    [notifyLabel setText:@"Notify me via:"];
    [notifyLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [notifyLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:notifyLabel];
    
    emailCheckBox = [[M13Checkbox alloc] initWithTitle:@"Email" andHeight:labelHeight];
    [emailCheckBox setFrame:CGRectMake(notifyLabel.frame.origin.x+notifyLabel.frame.size.width+padding, emailTextField.frame.origin.y+emailTextField.frame.size.height+padding+1, ((IS_IPAD)? 140:70), labelHeight)];
    [emailCheckBox setCheckAlignment:M13CheckboxAlignmentLeft];
    [[emailCheckBox titleLabel] setFont:[UIFont systemFontOfSize:labelFontSize]];
    [[emailCheckBox titleLabel] setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:emailCheckBox];
    
    smsCheckBox = [[M13Checkbox alloc] initWithTitle:@"SMS" andHeight:labelHeight];
    [smsCheckBox setFrame:CGRectMake(emailCheckBox.frame.origin.x+emailCheckBox.frame.size.width+padding, emailTextField.frame.origin.y+emailTextField.frame.size.height+padding+1, ((IS_IPAD)? 200:100), labelHeight)];
    [smsCheckBox setCheckAlignment:M13CheckboxAlignmentLeft];
    [[smsCheckBox titleLabel] setFont:[UIFont systemFontOfSize:labelFontSize]];
    [[smsCheckBox titleLabel] setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:smsCheckBox];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, notifyLabel.frame.origin.y+notifyLabel.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [loginLabel setText:@"Login ID"];
    [loginLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [loginLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:loginLabel];
    
    loginIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, loginLabel.frame.origin.y+loginLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [loginIdTextField setDelegate:self];
    [loginIdTextField setReturnKeyType:UIReturnKeyNext];
    [loginIdTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [loginIdTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:loginIdTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, loginIdTextField.frame.origin.y+loginIdTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [passwordLabel setText:@"Password"];
    [passwordLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [passwordLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:passwordLabel];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, passwordLabel.frame.origin.y+passwordLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [passwordTextField setDelegate:self];
    [passwordTextField setReturnKeyType:UIReturnKeyNext];
    [passwordTextField setSecureTextEntry:TRUE];
    [passwordTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [passwordTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:passwordTextField];
    
    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [confirmPasswordLabel setText:@"Confirm Password"];
    [confirmPasswordLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [confirmPasswordLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:confirmPasswordLabel];
    
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, confirmPasswordLabel.frame.origin.y+confirmPasswordLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [confirmPasswordTextField setDelegate:self];
    [confirmPasswordTextField setSecureTextEntry:TRUE];
    [confirmPasswordTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [confirmPasswordTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:confirmPasswordTextField];
    
    termCheckBox = [[M13Checkbox alloc] initWithFrame:CGRectMake(paddingLeft, confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height+padding, labelHeight, labelHeight)];
    [termCheckBox setCheckAlignment:M13CheckboxAlignmentLeft];
    
    UIButton *termLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [termLabelButton setFrame:CGRectMake(termCheckBox.frame.origin.x+termCheckBox.frame.size.width + padding, confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height+padding, self.view.frame.size.width - termCheckBox.frame.origin.x-termCheckBox.frame.size.width - padding, labelHeight)];
    [termLabelButton setBackgroundColor:[UIColor clearColor]];
    [termLabelButton setTitle:@"I have read and agree to the Terms & Conditions" forState:UIControlStateNormal];
    [termLabelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [termLabelButton setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:167.0f/255.0f blue:90.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[termLabelButton titleLabel] setFont:[UIFont systemFontOfSize:labelFontSize]];
    [termLabelButton addTarget:self action:@selector(goToTermCondition) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:termLabelButton];
    
    UIButton *policyLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [policyLabelButton setFrame:CGRectMake(termCheckBox.frame.origin.x+termCheckBox.frame.size.width + padding, termLabelButton.frame.origin.y+termLabelButton.frame.size.height+padding, self.view.frame.size.width - termCheckBox.frame.origin.x-termCheckBox.frame.size.width - padding, labelHeight)];
    [policyLabelButton setBackgroundColor:[UIColor clearColor]];
    [policyLabelButton setTitle:@"And Privacy Policy" forState:UIControlStateNormal];
    [policyLabelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [policyLabelButton setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:167.0f/255.0f blue:90.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[policyLabelButton titleLabel] setFont:[UIFont systemFontOfSize:labelFontSize]];
    [policyLabelButton addTarget:self action:@selector(goToPolicy) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:policyLabelButton];
    
    [mainScrollView addSubview:termCheckBox];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake((self.view.frame.size.width-registerButtonWidth)/2, policyLabelButton.frame.origin.y+policyLabelButton.frame.size.height+padding, registerButtonWidth, registerButtonHeight)];
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [[registerButton titleLabel] setFont:[UIFont boldSystemFontOfSize:textFontSize]];
    [registerButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:registerButton];
}

- (void)retrieveCountries {
    
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy GetCountryCodes:kAccessCode :kAccessPassword];
}

#pragma mark EventHandler
- (void)doRegister {
    
    if ([[serialMfgCardNumberTextField text] length] != 0 && [[confirmSerialMfgCardNumberTextField text] length ] != 0 && ![serialMfgCardNumberTextField.text isEqualToString:confirmSerialMfgCardNumberTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Card Number mismatch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([[passportNoTextField text] length] == 0 && ([[ic1NoTextField text] length] == 0 || [[ic2NoTextField text] length] == 0 || [[ic3NoTextField text] length] == 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Ic No is in wrong format. It should be XXXXXX-XX-XXXX" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    
    NSString *selectedId = @"";
    for (int i = 0; i < [countriesArray count]; i++) {
        Code *code = [countriesArray objectAtIndex:i];
        
        if ([code.name isEqualToString:[nationalityButton text]]) {
            selectedId = code.iId;
        }
    }
    [proxy NewMemberRegister:kAccessCode :kAccessPassword :[serialMfgCardNumberTextField text] :[passwordTextField text] :[confirmPasswordTextField text] :[nameTextField text] :[NSString stringWithFormat:@"%@-%@-%@", ic1NoTextField.text, ic2NoTextField.text, ic3NoTextField.text] :[passportNoTextField text] :selectedId :[emailTextField text] :[NSString stringWithFormat:@"%@-%@", codeMobilePhoneTextField.text, mobilePhoneTextField.text]  :[NSString stringWithFormat:@"%@-%@", codeBusinessPhoneTextField.text, businessPhoneTextField.text] :smsCheckBox.checkState :smsCheckBox.checkState :emailCheckBox.checkState :emailCheckBox.checkState];
    /*
    [proxy NewMemberRegister:kAccessCode :kAccessPassword :[serialMfgCardNumberTextField text] :[passwordTextField text] :[confirmPasswordTextField text] :[nameTextField text] :[NSString stringWithFormat:@"%@-%@-%@", ic1NoTextField.text, ic2NoTextField.text, ic3NoTextField.text] :[passportNoTextField text] :selectedId :[emailTextField text] :[NSString stringWithFormat:@"%@-%@", codeMobilePhoneTextField.text, mobilePhoneTextField.text] :[NSString stringWithFormat:@"%@-%@", codeBusinessPhoneTextField.text, businessPhoneTextField.text], smsCheckBox.checkState, smsCheckBox.checkState, emailCheckBox.checkState, emailCheckBox.checkState];
    */
}

- (void)goToTermCondition {
    BPlusLinksTermConditionViewController *termConditionVC = [[BPlusLinksTermConditionViewController alloc] init];
    [[self navigationController] pushViewController:termConditionVC animated:TRUE];
}

- (void)goToPolicy {
    BPlusLinksPrivacyPolicyViewController *privacyVC = [[BPlusLinksPrivacyPolicyViewController alloc] init];
    [[self navigationController] pushViewController:privacyVC animated:TRUE];
}

- (void)doneClicked:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    if ([method isEqualToString:@"NewMemberRegister"]) {
        ResultOfstring *resultString = (ResultOfstring *)data;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:resultString.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        ResultOfArrayOfCodeo_PHb66yK *result = (ResultOfArrayOfCodeo_PHb66yK *)data;
        countriesArray = [[NSMutableArray alloc] initWithArray:result.data];
        NSMutableArray *codeArray = [NSMutableArray array];
        
        for (int i = 0; i < [result.data count]; i++) {
            Code *code = [result.data objectAtIndex:i];
            
            if ([code.name isEqualToString:@"Malaysia"]) {
                [nationalityButton setText:code.name];
            }
            [codeArray addObject:code.name];
        }
        
        if ([codeArray count] > 0 && [[nationalityButton text] length] == 0) {
            [nationalityButton setText:[codeArray objectAtIndex:0]];
        }
        
        [nationalityButton setItemList:[NSArray arrayWithArray:codeArray]];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == loginIdTextField) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == ic1NoTextField) {
        return (newLength > 6) ? NO : YES;
    } else if (textField == ic2NoTextField) {
        return (newLength > 2) ? NO : YES;
    } else if (textField == ic3NoTextField) {
        return (newLength > 4) ? NO : YES;
    } else if (textField == codeMobilePhoneTextField || textField == codeBusinessPhoneTextField) {
        return (newLength > 3) ? NO : YES;
    } else if (textField == mobilePhoneTextField || textField == businessPhoneTextField) {
        return (newLength > 8) ? NO : YES;
    } else if (textField == emailTextField) {
        [loginIdTextField setText:[NSString stringWithFormat:@"%@%@", emailTextField.text, string]];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSMutableArray *positionArray = [NSMutableArray array];
    int i = 0;
    for (UIView *view in mainScrollView.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            [positionArray addObject:[NSNumber numberWithInt:i]];
        }
        i++;
    }
    
    int x = -1;
    for (int i = 0; i < [positionArray count]; i++) {
        int xx = [[positionArray objectAtIndex:i] integerValue];
        UITextField *view = [mainScrollView.subviews objectAtIndex:xx];
        if (x != -1) {
            [view becomeFirstResponder];
            break;
        }
        
        if ([textField isEqual:view]) {
            x = i;
        }
    }
    
    if (x == [positionArray count] - 1) {
        [textField resignFirstResponder];
    }
    
    [loginIdTextField setText:[emailTextField text]];
    
    return YES;
}

@end
