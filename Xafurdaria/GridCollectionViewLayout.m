//
//  GridCollectionViewLayout.m
//  Xafurdaria
//
//  Created by Iuri Matsuura on 9/13/15.
//  Copyright (c) 2015 Iuri Mac. All rights reserved.
//

#import "GridCollectionViewLayout.h"

@interface GridCollectionViewLayout()

@property (nonatomic, assign) NSInteger numOfColums;
@property (nonatomic) NSMutableArray* cachedItems;

@end

@implementation GridCollectionViewLayout

- (instancetype)initWithNumberOfColums:(NSInteger)numberOfColums
{
    if (self = [super init]) {
        _numOfColums = numberOfColums;
        _cachedItems = [NSMutableArray arrayWithCapacity:numberOfColums];
    }
    
    return self;
}

- (void)prepareLayout
{
    
}

- (CGSize)collectionViewContentSize
{
    
}

@end
