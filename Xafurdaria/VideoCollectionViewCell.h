//
//  VideoCollectionViewCell.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/12/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface VideoCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic) IBOutlet UILabel *videoName;
@property (nonatomic) IBOutlet UILabel *videoDuration;
@property (nonatomic) IBOutlet UILabel *videoViews;
@property (nonatomic) IBOutlet UIImageView *timeImageView;
@property (nonatomic) IBOutlet UIImageView *viewsImageView;
@property (nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) IBOutlet UIImageView *dateImageView;

- (void)updateCellWithItem:(Item*)item;

@end
