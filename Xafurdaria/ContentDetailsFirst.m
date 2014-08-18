//
//  ContentDetailsFirst.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "ContentDetailsFirst.h"

@implementation ContentDetailsFirst


+(RKObjectMapping*)mapping
{
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[ContentDetailsFirst class] ];
    [contentMapping addAttributeMappingsFromArray:@[ @"videoId"]];
    
    return contentMapping;
}

@end
