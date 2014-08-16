//
//  NewVideoTableViewController.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 14/08/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ODRefreshControl.h"
#import "HudUtility.h"

@interface NewVideoTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate> {
    BOOL _firstTime;
    NSInteger _imageCount;
    NSString *_nextPageToken;
    ODRefreshControl* _refreshControl;
}

@property (strong, nonatomic) HudUtility* hudUtility;
@property (strong, nonatomic) CAGradientLayer* tableLayer;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *videos;
@property (strong, nonatomic)  NSMutableArray *videosIDs;

- (IBAction)showMenu:(id)sender;

@end
