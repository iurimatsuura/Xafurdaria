//
//  VideoCell.m
//  Putz vei
//
//  Created by Iuri on 19/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.videoName = [[UILabel alloc]initWithFrame:CGRectMake(173, 5, 142, 39)];
        self.videoName.font = [UIFont fontWithName:@"Komika Axis" size:8.0];
        
        self.videoImage = [UIImageView new];
        self.videoImage.frame = CGRectMake(0, 0, 160, 95);
        
        self.videoDuration = [[UILabel alloc]initWithFrame:CGRectMake(173, 20, 142, 21)];
        
        self.videoViews = [[UILabel alloc]initWithFrame:CGRectMake(173, 68, 142, 21)];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(80, 45, 0, 0)];
        self.webView.mediaPlaybackRequiresUserAction = NO;

        
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [self.contentView addSubview:self.videoName];
        [self.contentView addSubview:self.videoImage];
        [self.contentView addSubview:self.videoDuration];
        [self.contentView addSubview:self.videoViews];
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
