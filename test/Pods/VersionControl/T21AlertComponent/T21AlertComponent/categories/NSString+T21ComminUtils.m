//
//  NSString+T21ComminUtils.m
//  T21AlertComponent
//
//  Created by Edwin Peña on 28/6/17.
//  Copyright © 2017 Tempos21. All rights reserved.
//

#import "NSString+T21ComminUtils.h"

@implementation NSString (T21ComminUtils)

#pragma mark URLEncoding

- (NSString *)URLEncodedString
{
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)self,
                                                                  NULL,
                                                                  CFSTR("!*'\"();:@&=+$,/?%#[]% "),
                                                                  kCFStringEncodingUTF8);
    return CFBridgingRelease(encoded);
}

#pragma mark Query strings

+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters
{
    return [self URLQueryWithParameters:parameters options:URLQueryOptionDefault];
}

+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters options:(URLQueryOptions)options
{
    BOOL useArraySyntax = options & 8;
    URLQueryOptions arrayHandling = (options & 7) ?: URLQueryOptionUseArrays;
    
    NSMutableString *result = [NSMutableString string];
    for (NSString *key in parameters)
    {
        NSString *encodedKey = [key URLEncodedString];
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSArray class]])
        {
            if (arrayHandling == URLQueryOptionKeepFirstValue && [value count])
            {
                if ([result length])
                {
                    [result appendString:@"&"];
                }
                [result appendFormat:@"%@=%@", encodedKey, [[value objectAtIndex:0] URLEncodedString]];
            }
            else if (arrayHandling == URLQueryOptionKeepLastValue && [value count])
            {
                if ([result length])
                {
                    [result appendString:@"&"];
                }
                [result appendFormat:@"%@=%@", encodedKey, [[value lastObject] URLEncodedString]];
            }
            else
            {
                for (NSString *element in value)
                {
                    if ([result length])
                    {
                        [result appendString:@"&"];
                    }
                    if (useArraySyntax)
                    {
                        [result appendFormat:@"%@[]=%@", encodedKey, [element URLEncodedString]];
                    }
                    else
                    {
                        [result appendFormat:@"%@=%@", encodedKey, [element URLEncodedString]];
                    }
                }
            }
        }
        else
        {
            if ([result length])
            {
                [result appendString:@"&"];
            }
            if (useArraySyntax && arrayHandling == URLQueryOptionAlwaysUseArrays)
            {
                [result appendFormat:@"%@[]=%@", encodedKey, [value URLEncodedString]];
            }
            else
            {
                [result appendFormat:@"%@=%@", encodedKey, [value URLEncodedString]];
            }
        }
    }
    return result;
}

- (NSString *)stringByAppendingURLQuery:(NSString *)query
{
    //check for nil input
    if ([query length] == 0)
    {
        return self;
    }
    
    NSString *result = self;
    NSString *fragment = [result URLFragment];
    result = [self stringByDeletingURLFragment];
    NSString *queryString = [result URLQuery];
    if (queryString)
    {
        if ([queryString length])
        {
            result = [result stringByAppendingFormat:@"&%@", query];
        }
        else
        {
            result = [result stringByAppendingString:query];
        }
    }
    else
    {
        result = [result stringByAppendingFormat:@"?%@", query];
    }
    if ([fragment length])
    {
        result = [result stringByAppendingFormat:@"#%@", fragment];
    }
    return result;
}

- (NSRange)rangeOfURLQuery
{
    NSRange queryRange = NSMakeRange(0, [self length]);
    NSRange fragmentStart = [self rangeOfString:@"#"];
    if (fragmentStart.length)
    {
        queryRange.length -= (queryRange.length - fragmentStart.location);
    }
    NSRange queryStart = [self rangeOfString:@"?"];
    if (queryStart.length)
    {
        queryRange.location = queryStart.location;
        queryRange.length -= queryRange.location;
    }
    NSString *queryString = [self substringWithRange:queryRange];
    if (queryStart.length || [queryString rangeOfString:@"="].length)
    {
        return queryRange;
    }
    return NSMakeRange(NSNotFound, 0);
}

- (NSString *)URLQuery
{
    NSRange queryRange = [self rangeOfURLQuery];
    if (queryRange.location == NSNotFound)
    {
        return nil;
    }
    NSString *queryString = [self substringWithRange:queryRange];
    if ([queryString hasPrefix:@"?"])
    {
        queryString = [queryString substringFromIndex:1];
    }
    return queryString;
}

#pragma mark URL fragment ID

- (NSString *)URLFragment
{
    NSRange fragmentStart = [self rangeOfString:@"#"];
    if (fragmentStart.location != NSNotFound)
    {
        return [self substringFromIndex:fragmentStart.location + 1];
    }
    return nil;
}


- (NSString *)stringByDeletingURLFragment
{
    NSRange fragmentStart = [self rangeOfString:@"#"];
    if (fragmentStart.location != NSNotFound)
    {
        return [self substringToIndex:fragmentStart.location];
    }
    return self;
}

@end
