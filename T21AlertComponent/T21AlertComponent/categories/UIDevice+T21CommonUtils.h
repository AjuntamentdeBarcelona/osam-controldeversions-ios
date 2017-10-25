//
//  UIDevice+T21CommonUtils.h
//  T21Categories/UIDevice/CommonUtils
//
//  Created by David Arrufat on 19/05/15.
//  Copyright (c) 2015 Tempos21. All rights reserved.
//

#define isiPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define isiPhone !isiPad

#define IOS_VERSION_EQUAL_TO(v)          ([[UIDevice currentDevice] systemVersion].floatValue == v)
#define IOS_VERSION_NEWER_THAN(v)        ([[UIDevice currentDevice] systemVersion].floatValue > v)
#define IOS_VERSION_NEWER_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion].floatValue >= v)
#define IOS_VERSION_OLDER_THAN(v)        ([[UIDevice currentDevice] systemVersion].floatValue < v)
#define IOS_VERSION_OLDER_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion].floatValue <= v)

#import <UIKit/UIKit.h>

@interface UIDevice (T21CommonUtils)

@end
