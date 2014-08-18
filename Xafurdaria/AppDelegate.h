//
//  AppDelegate.h
//  Xafurdaria
//
//  Created by Iuri on 05/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Appirater/Appirater.h>

#define kNewVideoNotification @"kNewVideoNotification"

@interface AppDelegate : UIResponder <AppiraterDelegate,UIApplicationDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* lastVideo;
@property (strong, nonatomic) NSTimer* timer;

@end
