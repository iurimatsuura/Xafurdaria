//
//  VideoCell.h
//  Putz vei
//
//  Created by Iuri on 19/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic) IBOutlet UILabel *videoName;
@property (nonatomic) IBOutlet UILabel *videoDuration;
@property (nonatomic) IBOutlet UILabel *videoViews;
@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) IBOutlet UIView *containerInfoView;


- (void)playVideoWithId:(NSString *)videoId;

@end
