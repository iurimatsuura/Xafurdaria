//
//  Item.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Item.h"

@implementation Item

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[ContentDetailsFirst class] ];
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    [contentMapping addAttributeMappingsFromArray:@[ @"videoId"]];
    
    // Now configure the Article mapping
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Item class] ];
    [itemMapping addAttributeMappingsFromDictionary:@{
     
     }];
    
    // Define the relationship mapping
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contentDetails"
                                                                                   toKeyPath:@"contentDetails"
                                                                                 withMapping:contentMapping]];
    
    return itemMapping;
}


@end
