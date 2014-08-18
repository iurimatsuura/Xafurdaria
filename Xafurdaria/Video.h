//
//  Video.h
//  Putz Vei
//
//  Created by Iuri on 25/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "Snippet.h"
#import "ContentDetailsVideo.h"
#import "Statistics.h"
#import "Thumbnail.h"
#import "ImageMedium.h"

@interface Video : NSObject

@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) ContentDetailsVideo *contentDetails;
@property (nonatomic, retain) Statistics *statistics;

+(RKObjectMapping*)mapping;

@end
