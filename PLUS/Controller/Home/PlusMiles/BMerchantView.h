//
//  BMerchantView.h
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckNetwork.h"
#import "DBUpdate.h"
#import "HttpData.h"
#import "MBProgressHUD.h"
#import "TblPromotion.h"
#import "BPromotionCell.h"

@interface BMerchantView : UIView<UITableViewDataSource, UITableViewDelegate> {
    UITableView *merchantTableView;
    
    NSMutableArray *alphabetArray;
    NSMutableArray *merchantArray;
    
    MBProgressHUD *HUD;
}

- (void)retrievePromotion;


@end
