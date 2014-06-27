//
//  AppDelegate.m
//  Xafurdaria
//
//  Created by Iuri on 05/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [self setCustomComponentProperties];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"Vinheta" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    
    player.delegate = self;
    [player setVolume: 1.0];    // available range is 0.0 through 1.0
//    [player play];
    
//    sleep([self getAudioDuration]+1);


    // IMPORTAAAAAAANT!!
    // GET ALL XAFURDARIA VIDEOS URL
    //NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id%2C+snippet%2C+contentDetails&maxResults=30&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs"];
    // Channel id = UC21wUP_bie85msUyT3eJnew
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setCustomComponentProperties{
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Komika Axis" size:18.0],
      NSFontAttributeName,
      nil]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor],
                                                       NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.99 green:0.75 blue:0.03 alpha:1.0]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Komika Axis" size:10.0],NSFontAttributeName,nil]forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Komika Axis" size:8.0],NSFontAttributeName ,nil] forState:UIControlStateNormal];

}


-(float)getAudioDuration{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"Vinheta" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

@end
