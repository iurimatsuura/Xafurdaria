//
//  NSString+Formatter.h
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/12/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Formatter)

- (NSString*)formatDateString;
+ (NSString*)formatNumber:(NSNumber*)number;

@end
