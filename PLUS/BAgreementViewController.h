//
//  BAgreementViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAgreementViewController : UIViewController{
    BOOL isSettingMode;
}

@property (retain, nonatomic) IBOutlet UIImageView *navBar;
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIButton *unAcceptBtn;
@property (retain, nonatomic) IBOutlet UIButton *acceptBtn;
@property (retain, nonatomic) IBOutlet UIWebView *agreenWebView;

- (void)setSettingMode:(BOOL)mode;


@end
