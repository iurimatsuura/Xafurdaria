//
//  ProfileViewController.m
//  Xafurdaria
//
//  Created by Iuri on 08/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    NSString* titleName = @"Perfil";
    CGSize titleSize = [titleName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Komika Axis" size:18]}];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0,titleSize.width,32)];
    title.text = titleName;
    title.font = [UIFont fontWithName:@"Komika Axis" size:18.0];
    title.textAlignment = NSTextAlignmentCenter;
    [title setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = title;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadWebUrl{
    NSString *fullURL = self.urlName;
    NSLog(@"%@",fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.hudUtility showLoadingHUD];
}

@end
