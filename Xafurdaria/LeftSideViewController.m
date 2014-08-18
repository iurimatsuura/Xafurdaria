//
//  ViewController.m
//  4FitClub Tv
//
//  Created by Iuri Matsuura on 26/07/14.
//  Copyright (c) 2014 Woerk. All rights reserved.
//

#import "LeftSideViewController.h"
#import "MFSideMenu.h"
#import "SocialCell.h"
#import "Flurry.h"

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.members = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"members" ofType:@"plist"]];
    
    _membersNames = [[NSMutableArray alloc]initWithObjects:@"kaio", @"enderson",@"leonan",@"moa",@"saulo", nil];
    _socialImages = [[NSMutableArray alloc]initWithObjects:@"insta",@"face",@"twitter", nil];
    
    self.pageControl.numberOfPages = [[self.members allKeys]count];
    
    [self createMembersScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *URL;
    
    NSString* memberKey = [_membersNames objectAtIndex:self.pageControl.currentPage];
    NSDictionary* member = [self.members objectForKey: memberKey];
    
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [member objectForKey:@"Name"], @"Member",
                                   nil];
    
    if (indexPath.row == 0) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@", [member objectForKey:@"Instagram"]]];
        
        [Flurry logEvent:@"Instagram_Clicked" withParameters:articleParams];
    }
    else if(indexPath.row == 1)
    {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", [member objectForKey:@"Facebook"]]];
        
        [Flurry logEvent:@"Facebook_Clicked" withParameters:articleParams];
    }
    else{
        if ([[member objectForKey:@"Twitter"] isEqualToString:@""]) {
            [self showNoAppSocialAlert:@"Twitter"];
            
            return;
        }
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", [member objectForKey:@"Twitter"]]];
        
        [Flurry logEvent:@"Twitter_Clicked" withParameters:articleParams];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
    else{
        [self showNoAppAlertView];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SocialCell *cell = (SocialCell*)[tableView dequeueReusableCellWithIdentifier:@"SocialCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialCell"];
    }
    
    NSString* memberKey = [_membersNames objectAtIndex:self.pageControl.currentPage];
    NSDictionary* member = [self.members objectForKey: memberKey];
    
    if (indexPath.row == 0) {
        cell.profileName.text = [NSString stringWithFormat:@"@%@",[member objectForKey:@"Instagram"]];
    }
    else if (indexPath.row == 1)
    {
        cell.profileName.text = [NSString stringWithFormat:@"/%@",[member objectForKey:@"FaceProfile"]];
    }
    else {
        if (![[member objectForKey:@"Twitter"] isEqualToString:@""]) {
            cell.profileName.text = [NSString stringWithFormat:@"@%@",[member objectForKey:@"Twitter"]];
        }
        else{
            cell.profileName.text = @"";
        }
    }
    
    cell.socialImageLogo.image = [UIImage imageNamed:[_socialImages objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)showNoAppAlertView
{
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Desculpe"
                                                       message:@"Aplicaçao nao encontrada neste dispositivo"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

-(void)showNoAppSocialAlert:(NSString*)socialMedia
{
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Desculpe"
                                                       message:[NSString stringWithFormat:@"Membro sem %@",socialMedia]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

-(void)createMembersScrollView
{
    for (int i = 0; i < [self.members allKeys].count; i++) {
        
        NSString* memberKey = [_membersNames objectAtIndex:i];
        
        NSDictionary* member = [self.members objectForKey:memberKey];
        
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [UIColor whiteColor];
        
        UIImageView* profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 100, 100)];
        
        profileImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        profileImageView.image = [UIImage imageNamed:memberKey];
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.cornerRadius = 50.0;
        profileImageView.layer.borderColor = [UIColor colorWithRed:0.996 green:0.860 blue:0.047 alpha:1.000].CGColor;
        profileImageView.layer.borderWidth = 3.0f;
        profileImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        profileImageView.layer.shouldRasterize = YES;
        profileImageView.clipsToBounds = YES;
        
        [subview addSubview:profileImageView];
        
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(41, 135, 198, 21)];
        nameLabel.textColor = [UIColor colorWithRed:0.996 green:0.857 blue:0.047 alpha:1.000];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21];
        nameLabel.text = [member objectForKey:@"Name"];
        
        [subview addSubview:nameLabel];
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.members allKeys].count, self.scrollView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self.tableView reloadData];
}


-(BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)canRotate { }

- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    [self.tableView reloadData];
    
    pageControlBeingUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
@end
