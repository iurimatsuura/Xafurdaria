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
    
    RKObjectMapping* itemMapping = [Item mapping];
    
    RKObjectMapping* parentMapping = [RKObjectMapping mappingForClass:[Parent class] ];
    [parentMapping addAttributeMappingsFromDictionary:@{
                        @"nextPageToken": @"nextPageToken"                              
                                                      }];
    
    // Define the relationship mapping
    [parentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"                                                                                toKeyPath:@"items"                                                                              withMapping:itemMapping]];
    
    return parentMapping;
}


@end
