//
//  BPlusLinksForgotPasswordViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "PlusMilesServiceProxy.h"

@interface BPlusLinksForgotPasswordViewController : BaseViewController<UITextFieldDelegate, Wsdl2CodeProxyDelegate> {
    UITextField *emailTextField;
}

@end
