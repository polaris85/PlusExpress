//
//  BLiveFeedTableViewCell.m
//  PLUS
//
//  Created by Ben Folds on 9/20/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BLiveFeedTableViewCell.h"

@implementation BLiveFeedTableViewCell

@synthesize nameLabel;
@synthesize detailLabel;
@synthesize captureImageView;
@synthesize shareImageView;
@synthesize shareButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        captureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 90.0f, 90.0f)];
        [[self contentView] addSubview:captureImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0f, 10.0f, self.contentView.frame.size.width - 104, 20.0f)];
        [nameLabel setText:@"Date"];
        [nameLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [nameLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        //[nameLabel sizeToFit];
        [[self contentView] addSubview:nameLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0f, 40.0f, self.contentView.frame.size.width - 104, 20.0f)];
        [detailLabel setText:@"KM 65.4"];
        [detailLabel setFont:[UIFont systemFontOfSize:16]];
        [detailLabel setTextColor:[UIColor colorWithRed:76.0/255 green:209.0/255 blue:255.0/255 alpha:1]];
        [[self contentView] addSubview:detailLabel];
        
        shareButton = [[UIButton alloc] initWithFrame:CGRectMake(278.0f, 60.0f, 32.0f, 32.0f)];
        [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [[self contentView] addSubview:shareButton];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
