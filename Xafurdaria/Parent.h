//
//  Parent.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 28/06/14.
//  Copyright (c) 2014 Iuri Mac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Item.h"
#import "ContentDetailsFirst.h"
#import <RestKit/RestKit.h>

@interface Parent : NSObject

@property (nonatomic, strong) NSArray* items;

@property (nonatomic, strong) NSString* nextPageToken;

+(RKObjectMapping*)mapping;

@end
