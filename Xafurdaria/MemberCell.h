//
//  MemberCell.h
//  Xafurdaria
//
//  Created by Iuri on 06/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *memberImageView;
@property (nonatomic) IBOutlet UIImageView *faceIcon;
@property (strong, nonatomic)  UILabel *nameLabel;

@property (strong, nonatomic) UILabel *mainLabel;

@end
