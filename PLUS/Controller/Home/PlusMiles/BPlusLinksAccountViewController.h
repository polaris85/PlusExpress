//
//  BPlusLinksAccountViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "IQDropDownTextField.h"
#import "PlusMilesServiceProxy.h"
#import "TTTAttributedLabel.h"
#import "BMerchantView.h"
#import "BCommunityInterestView.h"
#import "BPlusLinksAddNewCardViewController.h"
#import "BPlusLinksCommunityInterestAddViewController.h"
#import "BPlusLinksCommunityInterestViewController.h"
#import "BPlusLinksRebatePointsViewController.h"
#import "BPlusLinksRedemptionViewController.h"
#import "BPlusLinksRewardHistoryViewController.h"

@interface BPlusLinksAccountViewController : BaseViewController<TTTAttributedLabelDelegate, Wsdl2CodeProxyDelegate> {
    UIView *accountView;
    BMerchantView *merchantView;
    BCommunityInterestView *communityInterestView;
    TTTAttributedLabel *attributedLabel;
    
    UILabel *emailValueLabel;
    UILabel *nameValueLabel;
    UILabel *serialValueLabel;
    IQDropDownTextField *serialValueTextField;
    
    PlusMilesServiceProxy *proxy;
    
    UIButton *accountButton;
    UIButton *merchantButton;
    //UIButton *communityInterestButton;
    
    UIView *grayView;
}


@end
