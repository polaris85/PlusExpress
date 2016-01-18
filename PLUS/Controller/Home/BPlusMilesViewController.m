//
//  BPlusMilesViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusMilesViewController.h"
#import "BPlusLinksInformationViewController.h"
#import "BPlusLinksRegisterViewController.h"
#import "BPlusLinksForgotPasswordViewController.h"
#import "BPlusLinksAccountViewController.h"

#import "CustomButton.h"
@interface BPlusMilesViewController ()
{
    int tabHeight;
    int labelHeight;
    int fontSize;
    int fontSize1;
    int paddingLeft;
    int buttonWidth;
    int padding;
    int fontSize2;
    
    int labelWidth1;
    int labelHeight1;
    
    int delta;
}
@end

@implementation BPlusMilesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = @"Login";
    
    tabHeight = 35;
    fontSize = 13;
    fontSize1 = 16;
    fontSize2 = 10;
    labelHeight = 32;
    paddingLeft = 30;
    buttonWidth = 120;
    padding = 10;
    
    labelHeight1= 18;
    labelWidth1 = 120;
    delta = 2;
    if (IS_IPAD) {
        tabHeight = 70;
        fontSize = 26;
        labelHeight = 60;
        fontSize1 = 24;
        fontSize2 = 20;
        paddingLeft = 60;
        buttonWidth = 300;
        padding = 20;
        
        labelHeight1 = 30;
        labelWidth1 = 240;
        delta = 4;
    }
    [self creatUI];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isKeepLogin = [defaults boolForKey:@"Plus.isKeepLogin"];
    [keepLogin setCheckState:(isKeepLogin) ? M13CheckboxStateChecked : M13CheckboxStateUnchecked];
    
    if (isKeepLogin) {
        [loginIdTextfield setText:[defaults objectForKey:@"Plus.LoginId"]];
        [passwordTextfield setText:[defaults objectForKey:@"Plus.Password"]];
    } else {
        [defaults removeObjectForKey:@"Plus.LoginId"];
        [defaults removeObjectForKey:@"Plus.isKeepLogin"];
        [defaults synchronize];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PlusMiles Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI {
    
    myLoginButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [myLoginButton setFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width/2, tabHeight)];
    [myLoginButton setButtonColor:[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1] forState:UIControlStateNormal];
    [myLoginButton setButtonColor:[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1] forState:UIControlStateSelected];
    [myLoginButton setTitle:@"My Login" forState:UIControlStateNormal];
    myLoginButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [myLoginButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    myLoginButton.selected = YES;
    [self.view addSubview:myLoginButton];
    
    merchantButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [merchantButton setFrame:CGRectMake(self.view.frame.size.width/2, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width/2, tabHeight)];
    [merchantButton setButtonColor:[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1] forState:UIControlStateNormal];
    [merchantButton setButtonColor:[UIColor colorWithRed:10.0/255 green:198.0/255 blue:223.0/255 alpha:1] forState:UIControlStateSelected];
    [merchantButton setTitle:@"Merchant" forState:UIControlStateNormal];
    merchantButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [merchantButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:merchantButton];
    
    loginView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight + tabHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - tabHeight)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, loginView.frame.size.height-labelHeight)];
    [backgroundImage setUserInteractionEnabled:TRUE];
    backgroundImage.image = [UIImage imageNamed:@"login-background.png"];
    if (self.view.frame.size.height > 480) {
        backgroundImage.image = [UIImage imageNamed:@"login-background-568h@2x.png"];
    }
    
    [loginView addSubview:backgroundImage];
    [[self view] addSubview:loginView];
    
    merchantView = [[BMerchantView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight + tabHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT - statusBarHeight-tabHeight)];
    [merchantView setHidden:TRUE];
    [[self view] addSubview:merchantView];
    
    loginIdTextfield = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, 35.0f, self.view.frame.size.width - paddingLeft*2, labelHeight)];
    [loginIdTextfield setDelegate:self];
    [loginIdTextfield setBackgroundColor:[UIColor whiteColor]];
    [loginIdTextfield setFont:[UIFont systemFontOfSize:fontSize1]];
    loginIdTextfield.layer.borderWidth = 1.0f;
    [loginIdTextfield.layer setBorderColor:[[UIColor grayColor] CGColor]];
    loginIdTextfield.placeholder = @"Login ID";
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, labelHeight)];
    loginIdTextfield.leftView = paddingView;
    loginIdTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    [loginView addSubview:loginIdTextfield];
    
    /*
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 60.0f, self.view.frame.size.width, 18.0f)];
    [passwordLabel setText:@"Password"];
    [passwordLabel setBackgroundColor:[UIColor clearColor]];
    [passwordLabel setTextColor:[UIColor colorWithRed:0.0f green:176.0f/255.0f blue:73.0f/255.0f alpha:1.0f]];
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    [passwordLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [loginView addSubview:passwordLabel];
    */
    
    passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, 35.0f+labelHeight+padding, self.view.frame.size.width - paddingLeft*2, labelHeight)];
    [passwordTextfield setDelegate:self];
    [passwordTextfield setSecureTextEntry:TRUE];
    [passwordTextfield setBackgroundColor:[UIColor whiteColor]];
    [passwordTextfield setFont:[UIFont systemFontOfSize:fontSize1]];
    passwordTextfield.layer.borderWidth = 1.0f;
    [passwordTextfield.layer setBorderColor:[[UIColor grayColor] CGColor]];
    passwordTextfield.placeholder = @"Password";
    
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, labelHeight)];
    passwordTextfield.leftView = paddingView;
    passwordTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    [loginView addSubview:passwordTextfield];
    
    UIButton *registerButton = [[UIButton alloc] init];
    [registerButton setFrame:CGRectMake(paddingLeft, passwordTextfield.frame.origin.y + passwordTextfield.frame.size.height + padding, buttonWidth, labelHeight)];
    [registerButton setTitle:@"New Registration" forState:UIControlStateNormal];
    [[registerButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [registerButton setBackgroundColor:[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1]];
    [registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchDown];
    
    [loginView addSubview:registerButton];
    
    UIButton *loginPlusButton = [[UIButton alloc] init];
    [loginPlusButton setFrame:CGRectMake(self.view.frame.size.width-paddingLeft-buttonWidth, passwordTextfield.frame.origin.y + passwordTextfield.frame.size.height + padding, buttonWidth, labelHeight)];
    [loginPlusButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginPlusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[loginPlusButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [loginPlusButton setBackgroundColor:[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1]];
    [loginPlusButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchDown];
    [loginView addSubview:loginPlusButton];
    
    keepLogin = [[M13Checkbox alloc] initWithFrame:CGRectMake(paddingLeft, loginPlusButton.frame.origin.y + loginPlusButton.frame.size.height + padding, labelWidth1, labelHeight1)];
    [keepLogin setCheckAlignment:M13CheckboxAlignmentLeft];
    [[keepLogin titleLabel] setFont:[UIFont systemFontOfSize:fontSize2]];
    [[keepLogin titleLabel] setTextColor:[UIColor grayColor]];
    [keepLogin setTitle:@"Remember Me"];
    [loginView addSubview:keepLogin];
    
    UIButton *forgotPasswordButton = [[UIButton alloc] init];
    [forgotPasswordButton setFrame:CGRectMake(keepLogin.frame.origin.x + keepLogin.frame.size.width+padding, loginPlusButton.frame.origin.y + loginPlusButton.frame.size.height + padding+delta, labelWidth1, labelHeight1)];
    [forgotPasswordButton addTarget:self action:@selector(doForgotPassword) forControlEvents:UIControlEventTouchDown];
    [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1] forState:UIControlStateNormal];
    [[forgotPasswordButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize2]];
    [loginView addSubview:forgotPasswordButton];
    
    UIButton *visitButton = [[UIButton alloc] init];
    [visitButton setFrame:CGRectMake(0, loginView.frame.size.height - labelHeight-padding, loginView.frame.size.width , labelHeight)];
    [visitButton setBackgroundColor:[UIColor clearColor]];
    [visitButton setTitle:@"For more information, visit www.plusmiles.com.my" forState:UIControlStateNormal];
    [visitButton addTarget:self action:@selector(doVisit) forControlEvents:UIControlEventTouchDown];
    [visitButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:216.0f/255.0f blue:149.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[visitButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize2]];
    [loginView addSubview:visitButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor colorWithRed:2.0/255 green:187.0/255 blue:212.0/255 alpha:1] CGColor];
    textField.layer.borderWidth= 1.0f;
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor grayColor] CGColor];
    textField.layer.borderWidth= 1.0f;
    return YES;
}
- (void)changeScreen:(UIButton *)button {
    
    button.selected = YES;
    
    [loginView setHidden:TRUE];
    [merchantView setHidden:TRUE];
    
    if (button == myLoginButton) {
        merchantButton.selected = NO;
        [loginView setHidden:NO];
    } else if (button == merchantButton) {
        myLoginButton.selected = NO;
        [merchantView setHidden:NO];
        [merchantView retrievePromotion];
    }
}

- (void)doVisit {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"informationViewController"] animated:YES];
}

- (void)doRegister {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"] animated:YES];
}

- (void)doLogin {
    [self creatHUD];
    
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy LoginMemberAccount:kAccessCode :kAccessPassword :[loginIdTextfield text] :[passwordTextfield text]];
}

- (void)doForgotPassword {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"forgotpasswordViewController"] animated:YES];
}

- (void)goToAccount {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"accountViewController"] animated:YES];
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    
    [self hideHud];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {

    [self hideHud];
    ResultOfstring *resultString = (ResultOfstring *)data;
    
    if (resultString.responseCode != 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:resultString.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView setDelegate:self];
        alertView.tag = 0;
        [alertView show];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[loginIdTextfield text] forKey:@"Plus.LoginId"];
        [defaults setObject:[passwordTextfield text] forKey:@"Plus.Password"];
        [defaults setBool:(keepLogin.checkState == M13CheckboxStateChecked) forKey:@"Plus.isKeepLogin"];
        [defaults synchronize];
        
        [self goToAccount];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
