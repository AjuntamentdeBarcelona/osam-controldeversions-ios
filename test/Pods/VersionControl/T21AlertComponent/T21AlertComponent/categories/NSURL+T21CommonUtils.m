//
//  NSURL+T21CommonUtils.m
//  MyPod
//
//  Created by Rocío Tovar on 26/01/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import "NSURL+T21CommonUtils.h"

@implementation NSURL (T21CommonUtils)

- (NSString *)baseURLString
{
    return [NSString stringWithFormat:@"%@://%@", self.scheme, self.host];
}

@end
