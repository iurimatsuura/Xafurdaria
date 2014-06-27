//
//  ContentDetailsVideo.m
//  Putz Vei
//
//  Created by Iuri on 20/07/13.
//  Copyright (c) 2013 Iuri Mac. All rights reserved.
//

#import "ContentDetailsVideo.h"

@implementation ContentDetailsVideo

-(NSString*)correctDuration{
    NSString *duration = self.duration;
    
    int i = 0, days = 0, hours = 0, minutes = 0, seconds = 0;
    
    while(i < duration.length)
    {
        NSString *str = [duration substringWithRange:NSMakeRange(i, duration.length-i)];
        
        i++;
        
        if([str hasPrefix:@"P"] || [str hasPrefix:@"T"])
            continue;
        
        NSScanner *sc = [NSScanner scannerWithString:str];
        int value = 0;
        
        if ([sc scanInt:&value])
        {
            i += [sc scanLocation]-1;
            
            str = [duration substringWithRange:NSMakeRange(i, duration.length-i)];
            
            i++;
            
            if([str hasPrefix:@"D"])
                days = value;
            else if([str hasPrefix:@"H"])
                hours = value;
            else if([str hasPrefix:@"M"])
                minutes = value;
            else if([str hasPrefix:@"S"])
                seconds = value;
        }
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"%d days, %d hours, %d mins, %d seconds", days, hours, minutes, seconds]);
    if (hours != 0) {
        return [NSString stringWithFormat:@"%d:%01d:%01d", hours, minutes, seconds];

    }
    else{
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

    }
}

@end
