//
//  BCommunityInterestCell.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BCommunityInterestCell.h"

@implementation BCommunityInterestCell
@synthesize totalHeight = _totalHeight;

- (double)heightOfString:(NSString *)string withLabel:(UILabel *)currentLabel {
    CGRect currentFrame = currentLabel.frame;
    CGSize max = CGSizeMake(currentLabel.frame.size.width, 10000.0f);
    CGSize expected = [string sizeWithFont:currentLabel.font constrainedToSize:max lineBreakMode:currentLabel.lineBreakMode];
    currentFrame.size.height = expected.height;
    return currentFrame.size.height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.contentView.frame.size.width - 10.0f - 60.0f, 18.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [titleLabel setNumberOfLines:0];
        [[self contentView] addSubview:titleLabel];
        
        activeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 5.0f, titleLabel.frame.origin.y, 50.0f, 18.0f)];
        [activeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [activeLabel setNumberOfLines:0];
        [activeLabel setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:activeLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [descriptionLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [descriptionLabel setNumberOfLines:0];
        [[self contentView] addSubview:descriptionLabel];
        
        postedByLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [postedByLabel setFont:[UIFont italicSystemFontOfSize:11.0f]];
        [postedByLabel setNumberOfLines:0];
        [[self contentView] addSubview:postedByLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setFont:[UIFont italicSystemFontOfSize:11.0f]];
        [timeLabel setNumberOfLines:0];
        [[self contentView] addSubview:timeLabel];
    }
    return self;
}

- (void)setCommunityInterestInfo:(NSDictionary *)communityInterestDictionary {
    if (![communityInterestDictionary objectForKey:@"dtReplydate"]) {
        double titleHeight = [self heightOfString:[communityInterestDictionary objectForKey:@"strTitle"] withLabel:titleLabel];
        [titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleHeight)];
        [titleLabel setText:[communityInterestDictionary objectForKey:@"strTitle"]];
        [titleLabel setTextColor:[UIColor blackColor]];
    } else {
        [titleLabel setFrame:CGRectZero];
    }
    
    [descriptionLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5.0f, self.contentView.frame.size.width - 10.0f, 18.0f)];
    double descriptionHeight = [self heightOfString:[communityInterestDictionary objectForKey:@"strDescription"] withLabel:descriptionLabel];
    [descriptionLabel setFrame:CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, descriptionHeight)];
    [descriptionLabel setText:[communityInterestDictionary objectForKey:@"strDescription"]];
    [descriptionLabel setTextColor:[UIColor blackColor]];
    
    NSString *postedByString = [NSString stringWithFormat:@"Posted By: %@", [communityInterestDictionary objectForKey:@"strCustomerName"]];
    [postedByLabel setFrame:CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 5.0f, descriptionLabel.frame.size.width, 18.0f)];
    double postedByHeight = [self heightOfString:postedByString withLabel:postedByLabel];
    [postedByLabel setFrame:CGRectMake(postedByLabel.frame.origin.x, postedByLabel.frame.origin.y, postedByLabel.frame.size.width, postedByHeight)];
    [postedByLabel setText:postedByString];
    [postedByLabel sizeToFit];
    [postedByLabel setTextColor:[UIColor blackColor]];
    
    NSString *timeString = @"";
    if ([communityInterestDictionary objectForKey:@"dtSubmitdate"]) {
        timeString = [communityInterestDictionary objectForKey:@"dtSubmitdate"];
    } else {
        timeString = [communityInterestDictionary objectForKey:@"dtReplydate"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:timeString];
    
    NSString *formattedTimeString = [dateFromString timeAgo];
    [timeLabel setFrame:CGRectMake(postedByLabel.frame.origin.x, postedByLabel.frame.origin.y + postedByLabel.frame.size.height, postedByLabel.frame.size.width, 18.0f)];
    [timeLabel setText:formattedTimeString];
    [timeLabel sizeToFit];
    double timeHeight = [self heightOfString:formattedTimeString withLabel:timeLabel];
    [timeLabel setFrame:CGRectMake(timeLabel.frame.origin.x, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeHeight)];
    [timeLabel setTextColor:[UIColor blackColor]];
    
    if (postedByLabel.frame.size.width + timeLabel.frame.size.width < self.contentView.frame.size.width - 10.0f) {
        [timeLabel setFrame:CGRectMake(self.contentView.frame.size.width - 10.0f - timeLabel.frame.size.width, postedByLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)];
    }
    
    if (![communityInterestDictionary objectForKey:@"dtReplydate"]) {
        int intCaseStatus = [[communityInterestDictionary objectForKey:@"intCaseStatus"] integerValue];
        if (intCaseStatus == 1) {
            [activeLabel setText:@"Active"];
            [activeLabel setTextColor:[UIColor blueColor]];
        } else if (intCaseStatus == 0) {
            [activeLabel setText:@"Pending"];
            [activeLabel setTextColor:[UIColor darkGrayColor]];
            [titleLabel setTextColor:[UIColor darkGrayColor]];
            [descriptionLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [activeLabel setText:@"Rejected"];
            [activeLabel setTextColor:[UIColor redColor]];
            [titleLabel setTextColor:[UIColor redColor]];
        }
    }
    
    _totalHeight = timeLabel.frame.origin.y + timeLabel.frame.size.height + 5.0f;
}
@end
