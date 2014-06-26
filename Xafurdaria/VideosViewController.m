//
//  FirstViewController.m
//  Xafurdaria
//
//  Created by Iuri on 05/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "VideosViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface VideosViewController ()

@end

@implementation VideosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebUrl{
    
    NSString *fullURL = @"http://www.youtube.com/user/xafurdariaoficial";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.hudUtility showLoadingHUD];
}

@end
