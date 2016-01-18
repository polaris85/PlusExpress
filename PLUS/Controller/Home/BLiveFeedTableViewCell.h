//
//  BLiveFeedTableViewCell.h
//  PLUS
//
//  Created by Ben Folds on 9/20/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLiveFeedTableViewCell : UITableViewCell{
    
}

@property (strong, nonatomic) UIImageView *captureImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *shareImageView;

@property (strong, nonatomic) UIButton *shareButton;
@end
