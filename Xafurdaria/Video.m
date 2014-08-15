//
//  Video.m
//  Putz Vei
//
//  Created by Iuri on 25/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Video.h"
#import "Snippet.h"
#import "ContentDetailsVideo.h"
#import "Statistics.h"
#import "Thumbnail.h"
#import "ImageMedium.h"
#import "ImageHigh.h"

@implementation Video
//
//@dynamic videoId;
//@dynamic hasSnippet;
//@dynamic hasContent;
//@dynamic hasStat;

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* snippetMapping = [RKObjectMapping mappingForClass:[Snippet class] ];
    [snippetMapping addAttributeMappingsFromArray:@[ @"title",@"publishedAt"]];
    
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[ContentDetailsVideo class] ];
    [contentMapping addAttributeMappingsFromArray:@[ @"duration"]];
    
    RKObjectMapping* statMapping = [RKObjectMapping mappingForClass:[Statistics class] ];
    [statMapping addAttributeMappingsFromArray:@[ @"viewCount"]];
    
    
    
    RKObjectMapping* thumbMapping = [RKObjectMapping mappingForClass:[Thumbnail class] ];
    
    RKObjectMapping* imageMapping = [RKObjectMapping mappingForClass:[ImageMedium class] ];
    [imageMapping addAttributeMappingsFromArray:@[ @"url"]];
    
    
    [thumbMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"medium"
                                                                                 toKeyPath:@"medium"
                                                                               withMapping:imageMapping]];
    
    RKObjectMapping* highImageMapping = [RKObjectMapping mappingForClass:[ImageHigh class] ];
    [highImageMapping addAttributeMappingsFromArray:@[ @"url"]];
    
    
    [thumbMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"maxres"
                                                                                 toKeyPath:@"high"
                                                                               withMapping:highImageMapping]];
    
    [snippetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnails"
                                                                                   toKeyPath:@"thumbnails"
                                                                                 withMapping:thumbMapping]];
    
    // Now configure the Article mapping
    RKObjectMapping* videoMapping = [RKObjectMapping mappingForClass:[Video class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"videoId"
                                                       }];
    
    // Define the relationship mapping
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet"
                                                                                 toKeyPath:@"snippet"
                                                                               withMapping:snippetMapping]];
    
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contentDetails"
                                                                                 toKeyPath:@"contentDetails"
                                                                               withMapping:contentMapping]];
    
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"statistics"
                                                                                 toKeyPath:@"statistics"
                                                                               withMapping:statMapping]];
    
    return videoMapping;
    
}

@end
