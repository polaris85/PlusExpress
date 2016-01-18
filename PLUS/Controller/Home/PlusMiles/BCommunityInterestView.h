//
//  BCommunityInterestView.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckNetwork.h"
#import "HttpData.h"
#import "IQDropDownTextField.h"
#import "MBProgressHUD.h"
#import "BCommunityInterestCell.h"

@protocol CommunityInterestDelegate <NSObject>

- (void)showCommunityInterestReply:(NSDictionary *)communityInterestDictionary;
- (void)showAddCommunityInterest:(NSString *)idInterestCatg;

@end
@interface BCommunityInterestView : UIView<UITableViewDataSource, UITableViewDelegate> {
    IQDropDownTextField *timeTextField;
    IQDropDownTextField *categoryTextField;
    UITableView *communityInterestTableView;
    UIButton *newPostButton;
    
    MBProgressHUD *HUD;
    NSMutableArray *categoryArray;
    NSMutableArray *communityInterestArray;
    NSArray *timeOptionArray;
    NSArray *timeOptionSecondArray;
    
    int currentPage;
}

- (void)retrieveCommunityInterest;

@property (nonatomic, assign) id<CommunityInterestDelegate> delegate;

@end
