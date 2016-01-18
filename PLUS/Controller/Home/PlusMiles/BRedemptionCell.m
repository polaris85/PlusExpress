//
//  BRedemptionCell.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BRedemptionCell.h"

@implementation BRedemptionCell

- (double)heightOfString:(NSString *)string withLabel:(UILabel *)currentLabel {
    CGRect currentFrame = currentLabel.frame;
    CGSize max = CGSizeMake(currentLabel.frame.size.width, 10000.0f);
    CGSize expected = [string sizeWithFont:currentLabel.font constrainedToSize:max lineBreakMode:currentLabel.lineBreakMode];
    currentFrame.size.height = expected.height;
    return currentFrame.size.height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, self.contentView.frame.size.width, 15.0f)];
        [dateLabel setText:@"Date"];
        [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [dateLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:dateLabel];
        
        dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 5.0f, 175.0f, 15.0f)];
        [dateValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [dateValueLabel setNumberOfLines:0];
        [dateValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[self contentView] addSubview:dateValueLabel];
        
        productLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25.0f, self.contentView.frame.size.width, 15.0f)];
        [productLabel setText:@"Product"];
        [productLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [productLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:productLabel];
        
        productValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 25.0f, 175.0f, 15.0f)];
        [productValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [productValueLabel setNumberOfLines:0];
        [productValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[self contentView] addSubview:productValueLabel];
        
        rebateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 45.0f, self.contentView.frame.size.width, 15.0f)];
        [rebateLabel setText:@"Rebate"];
        [rebateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [rebateLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:rebateLabel];
        
        rebateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 45.0f, 175.0f, 15.0f)];
        [rebateValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [rebateValueLabel setNumberOfLines:0];
        [rebateValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[self contentView] addSubview:rebateValueLabel];
        
        pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 65.0f, self.contentView.frame.size.width, 15.0f)];
        [pointLabel setText:@"Point"];
        [pointLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [pointLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:pointLabel];
        
        pointValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 65.0f, 175.0f, 15.0f)];
        [pointValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [pointValueLabel setNumberOfLines:0];
        [pointValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[self contentView] addSubview:pointValueLabel];
        
        staffLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 85.0f, self.contentView.frame.size.width, 15.0f)];
        [staffLabel setText:@"Staff Card Subsidy"];
        [staffLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [staffLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:staffLabel];
        
        staffSubsidyValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 85.0f, 175.0f, 15.0f)];
        [staffSubsidyValueLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [staffSubsidyValueLabel setNumberOfLines:0];
        [staffSubsidyValueLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[self contentView] addSubview:staffSubsidyValueLabel];
    }
    return self;
}

- (void)setRedemptionInfo:(CardMonthsRedemption *)cardMonths {
    NSArray *chuncks = [cardMonths.redemptionDate componentsSeparatedByString:@"T"];
    NSString *dateString = @"";
    if ([chuncks count] > 0) {
        dateString = [NSString stringWithFormat:@"%@ %@", [chuncks objectAtIndex:0], [[chuncks objectAtIndex:1] substringToIndex:5]];
    }
    
    double dateHeight = [self heightOfString:cardMonths.redemptionDate withLabel:dateValueLabel];
    [dateValueLabel setFrame:CGRectMake(dateValueLabel.frame.origin.x, dateValueLabel.frame.origin.y, dateValueLabel.frame.size.width, dateHeight)];
    [dateValueLabel setText:dateString];
    [dateLabel setFrame:CGRectMake(dateLabel.frame.origin.x, dateValueLabel.frame.origin.y, dateLabel.frame.size.width, dateLabel.frame.size.height)];
    
    double productHeight = [self heightOfString:cardMonths.redemptionProduct withLabel:productValueLabel];
    [productValueLabel setFrame:CGRectMake(productValueLabel.frame.origin.x, dateValueLabel.frame.origin.y + dateValueLabel.frame.size.height + 5.0f, productValueLabel.frame.size.width, productHeight)];
    [productValueLabel setText:cardMonths.redemptionProduct];
    [productLabel setFrame:CGRectMake(productLabel.frame.origin.x, productValueLabel.frame.origin.y, productLabel.frame.size.width, productLabel.frame.size.height)];
    
    double height = 0;
    if (![cardMonths.redemptionType isEqualToString:@"S"]) {
        [rebateLabel setHidden:FALSE];
        [rebateValueLabel setHidden:FALSE];
        [rebateValueLabel setFrame:CGRectMake(rebateValueLabel.frame.origin.x, productValueLabel.frame.origin.y + productValueLabel.frame.size.height + 5.0f, rebateValueLabel.frame.size.width, rebateValueLabel.frame.size.height)];
        [rebateValueLabel setText:cardMonths.redemptionAmount];
        [rebateLabel setFrame:CGRectMake(rebateLabel.frame.origin.x, rebateValueLabel.frame.origin.y, rebateLabel.frame.size.width, rebateLabel.frame.size.height)];
        height = rebateValueLabel.frame.origin.y + rebateValueLabel.frame.size.height + 5.0f;
    } else {
        [rebateLabel setHidden:TRUE];
        [rebateValueLabel setHidden:TRUE];
        height = productValueLabel.frame.origin.y + productValueLabel.frame.size.height + 5.0f;
    }
    
    [pointValueLabel setFrame:CGRectMake(pointValueLabel.frame.origin.x, height, pointValueLabel.frame.size.width, pointValueLabel.frame.size.height)];
    [pointValueLabel setText:[NSString stringWithFormat:@"%d", cardMonths.redemptionPoints]];
    [pointLabel setFrame:CGRectMake(pointLabel.frame.origin.x, pointValueLabel.frame.origin.y, pointLabel.frame.size.width, pointLabel.frame.size.height)];
    
    if ([cardMonths.redemptionType isEqualToString:@"S"]) {
        [staffSubsidyValueLabel setHidden:FALSE];
        [staffLabel setHidden:FALSE];
        [staffSubsidyValueLabel setFrame:CGRectMake(staffSubsidyValueLabel.frame.origin.x, pointValueLabel.frame.origin.y + pointValueLabel.frame.size.height + 5.0f, staffSubsidyValueLabel.frame.size.width, staffSubsidyValueLabel.frame.size.height)];
        [staffSubsidyValueLabel setText:cardMonths.redemptionAmount];
        [staffLabel setFrame:CGRectMake(staffLabel.frame.origin.x, staffSubsidyValueLabel.frame.origin.y, staffLabel.frame.size.width, staffLabel.frame.size.height)];
    } else {
        [staffSubsidyValueLabel setHidden:TRUE];
        [staffLabel setHidden:TRUE];
    }
}

@end