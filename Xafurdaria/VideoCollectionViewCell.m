//
//  VideoCollectionViewCell.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/12/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "Item.h"
#import "NSString+Formatter.h"

@implementation VideoCollectionViewCell


- (void)awakeFromNib
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.durationContainerView.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    layer.path = shadowPath.CGPath;
    self.durationContainerView.layer.mask = layer;
    
    self.likeImageView.image = [self.likeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dislikeImageView.image = [self.dislikeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.viewsImageView.image = [self.viewsImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dateImageView.image = [self.dateImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)updateCellWithItem:(Item *)item
{
    self.videoImage.image = item.snippet.thumbnails.medium.image;
    
    self.videoName.text = item.snippet.title;
    self.videoDuration.text = [item.video.contentDetails correctDuration];
    self.videoViews.text = [NSString formatNumber:item.video.statistics.viewCount];
    [self.videoImage setImageWithURL:[NSURL URLWithString:item.snippet.thumbnails.medium.url] placeholderImage:nil];
    self.dateLabel.text = [item.snippet.publishedAt formatDateString];
    
    self.likeCount.text = item.video.statistics.likeCount.stringValue;
    self.dislikeCount.text = item.video.statistics.dislikeCount.stringValue;
}

@end
