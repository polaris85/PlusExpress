//
//  BHomeViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/17/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HttpData.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "CheckNetwork.h"
#import "TblConfig.h"
#import "DBUpdate.h"
@interface BHomeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    UIButton *btnAd;
    UIImageView *btnImageView;
    
    int adIndex;
    
    NSTimer *timer;
    
    int heightIphone5Style;
    int heightAdIphone5Style;
}
@property (nonatomic,retain) NSMutableArray *adArray;

- (void)creatUI;
//- (void)creatAdView;

@end
