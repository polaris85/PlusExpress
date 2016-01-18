//
//  BPlusLinksCommunityInterestViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "CheckNetwork.h"
#import "HttpData.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "BCommunityInterestCell.h"

@interface BPlusLinksCommunityInterestViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UIScrollView *mainScrollView;
    UILabel *CITitleLabel;
    UIButton *CIImageView;
    UILabel *CIDescriptionLabel;
    UILabel *CIPostedByLabel;
    UILabel *CIRepliesLabel;
    UITableView *CIReplyTableView;
    
    UIView *replyBoxView;
    UITextField *replyBoxTextField;
    UIButton *replyButton;
    
    NSMutableArray *replyArray;
    BOOL isKeyboardShown;
}

@property (nonatomic, retain) NSDictionary *communityInterestDictionary;

@end
