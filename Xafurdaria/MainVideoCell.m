//
//  MainVideoCellTableViewCell.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 27/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import "MainVideoCell.h"

@implementation MainVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.videoName = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 56)];
        self.videoName.font = [UIFont fontWithName:@"Komika Axis" size:12.0];
        self.videoName.numberOfLines = 3;
        self.videoName.lineBreakMode = NSLineBreakByTruncatingTail;
        self.videoName.textAlignment = NSTextAlignmentCenter;
        
        self.videoImage = [UIImageView new];
        self.videoImage.frame = CGRectMake(0, 0, 160, 90);
        
        self.videoDuration = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 142, 21)];
        self.videoDuration.font = [UIFont systemFontOfSize:12];
        
        self.videoViews = [[UILabel alloc]initWithFrame:CGRectMake(93, 63, 65, 15)];
        self.videoViews.font = [UIFont systemFontOfSize:12];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(80, 45, 0, 0)];
        self.webView.mediaPlaybackRequiresUserAction = NO;
        
        self.timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clock"]];
        self.timeImageView.frame = CGRectMake(6, 65, 13, 12);
        self.viewsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eye"]];
        self.viewsImageView.frame = CGRectMake(74, 65, 13, 12);
        
        self.containerInfoView = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, 80)];
        [self.containerInfoView setBackgroundColor:[UIColor whiteColor]];
        [self.containerInfoView addSubview:self.videoName];
        [self.containerInfoView addSubview:self.videoDuration];
        [self.containerInfoView addSubview:self.videoViews];
        [self.containerInfoView addSubview:self.timeImageView];
        [self.containerInfoView addSubview:self.viewsImageView];
        
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [self.contentView addSubview:self.videoImage];
        [self.contentView addSubview:self.webView];
        [self.contentView addSubview:self.containerInfoView];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)playVideoWithId:(NSString *)videoId {
    
    self.webView.mediaPlaybackRequiresUserAction = NO;
    
    NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'0', height:'0', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>",videoId];
    
    
    [self.webView loadHTMLString:youTubeVideoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

@end
