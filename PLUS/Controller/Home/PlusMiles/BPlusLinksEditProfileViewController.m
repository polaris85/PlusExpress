//
//  BPlusLinksEditProfileViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksEditProfileViewController.h"
#import "Constants.h"
@interface BPlusLinksEditProfileViewController ()
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

@implementation BPlusLinksEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleLabel.text = @"PLUSMiles - Edit Profile";
    
    labelFontSize = 13;
    textFontSize = 14;
    labelHeight = 18;
    textHeight = 16;
    padding = 5;
    paddingLeft = 25;
    paddingTop = 20;
    mainScrollSize = 835;
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
        mainScrollSize = 1670;
        registerButtonWidth = 200;
        registerButtonHeight = 40;
        labelWidth1 = 150;
    }

    [self createUI];
    
    [self retrieveCodes];
    
    [self retrieveLatestMemberProfile];
}

- (void)dealloc {
    if (nationalitiesArray) {
        nationalitiesArray = nil;
    }
    
    if (statesArray) {
        statesArray = nil;
    }
    
    if (countriesArray) {
        countriesArray = nil;
    }
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, self.view.frame.size.width, labelHeight)];
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
    
    UILabel *address1Label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, nationalityButton.frame.origin.y+nationalityButton.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [address1Label setText:@"Address"];
    [address1Label setFont:[UIFont systemFontOfSize:labelFontSize]];
    [address1Label setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address1Label];
    
    address1TextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, address1Label.frame.origin.y+address1Label.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [address1TextField setDelegate:self];
    [address1TextField setReturnKeyType:UIReturnKeyNext];
    [address1TextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [address1TextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address1TextField];
    
    UILabel *address2Label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, address1TextField.frame.origin.y+address1TextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [address2Label setText:@"Address"];
    [address2Label setFont:[UIFont systemFontOfSize:labelFontSize]];
    [address2Label setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address2Label];
    
    address2TextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, address2Label.frame.origin.y+address2Label.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [address2TextField setDelegate:self];
    [address2TextField setReturnKeyType:UIReturnKeyNext];
    [address2TextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [address2TextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address2TextField];
    
    UILabel *address3Label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, address2TextField.frame.origin.y+address2TextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [address3Label setText:@"Address"];
    [address3Label setFont:[UIFont systemFontOfSize:labelFontSize]];
    [address3Label setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address3Label];
    
    address3TextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, address3Label.frame.origin.y+address3Label.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [address3TextField setDelegate:self];
    [address3TextField setReturnKeyType:UIReturnKeyNext];
    [address3TextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [address3TextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:address3TextField];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, address3TextField.frame.origin.y+address3TextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [cityLabel setText:@"City"];
    [cityLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [cityLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:cityLabel];
    
    cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, cityLabel.frame.origin.y+cityLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [cityTextField setDelegate:self];
    [cityTextField setReturnKeyType:UIReturnKeyNext];
    [cityTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [cityTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:cityTextField];
    
    UILabel *postalLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, cityTextField.frame.origin.y+cityTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [postalLabel setText:@"Postal Code"];
    [postalLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [postalLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:postalLabel];
    
    postalCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, postalLabel.frame.origin.y+postalLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [postalCodeTextField setDelegate:self];
    [postalCodeTextField setReturnKeyType:UIReturnKeyNext];
    [postalCodeTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [postalCodeTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:postalCodeTextField];
    
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, postalCodeTextField.frame.origin.y+postalCodeTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [countryLabel setText:@"Country"];
    [countryLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [countryLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:countryLabel];
    
    countryButton = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(paddingLeft, countryLabel.frame.origin.y+countryLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [countryButton setInputAccessoryView:toolbar];
    [countryButton setFont:[UIFont systemFontOfSize:textFontSize]];
    [countryButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:countryButton];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, countryButton.frame.origin.y+countryButton.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [stateLabel setText:@"State"];
    [stateLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [stateLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:stateLabel];
    
    stateButton = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(paddingLeft, stateLabel.frame.origin.y+stateLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft*2, textHeight)];
    [stateButton setInputAccessoryView:toolbar];
    [stateButton setFont:[UIFont systemFontOfSize:textFontSize]];
    [stateButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:stateButton];
    
    UILabel *icLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, stateButton.frame.origin.y+stateButton.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
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
    
    passportNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, passportLabel.frame.origin.y+passportLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft, textHeight)];
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
    
    UILabel *homeMobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, businessPhoneTextField.frame.origin.y+businessPhoneTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [homeMobileLabel setText:@"Home Phone"];
    [homeMobileLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [homeMobileLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:homeMobileLabel];
    
    codeHomePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, homeMobileLabel.frame.origin.y+homeMobileLabel.frame.size.height+padding, labelWidth1, textHeight)];
    [codeHomePhoneTextField setDelegate:self];
    [codeHomePhoneTextField setReturnKeyType:UIReturnKeyNext];
    [codeHomePhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [codeHomePhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:codeHomePhoneTextField];
    
    UILabel *separatorHomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(codeHomePhoneTextField.frame.origin.x+codeHomePhoneTextField.frame.size.width, homeMobileLabel.frame.origin.y+homeMobileLabel.frame.size.height+padding, 10.0f, textHeight)];
    [separatorHomeLabel setText:@"-"];
    [separatorHomeLabel setTextAlignment:NSTextAlignmentCenter];
    [separatorHomeLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [separatorHomeLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:separatorHomeLabel];
    
    homePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(separatorHomeLabel.frame.origin.x+separatorHomeLabel.frame.size.width, homeMobileLabel.frame.origin.y+homeMobileLabel.frame.size.height+padding, self.view.frame.size.width-separatorHomeLabel.frame.origin.x-separatorHomeLabel.frame.size.width-padding-paddingLeft, textHeight)];
    [homePhoneTextField setDelegate:self];
    [homePhoneTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [homePhoneTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:homePhoneTextField];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, homePhoneTextField.frame.origin.y+homePhoneTextField.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [emailLabel setText:@"Email"];
    [emailLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [emailLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:emailLabel];
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, emailLabel.frame.origin.y+emailLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft, textHeight)];
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
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, notifyLabel.frame.origin.y+notifyLabel.frame.size.height+padding, self.view.frame.size.width, labelHeight)];
    [passwordLabel setText:@"Password"];
    [passwordLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    [passwordLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:passwordLabel];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, passwordLabel.frame.origin.y+passwordLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft, textHeight)];
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
    
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, confirmPasswordLabel.frame.origin.y+confirmPasswordLabel.frame.size.height+padding, self.view.frame.size.width - paddingLeft, textHeight)];
    [confirmPasswordTextField setDelegate:self];
    [confirmPasswordTextField setSecureTextEntry:TRUE];
    [confirmPasswordTextField setFont:[UIFont systemFontOfSize:textFontSize]];
    [confirmPasswordTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:confirmPasswordTextField];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setFrame:CGRectMake((self.view.frame.size.width-registerButtonWidth)/2, confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height+padding, registerButtonWidth, registerButtonHeight)];
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [[updateButton titleLabel] setFont:[UIFont boldSystemFontOfSize:labelFontSize]];
    [updateButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [updateButton addTarget:self action:@selector(doUpdate) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:updateButton];
}

- (void)retrieveCodes {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    countriesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.CountryCodes"]]];
    nationalitiesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.NationalityCodes"]]];
    statesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.StateCodes"]]];
    
    MemberProfile *memberProfile = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.MemberProfile"]];
    
    NSMutableArray *codeArray = [NSMutableArray array];
    for (int i = 0; i < [countriesArray count]; i++) {
        Code *code = (Code *)[countriesArray objectAtIndex:i];
        
        if ([memberProfile.countryID isEqualToString:code.iId]) {
            [countryButton setText:code.name];
        }
        [codeArray addObject:code.name];
    }
    [countryButton setItemList:[NSArray arrayWithArray:codeArray]];
    
    [codeArray removeAllObjects];
    for (int i = 0; i < [statesArray count]; i++) {
        Code *code = (Code *)[statesArray objectAtIndex:i];
        
        if ([memberProfile.stateID isEqualToString:code.iId]) {
            [stateButton setText:code.name];
        }
        [codeArray addObject:code.name];
    }
    [stateButton setItemList:[NSArray arrayWithArray:codeArray]];
    
    [codeArray removeAllObjects];
    for (int i = 0; i < [nationalitiesArray count]; i++) {
        Code *code = (Code *)[nationalitiesArray objectAtIndex:i];
        
        if ([memberProfile.nationalityID isEqualToString:code.iId]) {
            [nationalityButton setText:code.name];
        }
        [codeArray addObject:code.name];
    }
    [nationalityButton setItemList:[NSArray arrayWithArray:codeArray]];
}

- (void)retrieveLatestMemberProfile {
    [self creatHUD];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    [proxy GetMemberProfile:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :@"" :@"" :@""];
}

- (void)retrieveMemberProfile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MemberProfile *memberProfile = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Plus.MemberProfile"]];
    
    [nameTextField setText:memberProfile.name];
    [address1TextField setText:memberProfile.address1];
    [address2TextField setText:memberProfile.address2];
    [address3TextField setText:memberProfile.address3];
    [cityTextField setText:memberProfile.city];
    [postalCodeTextField setText:memberProfile.postCode];
    [passportNoTextField setText:memberProfile.passportNo];
    
    if (memberProfile.iCNo != nil) {
        NSArray *chuncks = [memberProfile.iCNo componentsSeparatedByString:@"-"];
        if ([chuncks count] > 0) {
            [ic1NoTextField setText:[chuncks objectAtIndex:0]];
            [ic2NoTextField setText:[chuncks objectAtIndex:1]];
            [ic3NoTextField setText:[chuncks objectAtIndex:2]];
        }
    }
    
    if (memberProfile.businessPhone != nil) {
        NSArray *chunks = [memberProfile.businessPhone componentsSeparatedByString: @"-"];
        [codeBusinessPhoneTextField setText:[chunks objectAtIndex:0]];
        [businessPhoneTextField setText:[chunks objectAtIndex:1]];
    }
    
    if (memberProfile.mobileNo != nil) {
        NSArray *chunks = [memberProfile.mobileNo componentsSeparatedByString: @"-"];
        [codeMobilePhoneTextField setText:[chunks objectAtIndex:0]];
        [mobilePhoneTextField setText:[chunks objectAtIndex:1]];
    }
    
    if (memberProfile.homePhone != nil) {
        NSArray *chunks = [memberProfile.homePhone componentsSeparatedByString: @"-"];
        [codeHomePhoneTextField setText:[chunks objectAtIndex:0]];
        [homePhoneTextField setText:[chunks objectAtIndex:1]];
    }
    
    [emailTextField setText:memberProfile.email];
    
    smsCheckBox.checkState = (memberProfile.allowSMS) ? M13CheckboxStateChecked : M13CheckboxStateUnchecked;
    emailCheckBox.checkState = (memberProfile.allowEmail) ? M13CheckboxStateChecked : M13CheckboxStateUnchecked;
}

#pragma mark EventHandler
- (void)doUpdate {
    proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
    
    NSString *icNo = [NSString stringWithFormat:@"%@-%@-%@", ic1NoTextField.text, ic2NoTextField.text, ic3NoTextField.text];
    NSString *homePhone = [NSString stringWithFormat:@"%@-%@", codeHomePhoneTextField.text, homePhoneTextField.text];
    NSString *mobilePhone = [NSString stringWithFormat:@"%@-%@", codeMobilePhoneTextField.text, mobilePhoneTextField.text];
    NSString *businessPhone = [NSString stringWithFormat:@"%@-%@", codeBusinessPhoneTextField.text, businessPhoneTextField.text];
    
    NSString *selectedNationality = @"";
    for (int i = 0; i < [nationalitiesArray count]; i++) {
        Code *code = [nationalitiesArray objectAtIndex:i];
        
        if ([code.name isEqualToString:[nationalityButton text]]) {
            selectedNationality = code.iId;
        }
    }
    
    NSString *selectedCountry = @"";
    for (int i = 0; i < [countriesArray count]; i++) {
        Code *code = [countriesArray objectAtIndex:i];
        
        if ([code.name isEqualToString:[countryButton text]]) {
            selectedCountry = code.iId;
        }
    }
    
    NSString *selectedState = @"";
    for (int i = 0; i < [statesArray count]; i++) {
        Code *code = [statesArray objectAtIndex:i];
        
        if ([code.name isEqualToString:[stateButton text]]) {
            selectedState = code.iId;
        }
    }
    
    [self creatHUD];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [proxy UpdateMemberProfile:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :[defaults objectForKey:@"Plus.Password"] :[nameTextField text] :icNo :[passportNoTextField text] :selectedNationality :[address1TextField text] :[address2TextField text] :[address3TextField text] :[cityTextField text] :selectedState :[postalCodeTextField text] :selectedCountry :[emailTextField text] :mobilePhone :businessPhone :homePhone :(smsCheckBox.checkState == M13CheckboxStateChecked) :(smsCheckBox.checkState == M13CheckboxStateChecked) :(emailCheckBox.checkState == M13CheckboxStateChecked) :(emailCheckBox.checkState == M13CheckboxStateChecked)];
}

- (void)doneClicked:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

#pragma mark PlusMilesServiceProxyDelegate
- (void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method {
    [self hideHud];
    
    if ([method isEqualToString:@"GetMemberProfile"]) {
        [self retrieveMemberProfile];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:[ex description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method {
    
    if ([method isEqualToString:@"UpdateMemberProfile"]) {
        ResultOfstring *result = (ResultOfstring *)data;
        
        if ([[passwordTextField text] length] != 0 || [[confirmPasswordTextField text] length] != 0) {
            if ([passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
                proxy = [[PlusMilesServiceProxy alloc]initWithUrl:kURL AndDelegate:self];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [proxy ChangePassword:kAccessCode :kAccessPassword :[defaults objectForKey:@"Plus.LoginId"] :[defaults objectForKey:@"Plus.Password"] :[passwordTextField text] :[confirmPasswordTextField text]];
            }
        } else {
            [self hideHud];
        }
        
        UIAlertView *alertView = nil;
        if ([result.message isEqualToString:@"Update Successfully"]) {
            alertView = [[UIAlertView alloc] initWithTitle:@"PLUSMiles" message:result.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        } else {
            alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:result.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
        [alertView show];
    } else if ([method isEqualToString:@"GetMemberProfile"]) {
        [self hideHud];
        ResultOfMemberProfileo_PHb66yK *result = (ResultOfMemberProfileo_PHb66yK *)data;
        
        if (result.responseCode == 0) {
            MemberProfile *memberProfile = (MemberProfile *)result.data;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSData *memberProfileData = [NSKeyedArchiver archivedDataWithRootObject:memberProfile];
            [defaults setObject:memberProfileData forKey:@"Plus.MemberProfile"];
            [defaults synchronize];
            
        }
        [self retrieveMemberProfile];
    } else {
        [self hideHud];
        
        ResultOfstring *result = (ResultOfstring *)data;
        
        if (result.responseCode == 0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:passwordTextField.text forKey:@"Plus.Password"];
            [defaults synchronize];
            
            [passwordTextField setText:@""];
            [confirmPasswordTextField setText:@""];
        }
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == ic1NoTextField) {
        return (newLength > 6) ? NO : YES;
    } else if (textField == ic2NoTextField) {
        return (newLength > 2) ? NO : YES;
    } else if (textField == ic3NoTextField) {
        return (newLength > 4) ? NO : YES;
    } else if (textField == codeMobilePhoneTextField || textField == codeBusinessPhoneTextField || textField == codeHomePhoneTextField) {
        return (newLength > 3) ? NO : YES;
    } else if (textField == mobilePhoneTextField || textField == businessPhoneTextField || textField == homePhoneTextField) {
        return (newLength > 8) ? NO : YES;
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
    
    return YES;
}


@end
