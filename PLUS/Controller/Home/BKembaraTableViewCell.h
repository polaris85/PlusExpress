//
//  BKembaraTableViewCell.h
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKembaraTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIButton *downloadButton;
@property (strong, nonatomic) UIView *progressView;

@end
