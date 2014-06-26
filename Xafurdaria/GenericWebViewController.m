//
//  GenericWebViewController.m
//  Xafurdaria
//
//  Created by Iuri on 10/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "GenericWebViewController.h"

@interface GenericWebViewController ()

@end

@implementation GenericWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.hudUtility = [[HudUtility alloc]init];
    [self.hudUtility setHUDPropertiesWithView:self.webView];
    
    self.webView.delegate = self;
    
    [self loadWebUrl];
    
    [self createPullToRefreshViewWithView:self.webView.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hudUtility showDoneHuding];
    [pullView finishedLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self.hudUtility showCustomHudWithMessage:@"Falha" andDetailsMessage:@"Verifique sua conexão"];
    [pullView finishedLoading];
    
}

-(void)loadWebUrl{

}

-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    
    [self loadWebUrl];
    
}

-(void)createPullToRefreshViewWithView:(UIScrollView*)containerView{
    if (!pullView) {
        pullView = [[PullToRefreshView alloc] initWithScrollView:containerView];
        [pullView setDelegate:self];
        [containerView addSubview:pullView];
    }
    
    [pullView finishedLoading];
    
}

@end
