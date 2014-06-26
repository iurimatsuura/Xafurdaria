//
//  MemberCell.m
//  Xafurdaria
//
//  Created by Iuri on 06/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(92, 23, 159, 21)];
        self.nameLabel.font = [UIFont fontWithName:@"Komika Axis" size:14];
        
        self.memberImageView = [UIImageView new];
        self.memberImageView.frame = CGRectMake(0, 0, 84, 67);
        
        self.faceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(267, 18, 33, 34)];
        [self.faceIcon setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.memberImageView];
        [self.contentView addSubview:self.faceIcon];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
