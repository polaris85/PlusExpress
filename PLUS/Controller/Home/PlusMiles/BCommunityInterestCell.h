//
//  BCommunityInterestCell.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TimeAgo.h"

@interface BCommunityInterestCell : UITableViewCell{
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    UILabel *postedByLabel;
    UILabel *activeLabel;
    UILabel *timeLabel;
}

@property (nonatomic) double totalHeight;

- (void)setCommunityInterestInfo:(NSDictionary *)communityInterestDictionary;

@end
