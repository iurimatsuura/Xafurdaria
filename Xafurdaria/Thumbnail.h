//
//  Thumbnail.h
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMedium.h"
#import <RestKit/RestKit.h>
#import "ImageHigh.h"

@interface Thumbnail : NSObject

@property (nonatomic, strong) ImageMedium* medium;
@property (nonatomic, strong) ImageHigh* high;

@end
