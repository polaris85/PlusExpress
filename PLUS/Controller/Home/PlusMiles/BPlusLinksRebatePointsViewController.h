//
//  BPlusLinksRebatePointsViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "PlusMilesServiceProxy.h"
#import "TTTAttributedLabel.h"
#import "BPlusLinksEditProfileViewController.h"

@interface BPlusLinksRebatePointsViewController : BaseViewController<TTTAttributedLabelDelegate, Wsdl2CodeProxyDelegate> {
    TTTAttributedLabel *attributedLabel;
    
    UILabel *rebateValueLabel;
    UILabel *pointValueLabel;
    UILabel *staffCardLabel;
    UILabel *staffCardValueLabel;
}

@property (nonatomic, retain) NSString *cardNumber;

@end
