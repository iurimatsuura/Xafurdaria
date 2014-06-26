//
//  CamisasViewController.m
//  Xafurdaria
//
//  Created by Iuri on 08/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "CamisasViewController.h"

@interface CamisasViewController ()

@end

@implementation CamisasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebUrl{
    NSString *fullURL = @"https://docs.google.com/forms/d/1WGFLAK0LzYy-ajmzkkJvoECiCmNXfNsD9euejManiy4/viewform?pli=1";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.hudUtility showLoadingHUD];
}

@end
