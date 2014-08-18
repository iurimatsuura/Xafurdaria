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
    
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Item class]];
    
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contentDetails"                                                                                toKeyPath:@"contentDetails"                                                                              withMapping:[ContentDetailsFirst mapping]]];
    
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet"                                                                                toKeyPath:@"snippet"                                                                              withMapping:[Snippet mapping]]];
    
    return itemMapping;
}


@end
