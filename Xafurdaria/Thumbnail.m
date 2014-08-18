//
//  Thumbnail.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "Thumbnail.h"

@implementation Thumbnail

+(RKObjectMapping*)mapping{
    
    RKObjectMapping* thumbMapping = [RKObjectMapping mappingForClass:[Thumbnail class] ];
    
    [thumbMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"medium"                                                                                 toKeyPath:@"medium"                                                                               withMapping:[ImageMedium mapping]]];
    
    [thumbMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"maxres"                                                                                 toKeyPath:@"high"                                                                               withMapping:[ImageHigh mapping]]];
    
    return thumbMapping;
}

@end
