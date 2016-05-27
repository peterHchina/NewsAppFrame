//
//  NSMutableArray+MutableArrayUtil.m
//  ScrollView
//
//  Created by vivo on 16/5/26.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "NSMutableArray+MutableArrayUtil.h"

@implementation NSMutableArray (MutableArrayUtil)
- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end
