//
//  BPlusLinksRedemptionViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "PlusMilesServiceProxy.h"
#import "BRedemptionCell.h"
#import "TTTAttributedLabel.h"
#import "BPlusLinksEditProfileViewController.h"

@interface BPlusLinksRedemptionViewController : BaseViewController<TTTAttributedLabelDelegate, UITableViewDataSource, UITableViewDelegate, Wsdl2CodeProxyDelegate> {
    TTTAttributedLabel *attributedLabel;
    NSArray *redemptionArray;
    BOOL hiddenTableView;
    
    UITableView *redemptionTableView;
    PlusMilesServiceProxy *proxy ;
}

@property (nonatomic, retain) NSString *cardNumber;

@end
