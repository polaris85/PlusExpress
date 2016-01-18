//
//  BPromotionCell.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface BPromotionCell : UITableViewCell{
    UIImageView *logoImageView;
    
    UILabel *merchantNameLabel;
    UILabel *titleLabel;
    UILabel *promotionCategoryLabel;
}

- (void)setDictionary:(NSDictionary *)merchantDictionary;

@property (nonatomic) double totalHeight;

@end
