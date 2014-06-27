//
//  Snippet.h
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Thumbnail.h"

@interface Snippet : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* publishedAt;

@property (nonatomic, strong) Thumbnail* thumbnails;



@end
