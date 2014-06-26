//
//  SecondViewController.m
//  Xafurdaria
//
//  Created by Iuri on 05/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "FanpageViewController.h"

@interface FanpageViewController ()

@end

@implementation FanpageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebUrl{
    NSString *fullURL = @"https://www.facebook.com/XafurdariaOficial?fref=ts";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.hudUtility showLoadingHUD];
}
@end
