//
//  BRedemptionCell.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusMilesServiceProxy.h"
@interface BRedemptionCell : UITableViewCell{
    UILabel *dateValueLabel;
    UILabel *productValueLabel;
    UILabel *rebateValueLabel;
    UILabel *pointValueLabel;
    UILabel *staffSubsidyValueLabel;
    
    UILabel *dateLabel;
    UILabel *productLabel;
    UILabel *rebateLabel;
    UILabel *pointLabel;
    UILabel *staffLabel;
}

- (void)setRedemptionInfo:(CardMonthsRedemption *)cardMonths;

@end
