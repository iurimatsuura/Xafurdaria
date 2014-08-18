//
//  ImageMedium.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "ImageMedium.h"

@implementation ImageMedium

+(RKObjectMapping*)mapping
{
    RKObjectMapping* imageMapping = [RKObjectMapping mappingForClass:[ImageMedium class] ];
    [imageMapping addAttributeMappingsFromArray:@[ @"url"]];
    
    return imageMapping;
}
@end
