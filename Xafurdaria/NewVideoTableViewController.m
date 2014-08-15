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

@interface NewVideoTableViewController ()

@end

@implementation NewVideoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.videosIDs = [NSMutableArray new];
    self.videos = [NSMutableArray new];
    
    _nextPageToken = @"";
    
    [self makeRequest];
    
    _firstTime = YES;
    _imageCount = 0;
    
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [_refreshControl setTintColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    [_refreshControl addTarget:self action:@selector(refreshControlRequest) forControlEvents:UIControlEventValueChanged];
    
//    [self.tableView registerClass:[MainVideoCell class] forCellReuseIdentifier:@"MainVideoCell"];
    
    [self showActivityIndicator];
    
    self.hudUtility = [[HudUtility alloc]init];
    [self.hudUtility setHUDPropertiesWithView:self.tableView];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)canRotate { }


#pragma mark REQUEST - Methods

-(void)refreshControlRequest
{
    _nextPageToken = @"";
    _imageCount = 0;
    
    self.videosIDs = nil;
    self.videos = nil;
    
    self.videos = [NSMutableArray new];
    self.videosIDs = [NSMutableArray new];
    
    [self.tableView reloadData];
    
    [self makeRequest];
}

-(void)makeRequest{
    
    [self showActivityIndicator];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=10&pageToken=%@&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs",_nextPageToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Items: %@", mappingResult.array);
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        
        _nextPageToken = rootJson.nextPageToken;
        
        self.videosIDs = [NSMutableArray arrayWithArray:[self.videosIDs arrayByAddingObjectsFromArray:rootJson.items]];
        
        for (Item* itemAux in rootJson.items) {
            [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videosIDs indexOfObject:itemAux]];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        
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
        RKLogInfo(@"Load collection of Items: %@", mappingResult.array);
        
        
        if (mappingResult.array.count != 0) {
            Video* video = mappingResult.array[0];
            [self.videos addObject:video];
            
            if (self.videos.count == self.videosIDs.count) {
                [self sortVideosArray];
                [self.tableView reloadData];
                [_refreshControl endRefreshing];
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}

-(void)getImageWithUrl:(NSString*)urlImage ForVideoAtIndex:(NSInteger)position{
    
    NSURL *url = [NSURL URLWithString:urlImage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               
                                                                                               Video* video = [self.videos objectAtIndex:position];
                                                                                               video.snippet.thumbnails.medium.image = image;
                                                                                               _imageCount++;
                                                                                               
                                                                                               if (_imageCount == self.videosIDs.count) {
                                                                                                   [self sortVideosArray];
                                                                                               }
                                                                                               
                                                                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"%@",error);
                                                                                           }];
    [operation start];
    
}


#pragma mark TABLE VIEW - METHODS

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videos.count;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.videos count] - 1)
        [self makeRequest];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"VideoCell";
    BigTableViewCell *cell = (BigTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (self.videos.count != 0) {
        
        
        Video* video = [self.videos objectAtIndex:indexPath.row];
        cell.videoName.text = video.snippet.title;
        cell.videoDuration.text = [video.contentDetails correctDuration];
        cell.videoViews.text = [self formatNumber:video.statistics.viewCount];
        [cell.videoImage setImageWithURL:[NSURL URLWithString:video.snippet.thumbnails.high.url] placeholderImage:nil];
        cell.dateLabel.text = [self formatDateString:video.snippet.publishedAt];
        [cell.contentView bringSubviewToFront:cell.videoImage];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Video* video = [self.videos objectAtIndex:indexPath.row];
    
    [self showVideoWithId:video.videoId];
}

#pragma mark HELPER - methods

-(void)sortVideosArray{
    
    NSMutableArray* arrayAux = [NSMutableArray arrayWithArray:self.videos];
    
    for (Video* videoAux in arrayAux) {
        for (Item* itemAux in self.videosIDs) {
            if ([videoAux.videoId isEqualToString:itemAux.contentDetails.videoId]) {
                [self.videos exchangeObjectAtIndex:[self.videosIDs indexOfObject:itemAux] withObjectAtIndex:[self.videos indexOfObject:videoAux]];
            }
        }
    }
    
    [self.tableView reloadData];
}

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


@end
