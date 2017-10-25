//
//  NSDate+Utils.m
//  T21AlertComponent
//
//  Created by Tempos21 on 03/07/2017.
//  Copyright © 2017 Tempos21. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(BOOL)isBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
