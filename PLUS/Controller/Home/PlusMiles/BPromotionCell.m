//
//  BPromotionCell.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPromotionCell.h"

@implementation BPromotionCell

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
        // Initialization code
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 80.0f, 80.0f)];
        [[self contentView] addSubview:logoImageView];
        
        merchantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 10.0f, self.contentView.frame.size.width - 110.0f, 20.0f)];
        [merchantNameLabel setNumberOfLines:0];
        [merchantNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [merchantNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [[self contentView] addSubview:merchantNameLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 30.0f, self.contentView.frame.size.width - 110.0f, 20.0f)];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [[self contentView] addSubview:titleLabel];
        
        promotionCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 50.0f, self.contentView.frame.size.width - 110.0f, 20.0f)];
        [promotionCategoryLabel setNumberOfLines:0];
        [promotionCategoryLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [promotionCategoryLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [promotionCategoryLabel setTextColor:[UIColor colorWithRed:35.0f/255.0f green:183.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
        [[self contentView] addSubview:promotionCategoryLabel];
    
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)merchantDictionary {
    [logoImageView setImageWithURL:[NSURL URLWithString:[merchantDictionary objectForKey:@"strLocationImg"]]];
    
    double merchantNameHeight = [self heightOfString:[merchantDictionary objectForKey:@"strMerchantName"] withLabel:merchantNameLabel];
    [merchantNameLabel setFrame:CGRectMake(merchantNameLabel.frame.origin.x, merchantNameLabel.frame.origin.y, merchantNameLabel.frame.size.width, merchantNameHeight)];
    [merchantNameLabel setText:[merchantDictionary objectForKey:@"strMerchantName"]];
    
    double titleHeight = [self heightOfString:[merchantDictionary objectForKey:@"strTitle"] withLabel:titleLabel];
    [titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, merchantNameLabel.frame.origin.y + merchantNameLabel.frame.size.height + 5.0f, titleLabel.frame.size.width, titleHeight)];
    [titleLabel setText:[merchantDictionary objectForKey:@"strTitle"]];
    
    double categoryHeight = [self heightOfString:[merchantDictionary objectForKey:@"strPromoCatgName"] withLabel:promotionCategoryLabel];
    [promotionCategoryLabel setFrame:CGRectMake(promotionCategoryLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5.0f, promotionCategoryLabel.frame.size.width, categoryHeight)];
    [promotionCategoryLabel setText:[merchantDictionary objectForKey:@"strPromoCatgName"]];
    
    _totalHeight = promotionCategoryLabel.frame.origin.y + promotionCategoryLabel.frame.size.height + 10.0f;
}

@end
