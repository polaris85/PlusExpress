//
//  BPlusLinksEditProfileViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "CTCheckbox.h"
#import "IQDropDownTextField.h"
#import "M13Checkbox.h"
#import "PlusMilesServiceProxy.h"

@interface BPlusLinksEditProfileViewController : BaseViewController<UITextFieldDelegate, Wsdl2CodeProxyDelegate> {
    UITextField *nameTextField;
    IQDropDownTextField *nationalityButton;
    UITextField *address1TextField;
    UITextField *address2TextField;
    UITextField *address3TextField;
    UITextField *cityTextField;
    UITextField *postalCodeTextField;
    IQDropDownTextField *countryButton;
    IQDropDownTextField *stateButton;
    UITextField *ic1NoTextField;
    UITextField *ic2NoTextField;
    UITextField *ic3NoTextField;
    UITextField *passportNoTextField;
    UITextField *codeBusinessPhoneTextField;
    UITextField *businessPhoneTextField;
    UITextField *codeMobilePhoneTextField;
    UITextField *mobilePhoneTextField;
    UITextField *codeHomePhoneTextField;
    UITextField *homePhoneTextField;
    UITextField *emailTextField;
    
    M13Checkbox *emailCheckBox;
    M13Checkbox *smsCheckBox;
    
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    
    NSMutableArray *nationalitiesArray;
    NSMutableArray *statesArray;
    NSMutableArray *countriesArray;
    UIScrollView *mainScrollView;
    
    PlusMilesServiceProxy *proxy;
}
@end
