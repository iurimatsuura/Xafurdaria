//
//  ImageHigh.m
//  TV Palmeiras
//
//  Created by Iuri Matsuura on 18/07/14.
//  Copyright (c) 2014 Iuri Matsuura. All rights reserved.
//

#import "ImageHigh.h"

@implementation ImageHigh

+(RKObjectMapping*)mapping
{
    RKObjectMapping* highImageMapping = [RKObjectMapping mappingForClass:[ImageHigh class] ];
    [highImageMapping addAttributeMappingsFromArray:@[ @"url"]];
    
    return highImageMapping;
}

@end
