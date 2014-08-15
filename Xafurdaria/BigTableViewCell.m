//
//  BigTableViewCell.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 15/08/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import "BigTableViewCell.h"

@implementation BigTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
