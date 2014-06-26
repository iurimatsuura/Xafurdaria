//
//  GenericWebViewController.h
//  Xafurdaria
//
//  Created by Iuri on 10/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HudUtility.h"
#import "PullToRefreshView.h"

@interface GenericWebViewController : UIViewController <UIWebViewDelegate,PullToRefreshViewDelegate>{
    PullToRefreshView *pullView;
    
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) HudUtility* hudUtility;

-(void)loadWebUrl;

@end
