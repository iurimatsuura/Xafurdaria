//
//  FirstViewController.h
//  Xafurdaria
//
//  Created by Iuri on 05/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericWebViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface VideosViewController : GenericWebViewController {
    MPMoviePlayerController *_player;
    BOOL _firstCall;
}
@property (weak, nonatomic) IBOutlet UIView *moviewView;

@end
