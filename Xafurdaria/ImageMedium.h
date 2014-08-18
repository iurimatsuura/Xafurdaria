//
//  ImageMedium.h
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ImageMedium : NSObject

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) UIImage* image;

+(RKObjectMapping*)mapping;

@end
