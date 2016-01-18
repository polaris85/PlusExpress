//
//  BUpdateTableViewCell.m
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BUpdateTableViewCell.h"
#import "Constants.h"
@implementation BUpdateTableViewCell

@synthesize updateButton;
@synthesize titleLabel;
@synthesize packIdLabel;
@synthesize descriptionLabel;
@synthesize label2;
@synthesize deployLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        int packageImageSize = 64;
        int titleLabelFont = 14;
        int descriptionLabelFont = 11;
        int deployImageSize = 36;
        int padding = 10;
        int labelHeight = 20;
        int packLabelWidth = 50;
        if (IS_IPAD) {
            packageImageSize = 128;
            titleLabelFont = 28;
            deployImageSize = 72;
            descriptionLabelFont = 22;
            padding = 20;
            labelHeight = 40;
            packLabelWidth = 100;
        }
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, packageImageSize, packageImageSize)];
        iv.image = [UIImage imageNamed:@"package.png"];
        [self addSubview:iv];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + packageImageSize + padding, padding, self.frame.size.width - packageImageSize - deployImageSize - padding*4, labelHeight)];
        titleLabel.font = [UIFont systemFontOfSize:titleLabelFont];
        [self addSubview:titleLabel];
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(padding + packageImageSize + padding, padding + labelHeight, packLabelWidth, labelHeight)];
        label2.text = @"Pack Id :";
        label2.font = [UIFont systemFontOfSize:descriptionLabelFont];
        [self addSubview:label2];
        
        packIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + packageImageSize + padding + packLabelWidth, padding + labelHeight, packLabelWidth, labelHeight)];
        packIdLabel.font = [UIFont systemFontOfSize:descriptionLabelFont];
        [self addSubview:packIdLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding+packageImageSize, self.frame.size.width-padding*2, labelHeight)];
        descriptionLabel.font = [UIFont systemFontOfSize:descriptionLabelFont];
        [self addSubview:descriptionLabel];
        
        updateButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - deployImageSize - padding, padding*2, deployImageSize, deployImageSize)];
        [updateButton setImage:[UIImage imageNamed:@"deploy.png"] forState:UIControlStateNormal];
        //[updateButton setTitle:@"Deploy" forState:UIControlStateNormal];
        updateButton.titleLabel.textColor = [UIColor whiteColor];
        //updateButton.backgroundColor = [UIColor colorWithRed:112.0/255 green:173.0/255 blue:71.0/255 alpha:1];
        [self addSubview:updateButton];
        
        deployLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - deployImageSize - padding, padding*2+deployImageSize, deployImageSize, labelHeight)];
        deployLabel.font = [UIFont systemFontOfSize:descriptionLabelFont];
        deployLabel.text = @"Deploy";
        [self addSubview:deployLabel];
        
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
