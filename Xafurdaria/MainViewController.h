//
//  X2VideosViewController.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 26/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "VideoCell.h"
#import <RestKit/RestKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ODRefreshControl.h"

@interface MainViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate> {
    BOOL _firstTime;
    NSInteger _imageCount;
    ODRefreshControl* _refreshControl;
}

@property (strong, nonatomic) CAGradientLayer* tableLayer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *videos;
@property (strong, nonatomic)  NSMutableArray *videosIDs;

@end
