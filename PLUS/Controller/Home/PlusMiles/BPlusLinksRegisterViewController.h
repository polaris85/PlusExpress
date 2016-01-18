//
//  BPlusLinksRegisterViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "IQDropDownTextField.h"
#import "M13Checkbox.h"
#import "PlusMilesServiceProxy.h"
#import "BPlusLinksTermConditionViewController.h"
#import "BPlusLinksPrivacyPolicyViewController.h"
#import "Constants.h"
@interface BPlusLinksRegisterViewController : BaseViewController <UITextFieldDelegate, Wsdl2CodeProxyDelegate> {
    UITextField *serialMfgCardNumberTextField;
    UITextField *confirmSerialMfgCardNumberTextField;
    UITextField *nameTextField;
    IQDropDownTextField *nationalityButton;
    UITextField *ic1NoTextField;
    UITextField *ic2NoTextField;
    UITextField *ic3NoTextField;
    UITextField *passportNoTextField;
    UITextField *codeBusinessPhoneTextField;
    UITextField *businessPhoneTextField;
    UITextField *codeMobilePhoneTextField;
    UITextField *mobilePhoneTextField;
    UITextField *emailTextField;
    
    M13Checkbox *emailCheckBox;
    M13Checkbox *smsCheckBox;
    
    UITextField *loginIdTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    
    M13Checkbox *termCheckBox;
    
    NSMutableArray *countriesArray;
    UIScrollView *mainScrollView;
    
    PlusMilesServiceProxy *proxy ;
}

@end
