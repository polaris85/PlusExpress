//
//  BNotificationViewController.h
//  PLUS
//
//  Created by Ben Folds on 10/14/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface BNotificationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *table;
    
    NSMutableArray *notificationArray;
}

@end
