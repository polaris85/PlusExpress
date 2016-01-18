//
//  BPlusLinksAddNewCardViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "PlusMilesServiceProxy.h"
#import "TTTAttributedLabel.h"
#import "BPlusLinksEditProfileViewController.h"

@interface BPlusLinksAddNewCardViewController : BaseViewController<TTTAttributedLabelDelegate, UIAlertViewDelegate, UITextFieldDelegate, Wsdl2CodeProxyDelegate> {
    TTTAttributedLabel *attributedLabel;
    
    UITextField *serialCardNumberTextField;
    UITextField *confirmSerialCardNumberTextField;
    PlusMilesServiceProxy *proxy;
}

@end
