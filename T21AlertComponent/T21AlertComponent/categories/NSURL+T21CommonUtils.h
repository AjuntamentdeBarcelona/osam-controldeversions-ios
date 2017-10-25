//
//  NSURL+T21CommonUtils.h
//  MyPod
//
//  Created by Rocío Tovar on 26/01/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (T21CommonUtils)

/**
 * @return The host, conforming to RFC 1808
 */
- (NSString *)baseURLString;

@end
