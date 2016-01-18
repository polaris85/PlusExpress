//
//  BKembaraTableViewCell.m
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BKembaraTableViewCell.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@implementation BKembaraTableViewCell
@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize coverImageView;
@synthesize downloadButton;
@synthesize progressView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        //captureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 90.0f, 90.0f)];
        //[[self contentView] addSubview:captureImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 20.0f, 250.0f, 20.0f)];
        [titleLabel setText:@"Title"];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [titleLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        //[nameLabel sizeToFit];
        [[self contentView] addSubview:titleLabel];
        
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 40.0f, 250.0f, 20.0f)];
        [subTitleLabel setText:@"SubTitle"];
        [subTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [subTitleLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        //[nameLabel sizeToFit];
        [[self contentView] addSubview:subTitleLabel];
        
        coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75.0f, 64.0f, 180.0f, 200.0f)];
        [[self contentView] addSubview:coverImageView];
        
        downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(75.0f, 270.0f, 180.0f, 30.0f)];
        //[downloadButton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        [downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [downloadButton setBackgroundColor:[UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1]];
        [downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self contentView] addSubview:downloadButton];

        progressView = [[UIView alloc] initWithFrame:CGRectMake(75.0f, 220.0f, 180.0f, 44.0f)];
        progressView.backgroundColor = [UIColor clearColor];
        
        [progressView setHidden:YES];
        [[self contentView] addSubview:progressView];
        /*
        progressView= [[UIProgressView alloc] initWithFrame:CGRectMake(75.0f, 244.0f, 180.0f, 20.0f)];
        progressView.progress = 0.0;
        
        
        [progressView setHidden:NO];
         */
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
