//
//  Thumbnail.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Thumbnail.h"

@implementation Thumbnail

-(void)mapping{
    
    RKObjectMapping* imageMapping = [RKObjectMapping mappingForClass:[ImageMedium class] ];
    
    RKObjectMapping* highImageMapping = [RKObjectMapping mappingForClass:[ImageHigh class] ];
    
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    [imageMapping addAttributeMappingsFromArray:@[ @"url"]];
    
    // Now configure the Article mapping
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Thumbnail class] ];
    [itemMapping addAttributeMappingsFromDictionary:@{
                                                      
                                                      }];
    
    // Define the relationship mapping
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"medium"
                                                                                toKeyPath:@"imageMedium"
                                                                              withMapping:imageMapping]];
    
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"high"
                                                                                toKeyPath:@"imageHigh"
                                                                              withMapping:highImageMapping]];
}

@end
