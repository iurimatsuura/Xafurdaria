//
//  NSString+Formatter.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/12/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import "NSString+Formatter.h"

@implementation NSString (Formatter)

- (NSString*)formatDateString
{
    NSString *year = [self substringToIndex:4];
    NSString *month = [self substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [self substringWithRange:NSMakeRange(8, 2)];
    
    NSString* dateString = [NSString stringWithFormat:@"%@/%@/%@",day,month,year];
    
    return dateString;
}

+ (NSString*)formatNumber:(NSNumber*)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    
    return formattedNumberString;
}

@end
