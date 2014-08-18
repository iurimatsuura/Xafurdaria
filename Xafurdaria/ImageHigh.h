//
//  ImageHigh.h
//  TV Palmeiras
//
//  Created by Iuri Matsuura on 18/07/14.
//  Copyright (c) 2014 Iuri Matsuura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ImageHigh : NSObject

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) UIImage* image;

+(RKObjectMapping*)mapping;

@end
