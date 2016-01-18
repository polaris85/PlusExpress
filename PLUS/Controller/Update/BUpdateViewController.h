//
//  BUpdateViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "CheckNetwork.h"
@interface BUpdateViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *updateDataArray;
    int currentUpdateIndex;
}

- (void)loadMobileUpdateData;
- (void)creatUI;
@end
