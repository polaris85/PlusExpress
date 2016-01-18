//
//  BPlusMilesViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "CheckNetwork.h"
#import "DBUpdate.h"
#import "HttpData.h"
#import "M13Checkbox.h"
#import "MBProgressHUD.h"
#import "PlusMilesServiceProxy.h"
#import "TblPromotion.h"
#import "BMerchantView.h"
#import "Constants.h"
#import "CustomButton.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BPlusMilesViewController : BaseViewController <UIAlertViewDelegate, UITextFieldDelegate, Wsdl2CodeProxyDelegate> {
    
    UIView *loginView;
    BMerchantView *merchantView;
    UITextField *loginIdTextfield;
    UITextField *passwordTextfield;
    
    CustomButton *myLoginButton;
    CustomButton *merchantButton;
    UIButton *registrationButton;
    UIButton *loginButton;
    
    M13Checkbox *keepLogin;
    
    PlusMilesServiceProxy *proxy ;
    
    UIView *grayView;
}


@end
