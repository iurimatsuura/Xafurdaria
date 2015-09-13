//
//  Video.m
//  Putz Vei
//
//  Created by Iuri on 25/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Video.h"
#import "ContentDetailsVideo.h"
#import "Statistics.h"
#import "Thumbnail.h"
#import "ImageMedium.h"
#import "ImageHigh.h"

@implementation Video

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[ContentDetailsVideo class] ];
    [contentMapping addAttributeMappingsFromArray:@[ @"duration"]];
    
    RKObjectMapping* statMapping = [RKObjectMapping mappingForClass:[Statistics class] ];
    [statMapping addAttributeMappingsFromArray:@[@"viewCount", @"likeCount", @"dislikeCount"]];
   
    
    // Now configure the Article mapping
    RKObjectMapping* videoMapping = [RKObjectMapping mappingForClass:[Video class]];
    [videoMapping addAttributeMappingsFromDictionary:@{@"id": @"videoId"}];
    
    // Define the relationship mapping
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contentDetails"                                                                                 toKeyPath:@"contentDetails"                                                                               withMapping:contentMapping]];
    
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"statistics"                                                                                toKeyPath:@"statistics"                                                                               withMapping:statMapping]];
    
    return videoMapping;
    
}

@end
