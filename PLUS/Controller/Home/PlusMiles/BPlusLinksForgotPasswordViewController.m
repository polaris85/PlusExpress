//
//  BPlusLinksForgotPasswordViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksForgotPasswordViewController.h"

@interface BPlusLinksForgotPasswordViewController ()

@end

@implementation BPlusLinksForgotPasswordViewController

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
    titleLabel.text = @"Forgot Password";
    
    [self createUI];
}

- (void)createUI {
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 84.0f, self.view.frame.size.width, 18.0f)];
    [emailLabel setText:@"Email"];
    [emailLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [emailLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:emailLabel];
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 104.0f, self.view.frame.size.width - 30.0f, 16.0f)];
    [emailTextField setReturnKeyType:UIReturnKeySend];
    [emailTextField setDelegate:self];
    [emailTextField setFont:[UIFont systemFontOfSize:14.0f]];
    [emailTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [[self view] addSubview:emailTextField];
    
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton setFrame:CGRectMake(255.0f, 135.0f, 50.0f, 20.0f)];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [[sendButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.50f]];
    [sendButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [sendButton addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:sendButton];
}

- (void)doSend {
    [self creatHUD];
    
    [emailTextField resignFirstResponder];
    
    PlusMilesServiceProxy *proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy ForgotPassword:kAccessCode :kAccessPassword :[emailTextField text]];
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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:resultString.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self doSend];
    [textField resignFirstResponder];
    
    return YES;
}


@end
