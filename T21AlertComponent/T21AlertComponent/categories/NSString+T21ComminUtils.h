//
//  NSString+T21ComminUtils.h
//  T21AlertComponent
//
//  Created by Edwin Peña on 28/6/17.
//  Copyright © 2017 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (T21ComminUtils)

typedef enum
{
    URLQueryOptionDefault = 0,
    URLQueryOptionKeepLastValue = 1,
    URLQueryOptionKeepFirstValue = 2,
    URLQueryOptionUseArrays = 3,
    URLQueryOptionAlwaysUseArrays = 4,
    URLQueryOptionUseArraySyntax = 8
}
URLQueryOptions;


#pragma mark URLEncoding

- (NSString *)URLEncodedString;

#pragma mark URL query

+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters;
+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters options:(URLQueryOptions)options;
- (NSRange)rangeOfURLQuery;
- (NSString *)URLQuery;
- (NSString *)stringByAppendingURLQuery:(NSString *)query;


#pragma mark URL fragment ID

- (NSString *)URLFragment;
@end
