//
//  InfoViewController.h
//  Xafurdaria
//
//  Created by Iuri on 06/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
@interface InfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *members;

@property (strong, nonatomic)  Member *selectedMember;


@end
