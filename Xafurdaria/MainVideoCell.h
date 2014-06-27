//
//  MainVideoCellTableViewCell.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 27/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVideoCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic) IBOutlet UILabel *videoName;
@property (nonatomic) IBOutlet UILabel *videoDuration;
@property (nonatomic) IBOutlet UILabel *videoViews;
@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) IBOutlet UIView *containerInfoView;

- (void)playVideoWithId:(NSString *)videoId;

@end
