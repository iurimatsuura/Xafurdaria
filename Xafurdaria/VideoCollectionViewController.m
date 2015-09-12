//
//  VideoCollectionViewController.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/12/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import "VideoCollectionViewController.h"
#import "HudUtility.h"
#import "VideoCollectionViewCell.h"

#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Item.h"
#import "Video.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Parent.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "BigTableViewCell.h"
#import "MFSideMenu.h"
#import "Flurry.h"
#import "UIViewController+ScrollingNavbar.h"
#import <CBZSplashView/CBZSplashView.h>
#import "Constants.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <ODRefreshControl/ODRefreshControl.h>
#import "SpinnerFooterReusableView.h"

static NSString* const kCellId = @"VideoCollectionCell";
static NSString* const kFooterId = @"SpinnerFooter";

@interface VideoCollectionViewController ()
{
    NSString *_nextPageToken;
    ODRefreshControl* _refreshControl;
    UIImageView* _scrollImageView;
}

@property (strong, nonatomic) HudUtility* hudUtility;
@property (strong, nonatomic)  NSArray *videoItems;

@end

@implementation VideoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.videoItems = [NSArray new];
    
    _nextPageToken = @"";
    
    [self refreshControlRequest];
    
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:self.collectionView];
    [_refreshControl setTintColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    [_refreshControl addTarget:self action:@selector(refreshControlRequest) forControlEvents:UIControlEventValueChanged];
    
    [self showActivityIndicator];
    
    self.hudUtility = [[HudUtility alloc]init];
    [self.hudUtility setHUDPropertiesWithView:self.collectionView];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.collectionView];
    
    [self createSplashView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

#pragma mark - Orientation change

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

#pragma mark - Activity Indicator

-(void)showActivityIndicator
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
//    self.collectionView.foo = spinner;
}

-(void)dismissActivityIndicator
{
//    self.tableView.tableFooterView = nil;
}

#pragma mark - Collection View DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoItems.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell* videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    
    Item* item = self.videoItems[indexPath.row];
    [videoCell updateCellWithItem:item];
    
    return videoCell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SpinnerFooterReusableView* footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterId forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Item* item = [self.videoItems objectAtIndex:indexPath.row];
    
    [self showVideoWithId:item.video.videoId];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.videoItems count] - 1)
        [self makeRequest];
}

#pragma mark HELPER - methods

-(void)showVideoWithId:(NSString*)videoId
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoId];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}

- (IBAction)showMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    
    [Flurry logEvent:@"MembersButton_Clicked"];
}

-(void)createSplashView
{
    UIImage *icon = [UIImage imageNamed:@"xafurdaria_logo_splash"];
    UIColor *color = [UIColor colorWithRed:0.996 green:0.761 blue:0.047 alpha:1.000];
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    splashView.animationDuration = 3.0;
    splashView.iconStartSize = CGSizeMake(180, 180);
    
    [self.view addSubview:splashView];
    [splashView startAnimation];
}

-(void)showScrollImage
{
    if (!_scrollImageView) {
        _scrollImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scroll"]];
    }
    
    _scrollImageView.frame = CGRectMake(0, 0, 128, 128);
    _scrollImageView.center = self.collectionView.center;
    [self.collectionView addSubview:_scrollImageView];
    [self.collectionView sendSubviewToBack:_scrollImageView];
}

-(void)hideScrollImage
{
    [_scrollImageView removeFromSuperview];
}

#pragma mark REQUEST - Methods

-(void)refreshControlRequest
{
    [[[RKObjectManager sharedManager]operationQueue]cancelAllOperations];
    
    [Flurry logEvent:@"Refresh_Control"];
    
    _nextPageToken = @"";
    
    self.videoItems = nil;
    
    self.videoItems = [NSArray arrayWithArray:[NSArray new]];
    
    [self.collectionView reloadData];
    
    [self makeRequest];
}

-(void)makeRequestFromNotification{
    
    [self showActivityIndicator];
    
    [[[RKObjectManager sharedManager]operationQueue]cancelAllOperations];
    
    [Flurry logEvent:@"PUSH_NOTIFICATION"];
    
    _nextPageToken = @"";
    
    [self.collectionView reloadData];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *playlistItemsUrl = [NSURL URLWithString:[NSString stringWithFormat:kPlaylistItemsUrl,_nextPageToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:playlistItemsUrl];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        
        _nextPageToken = rootJson.nextPageToken;
        
        self.videoItems = [NSArray arrayWithArray:rootJson.items];
        
        for (Item* itemAux in rootJson.items) {
            
            itemAux.video.videoId = itemAux.contentDetails.videoId;
            
            [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videoItems indexOfObject:itemAux]];
        }
        
        [self hideScrollImage];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_VideosIds_ERROR" message:error.description exception:nil];
        
        if (_nextPageToken != nil) {
            
            [self.hudUtility showCustomHudWithMessage:@"Falha" andDetailsMessage:@"Verifique sua conexão"];
        }
        [self dismissActivityIndicator];
        [_refreshControl endRefreshing];
        [self showScrollImage];
    }];
    
    [objectRequestOperation start];
}

-(void)makeRequest{
    
    [self showActivityIndicator];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:kPlaylistItemsUrl,_nextPageToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        
        _nextPageToken = rootJson.nextPageToken;
        
        self.videoItems = [self.videoItems arrayByAddingObjectsFromArray:rootJson.items];
        
        for (Item* itemAux in rootJson.items) {
            
            itemAux.video.videoId = itemAux.contentDetails.videoId;
            
            [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videoItems indexOfObject:itemAux]];
        }
        
        [self hideScrollImage];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_VideosIds_ERROR" message:error.description exception:nil];
        
        if (_nextPageToken != nil) {
            
            [self.hudUtility showCustomHudWithMessage:@"Falha" andDetailsMessage:@"Verifique sua conexão"];
        }
        [self dismissActivityIndicator];
        [_refreshControl endRefreshing];
        
        [self showScrollImage];
    }];
    
    [objectRequestOperation start];
}


-(void)makeRequestWithVideoId:(NSString*)videoID andPosition:(NSInteger)position{
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Video mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"items" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:kVideoUrl,videoID]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (mappingResult.array.count != 0) {
            
            Video* video = mappingResult.array[0];
            
            if (self.videoItems && position < self.videoItems.count) {
                
                Item* item = [self.videoItems objectAtIndex:position];
                item.video = video;
                
                [self.collectionView reloadData];
                [_refreshControl endRefreshing];
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
        [Flurry logError:@"Request_Single_Video_ERROR" message:error.description exception:nil];
        
    }];
    
    [objectRequestOperation start];
}

@end
