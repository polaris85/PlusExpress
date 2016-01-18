//
//  BRsaViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/18/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BRsaViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *highWayArray;
    NSMutableArray *highWayDetailArray;
    NSMutableArray *rsaArray;
    NSMutableArray *laybyArray;
    
    int segmentIndex;
    NSMutableArray *btnArray;
    UITableView *table;
}

- (void)creatRsaData;
- (void)creatUI;
@end
