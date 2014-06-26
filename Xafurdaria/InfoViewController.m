//
//  InfoViewController.m
//  Xafurdaria
//
//  Created by Iuri on 06/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "InfoViewController.h"
#import "MemberCell.h"
#import "ProfileViewController.h"
@interface InfoViewController ()

@end

@implementation InfoViewController

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
    
    [self.tableView registerClass:[MemberCell class] forCellReuseIdentifier:@"MemberCell"];
    
    [self createMembers];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,32)];
    title.text = @"Xafurdaria";
    title.font = [UIFont fontWithName:@"Komika Axis" size:18.0];
    title.textAlignment = NSTextAlignmentCenter;
    [title setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = title;
    
    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.members.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MemberCell";
    MemberCell *cell = (MemberCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Member* member = self.members[indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.memberImageView.image = member.picture;
    cell.faceIcon.image = [UIImage imageNamed:@"facebook"];
    cell.nameLabel.text = member.name;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedMember = self.members[indexPath.row];
    
    ProfileViewController* profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VC"];
    profileVC.urlName = self.selectedMember.profile;
    [self.navigationController pushViewController:profileVC animated:YES];
}


-(void)createMembers{
    
    Member* kaio = [[Member alloc]initWithName:@"Kaio Oliveira" Profile:@"https://www.facebook.com/kaiooliveiras" Picture:[UIImage imageNamed:@"kaio"]];
    Member* end = [[Member alloc]initWithName:@"End" Profile:@"https://www.facebook.com/endersonbritoo" Picture:[UIImage imageNamed:@"end.JPG"]];
    Member* moa = [[Member alloc]initWithName:@"Moa" Profile:@"https://www.facebook.com/moacir.neto.18" Picture:[UIImage imageNamed:@"moa.JPG"]];
    Member* leo = [[Member alloc]initWithName:@"Leonan" Profile:@"https://www.facebook.com/LeonanPinheiro" Picture:[UIImage imageNamed:@"leo.JPG"]];
    Member* ravy = [[Member alloc]initWithName:@"Ravy" Profile:@"https://www.facebook.com/ravy.soares.1" Picture:[UIImage imageNamed:@"ravy.JPG"]];
    Member* saulo = [[Member alloc]initWithName:@"Saulo" Profile:@"https://www.facebook.com/SaulinhoSoul" Picture:[UIImage imageNamed:@"saulo.JPG"]];
    Member* plinio = [[Member alloc]initWithName:@"Plinio" Profile:@"https://www.facebook.com/plinio.barbosa3" Picture:[UIImage imageNamed:@"plinio.JPG"]];
    Member* miguel = [[Member alloc]initWithName:@"Miguel" Profile:@"https://www.facebook.com/miguel.gomes.7906" Picture:[UIImage imageNamed:@"miguel.JPG"]];

    self.members = [[NSMutableArray alloc]initWithObjects:kaio,end,moa,leo,ravy,saulo,plinio,miguel, nil];

}

@end
