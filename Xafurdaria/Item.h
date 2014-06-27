//
//  Item.h
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentDetailsFirst.h"
#import <RestKit/RestKit.h>

@interface Item : NSObject

@property (nonatomic, strong) ContentDetailsFirst* contentDetails;

+(RKObjectMapping*)mapping;

@end
