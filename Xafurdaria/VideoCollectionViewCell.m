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

- (void)updateCellWithItem:(Item *)item
{
    self.videoImage.image = item.snippet.thumbnails.medium.image;
    
    self.videoName.text = item.snippet.title;
    self.videoDuration.text = [item.video.contentDetails correctDuration];
    self.videoViews.text = [NSString formatNumber:item.video.statistics.viewCount];
    [self.videoImage setImageWithURL:[NSURL URLWithString:item.snippet.thumbnails.medium.url] placeholderImage:nil];
    self.dateLabel.text = [item.snippet.publishedAt formatDateString];
}

@end
