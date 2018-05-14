//
//  LCCircularProgressView.h
//  PullToRefresh
//
//  Created by Govind Tiwari on 11/25/15.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCircularProgressView : UIView

@property(nonatomic, assign) BOOL isInfiniteProgress;

- (void)setProgressValue:(CGFloat)progress;

- (void)setProgressLineWidth:(CGFloat)lineWidth andColor:(UIColor *)color;

- (void)setCircleLineWidth:(CGFloat)lineWidth andColor:(UIColor *)color;

- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;

@end
