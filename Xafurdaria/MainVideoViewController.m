//
//  MainVideoViewController.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 27/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import "MainVideoViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Item.h"
#import "Video.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainVideoCell.h"

@interface MainVideoViewController ()

@end

@implementation MainVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.videosIDs = [NSMutableArray new];
    self.videos = [NSMutableArray new];
    
    [self makeRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    _firstTime = YES;
    _imageCount = 0;
    
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [_refreshControl setTintColor:[UIColor colorWithRed:0.89 green:0.109 blue:0.105 alpha:1.0]];
    [_refreshControl addTarget:self action:@selector(makeRequest) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[MainVideoCell class] forCellReuseIdentifier:@"MainVideoCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (_firstTime) {
        //        self.tableLayer = [CAGradientLayer layer];
        //        self.tableLayer.frame = self.tableView.bounds;
        //        self.tableLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.32 green:0.32 blue:0.34 alpha:1.0]CGColor], (id)[[UIColor whiteColor]CGColor], nil];
        //        self.tableLayer.locations = @[@0.2, @1.0];
        //
        //        UIView* view = [UIView new];
        //        [view.layer insertSublayer:self.tableLayer atIndex:1];
        //
        //        [self.tableView setBackgroundView:view];
        //
        //        _firstTime = NO;
    }
    
    
}


//-(BOOL) shouldAutorotate {
//    return NO;
//}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    self.tableLayer.frame = self.tableView.frame;
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.tableLayer.frame = self.tableView.frame;
    
}

#pragma mark REQUEST - Methods

-(void)makeRequest{
    
    [self.videos removeAllObjects];
    [self.videosIDs removeAllObjects];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Item mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"items" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id%2C+snippet%2C+contentDetails&maxResults=30&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Items: %@", mappingResult.array);
        
        self.videosIDs = [NSMutableArray arrayWithArray:mappingResult.array];
        
        for (Item* itemAux in self.videosIDs) {
            [self makeRequestWithVideoId:itemAux.contentDetails.videoId andPosition:[self.videosIDs indexOfObject:itemAux]];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
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
                [_refreshControl endRefreshing];
            }
            
            //            [self getImageWithUrl:video.snippet.thumbnails.medium.url ForVideoAtIndex:[self.videos indexOfObject:video]];
        }
        
        
        [self.tableView reloadData];
        
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
    //    cell.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.76 blue:0.78 alpha:1.0];
    //    cell.contentView.backgroundColor = [UIColor colorWithRed:0.32 green:0.32 blue:0.34 alpha:1.0];
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MainVideoCell";
    MainVideoCell *cell = (MainVideoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Video* video = [self.videos objectAtIndex:indexPath.row];
    cell.videoName.text = video.snippet.title;
    cell.videoDuration.text = [video.contentDetails correctDuration];
    cell.videoViews.text = [self formatNumber:video.statistics.viewCount];
    [cell.videoImage setImageWithURL:[NSURL URLWithString:video.snippet.thumbnails.medium.url] placeholderImage:nil];
    cell.webView.delegate = self;
    
    [cell.contentView bringSubviewToFront:cell.videoImage];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MainVideoCell* cell = (MainVideoCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    Video* video = [self.videos objectAtIndex:indexPath.row];
    
    NSLog(@"%@",video.videoId);
    [cell playVideoWithId:video.videoId];
}

#pragma mark YOUTUBE PLAYER - methods

-(void)youTubeStarted:(NSNotification *)notification{
    
}

-(void)youTubeFinished:(NSNotification *)notification{
    
    //    self.tableLayer.frame = self.tableView.frame;
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

-(NSString*)formatNumber:(NSNumber*)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    NSLog(@"%@",formattedNumberString);
    
    return formattedNumberString;
}

@end
