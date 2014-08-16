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
#import <Appirater/Appirater.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setCustomComponentProperties];
    [self configureSideMenu];
    [self configureAppRiter];
    
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    [Appirater setDaysUntilPrompt:4];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:YES];
    [Appirater appLaunched:YES];
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
