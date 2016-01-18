//
//  BTollPlazaViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface BTollPlazaViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tollPlazaArray;
    NSMutableArray *highWayArray;
    NSMutableArray *highWayDetailArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)creatUI;
- (void)creatTollPlazaData;

@end
