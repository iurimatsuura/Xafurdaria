//
//  ViewController.h
//  4FitClub Tv
//
//  Created by Iuri Matsuura on 26/07/14.
//  Copyright (c) 2014 Woerk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSideViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate>
{
    NSMutableArray* _socialImages;
    NSMutableArray* _membersNames;
    BOOL pageControlBeingUsed;
}
@property (strong, nonatomic) NSDictionary* members;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)changePage:(id)sender;
@end
