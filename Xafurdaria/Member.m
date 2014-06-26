//
//  Member.m
//  Xafurdaria
//
//  Created by Iuri on 08/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Member.h"

@implementation Member

-(Member*)initWithName:(NSString*)name Profile:(NSString*)profile Picture:(UIImage*)picture{
    self.name = name;
    self.profile = profile;
    self.picture = picture;
    return self;
}

@end
