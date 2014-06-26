//
//  Member.h
//  Xafurdaria
//
//  Created by Iuri on 08/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (nonatomic, strong) NSString* profile;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) UIImage* picture;

-(Member*)initWithName:(NSString*)name Profile:(NSString*)profile Picture:(UIImage*)picture;


@end
