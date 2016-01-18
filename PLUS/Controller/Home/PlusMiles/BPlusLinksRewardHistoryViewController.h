//
//  BPlusLinksRewardHistoryViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "PlusMilesServiceProxy.h"
#import "TTTAttributedLabel.h"
#import "BPlusLinksEditProfileViewController.h"
#import "BRewardCell.h"

@interface BPlusLinksRewardHistoryViewController : BaseViewController<TTTAttributedLabelDelegate, UITableViewDataSource, UITableViewDelegate, Wsdl2CodeProxyDelegate> {
    TTTAttributedLabel *attributedLabel;
    NSArray *rewardArray;
    BOOL hiddenTableView;
    
    UITableView *rewardTableView;
    PlusMilesServiceProxy *proxy ;
}

@property (nonatomic, retain) NSString *cardNumber;

@end
