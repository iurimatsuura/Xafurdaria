//
//  Snippet.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Snippet.h"
#import "Thumbnail.h"

@implementation Snippet

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* snippetMapping = [RKObjectMapping mappingForClass:[Snippet class           ]];
    
    [snippetMapping addAttributeMappingsFromArray:@[ @"title",@"publishedAt"]];
    
    [snippetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnails"
                                                                                   toKeyPath:@"thumbnails"
                                                                                 withMapping:[Thumbnail mapping]]];
    
    return snippetMapping;
}
@end
