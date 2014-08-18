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
#import "MyNavigationViewController.h"
#import "MFSideMenuContainerViewController.h"
#import <RestKit/RestKit.h>
#import "Parent.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setCustomComponentProperties];
    [self configureSideMenu];
    [self configureAppRiter];
    [self configureFlurry];
    
    [self setLastVideoFromUserDefaults];
    [self makeRequest];

    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // Get topmost/visible view controller
    UIViewController *currentViewController = [self topViewController];
    
    // Check whether it implements a dummy methods called canRotate
    if ([currentViewController respondsToSelector:@selector(canRotate)]) {
        // Unlock landscape view orientations for this view controller
        return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
    }
    
    // Only allow portrait (standard behaviour)
    return UIInterfaceOrientationMaskAll;
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    __block UIBackgroundTaskIdentifier updateLastVideo =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:updateLastVideo];
        updateLastVideo=UIBackgroundTaskInvalid;
    } ];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10*60
                                     target:self
                                   selector:@selector(makeRequest)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    [self.timer invalidate];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)sendNotificationWithVideoName:(NSString*)name;
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //    notification.fireDate = [NSDate date];
    notification.alertBody = [NSString stringWithFormat:@"Video Novo: %@",name];
    notification.applicationIconBadgeNumber++;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewVideoNotification
                                                            object:self];
    });
}

-(void)makeRequest{
        
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parent mapping] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet,contentDetails&maxResults=1&playlistId=UU21wUP_bie85msUyT3eJnew&key=AIzaSyA7-TdCyHBVFoGvp2oixemxDX72a_C0Xcs"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
   
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Parent* rootJson = [mappingResult.array objectAtIndex:0];
        Item* lastPostedVideo = [rootJson.items objectAtIndex:0];
        NSString* lastVideoId = lastPostedVideo.contentDetails.videoId;
        
        [self sendNotificationWithVideoName:lastPostedVideo.snippet.title];

        if (![self.lastVideo isEqualToString:lastVideoId]) {
            if (self.lastVideo) {
                [self sendNotificationWithVideoName:lastPostedVideo.snippet.title];
            }
            
            self.lastVideo = lastVideoId;

            [[NSUserDefaults standardUserDefaults] setValue:self.lastVideo forKey:@"lastVideoId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}

-(void)setLastVideoFromUserDefaults
{
    self.lastVideo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastVideoId"];
}


-(void)configureSideMenu
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
    
    UINavigationController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideViewController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    [container setCenterViewController:navigationController];
    
    [container setMenuSlideAnimationEnabled:YES];
    [container setMenuSlideAnimationFactor:9.0f];
    container.panMode = MFSideMenuPanModeCenterViewController;
}

-(void)configureAppRiter
{
    [Appirater setAppId:@"672131590"];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    [Appirater setDelegate:self];
}

-(void)appiraterDidDisplayAlert:(Appirater *)appirater
{
    [Flurry logEvent:@"RateAlert_Displayed"];
}

-(void)appiraterDidOptToRemindLater:(Appirater *)appirater
{
    [Flurry logEvent:@"RateAlert_RemindLater"];
}

-(void)appiraterDidOptToRate:(Appirater *)appirater
{
    [Flurry logEvent:@"RateAlert_Rated"];
}

-(void)appiraterDidDeclineToRate:(Appirater *)appirater
{
    [Flurry logEvent:@"RateAlert_DeclineRate"];
}

-(void)configureFlurry
{
    [Flurry setCrashReportingEnabled:YES];
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:@"5NK43V2CXF4QFF4RVSFM"];
}

-(void)setCustomComponentProperties
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:1.000 green:0.651 blue:0.000 alpha:1.000]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Komika Axis" size:20.0],
      NSFontAttributeName,
      nil]];
}


@end
