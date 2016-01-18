//
//  BRewardCell.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusMilesServiceProxy.h"
@interface BRewardCell : UITableViewCell{
    UILabel *dateValueLabel;
    UILabel *rebateValueLabel;
    UILabel *pointValueLabel;
    UILabel *staffSubsidyValueLabel;
    
    UILabel *dateLabel;
    UILabel *rebateLabel;
    UILabel *pointLabel;
    UILabel *staffLabel;
}

- (void)setRewardInfo:(CardMonthsReward *)cardMonths;

@property (nonatomic) double totalHeight;


@end
