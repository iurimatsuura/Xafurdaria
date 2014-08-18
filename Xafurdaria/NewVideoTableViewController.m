//
//  NewVideoTableViewController.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 14/08/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import "NewVideoTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Item.h"
#import "Video.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainVideoCell.h"
#import "Parent.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "BigTableViewCell.h"
#import "MFSideMenu.h"
#import "Flurry.h"
#import "UIViewController+ScrollingNavbar.h"
#import <CBZSplashView/CBZSplashView.h>
#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPClient.h>
@interface NewVideoTableViewController ()

@end

@implementation NewVideoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.videoItems = [NSArray new];
    
    _nextPageToken = @"";
    
    [self refreshControlRequest];
    
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [_refreshControl setTintColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    [_refreshControl addTarget:self action:@selector(refreshControlRequest) forControlEvents:UIControlEventValueChanged];
    
    [self showActivityIndicator];
    
    self.hudUtility = [[HudUtility alloc]init];
    [self.hudUtility setHUDPropertiesWithView:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(makeRequest2)
                                                 name:kNewVideoNotification
                                               object:nil];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 49, 0)];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.tableView];
    
    [self createSplashView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    
}

-(void)viewDidAppear:(BOOL)animated{
}

-(BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)canRotate { }

-(void)showActivityIndicator
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.tableView.tableFooterView = spinner;
}

-(void)dismissActivityIndicator
{
    self.tableView.tableFooterView = nil;
}

#pragma mark REQUEST - Methods

-(void)refreshControlRequest
{
    [[[RKObjectManager sharedManager]operationQueue]cancelAllOperations];
    
    [Flurry logEvent:@"Refresh_Control"];
    
    _nextPageToken = @"";

    self.videoItems = nil;
    
    self.videoItems = [NSArray arrayWithArray:[NSArray new]];
    
    [self.tableView reloadData];
    
    [self makeRequest];
}

-(void)makeRequest2{
    
    [self showActivityIndicator];
    
    [[[RKObjectManager sharedManager]operationQueue]cancelAllOperations];
    
    [Flurry logEvent:@"PUSH_NOTIFICATION"];
    
    _nextPageToken = @"";
    
    [self.tableView reloadData];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=10&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs&pageToken=%@",_nextPageToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        
        _nextPageToken = rootJson.nextPageToken;
        
        self.videoItems = [NSArray arrayWithArray:rootJson.items];
        
        for (Item* itemAux in rootJson.items) {
            
            itemAux.video.videoId = itemAux.contentDetails.videoId;
            
            [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videoItems indexOfObject:itemAux]];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_VideosIds_ERROR" message:error.description exception:nil];
        
        if (_nextPageToken != nil) {
            
            [self.hudUtility showCustomHudWithMessage:@"Falha" andDetailsMessage:@"Verifique sua conexão"];
        }
        [self dismissActivityIndicator];
        [_refreshControl endRefreshing];
    }];
    
    [objectRequestOperation start];
}

-(void)makeRequest{
    
    [self showActivityIndicator];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=10&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs&pageToken=%@",_nextPageToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        
        if (_nextPageToken != rootJson.nextPageToken) {
            _nextPageToken = rootJson.nextPageToken;
            
            self.videoItems = [self.videoItems arrayByAddingObjectsFromArray:rootJson.items];
            
            for (Item* itemAux in rootJson.items) {
                
                itemAux.video.videoId = itemAux.contentDetails.videoId;
                
                [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videoItems indexOfObject:itemAux]];
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_VideosIds_ERROR" message:error.description exception:nil];
        
        if (_nextPageToken != nil) {
            
            [self.hudUtility showCustomHudWithMessage:@"Falha" andDetailsMessage:@"Verifique sua conexão"];
        }
        [self dismissActivityIndicator];
        [_refreshControl endRefreshing];
    }];
    
    [objectRequestOperation start];
}


-(void)makeRequestWithVideoId:(NSString*)videoID andPosition:(NSInteger)position{
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Video mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"items" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?id=%@&part=snippet,contentDetails,statistics&fields=items&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs",videoID]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (mappingResult.array.count != 0) {
            
            Video* video = mappingResult.array[0];
            
            if (self.videoItems && position < self.videoItems.count) {
                
                Item* item = [self.videoItems objectAtIndex:position];
                item.video = video;
                
                [self.tableView reloadData];
                [_refreshControl endRefreshing];
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_Single_Video_ERROR" message:error.description exception:nil];

    }];
    
    [objectRequestOperation start];
}


#pragma mark TABLE VIEW - METHODS

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videoItems.count;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.videoItems count] - 1)
        [self makeRequest];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"VideoCell";
    BigTableViewCell *cell = (BigTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.videoItems.count != 0) {
        
        Item* item = [self.videoItems objectAtIndex:indexPath.row];
        
        cell.videoName.text = item.snippet.title;
        cell.videoDuration.text = [item.video.contentDetails correctDuration];
        cell.videoViews.text = [self formatNumber:item.video.statistics.viewCount];
        [cell.videoImage setImageWithURL:[NSURL URLWithString:item.snippet.thumbnails.high.url] placeholderImage:nil];
        cell.dateLabel.text = [self formatDateString:item.snippet.publishedAt];
        
        [cell.contentView bringSubviewToFront:cell.videoImage];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Item* item = [self.videoItems objectAtIndex:indexPath.row];
    
    [self showVideoWithId:item.video.videoId];
}

#pragma mark HELPER - methods

-(void)showVideoWithId:(NSString*)videoId
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoId];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}

-(NSString*)formatNumber:(NSNumber*)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    
    return formattedNumberString;
}

-(NSString*)formatDateString:(NSString*)dateString
{
    NSString *year = [dateString substringToIndex:4];
    NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateString substringWithRange:NSMakeRange(8, 2)];
    
    NSString* date = [NSString stringWithFormat:@"%@/%@/%@",day,month,year];
    
    return date;
}

- (IBAction)showMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    
    [Flurry logEvent:@"MembersButton_Clicked"];
}

-(void)createSplashView
{
    UIImage *icon = [UIImage imageNamed:@"xafurdaria_logo_splash"];
    UIColor *color = [UIColor colorWithRed:0.996 green:0.761 blue:0.047 alpha:1.000];
    CBZSplashView *splashView = [[CBZSplashView alloc]initWithIcon:icon backgroundColor:color];
    splashView.animationDuration = 3.0;
    splashView.iconStartSize = CGSizeMake(180, 180);
    
    [self.view addSubview:splashView];
    [splashView startAnimation];
}

-(void)connectionStatus
{
    RKObjectManager* manager = [RKObjectManager sharedManager];
//    
//    [manager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status == AFNetworkReachabilityStatusNotReachable) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
//                                                            message:@"You must be connected to the internet to use this app."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//    }];

}

@end
