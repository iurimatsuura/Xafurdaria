//
//  Parent.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 28/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//

#import "Parent.h"

@implementation Parent

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Item class] ];
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[ContentDetailsFirst class] ];
    [contentMapping addAttributeMappingsFromArray:@[ @"videoId"]];
    
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contentDetails"
                                                                                   toKeyPath:@"contentDetails"
                                                                                 withMapping:contentMapping]];
    
    RKObjectMapping* parentMapping = [RKObjectMapping mappingForClass:[Parent class] ];
    [parentMapping addAttributeMappingsFromDictionary:@{
                        @"nextPageToken": @"nextPageToken"                              
                                                      }];
    
    // Define the relationship mapping
    [parentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                toKeyPath:@"items"
                                                                              withMapping:itemMapping]];
    
    return parentMapping;
}


@end
