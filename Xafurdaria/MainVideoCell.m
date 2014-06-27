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
        
        self.videoName = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 160, 56)];
        self.videoName.font = [UIFont fontWithName:@"Komika Axis" size:8.0];
        self.videoName.textAlignment = NSTextAlignmentCenter;
        
        self.videoImage = [UIImageView new];
        self.videoImage.frame = CGRectMake(0, 0, 160, 95);
        
        self.videoDuration = [[UILabel alloc]initWithFrame:CGRectMake(20, 63, 142, 21)];
        
        self.videoViews = [[UILabel alloc]initWithFrame:CGRectMake(173, 68, 142, 21)];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(80, 45, 0, 0)];
        self.webView.mediaPlaybackRequiresUserAction = NO;
        
        self.containerInfoView = [[UIView alloc]initWithFrame:CGRectMake(160, 10, 160, 80)];
        [self.containerInfoView setBackgroundColor:[UIColor whiteColor]];
        [self.containerInfoView addSubview:self.videoName];
        [self.containerInfoView addSubview:self.videoDuration];
        [self.containerInfoView addSubview:self.videoViews];
        
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
