//
//  BKembaraViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "ReaderViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BKembaraViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, ReaderViewControllerDelegate>
{
    NSMutableArray *magazineArray;
    NSTimer *timer;
    int currentIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)creatUI;
- (void)creatKembaraData;
@end
