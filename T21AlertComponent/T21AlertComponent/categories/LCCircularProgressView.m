//
//  LCCircularProgressView.m
//  PullToRefresh
//
//  Created by Govind Tiwari on 11/25/15.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import "LCCircularProgressView.h"

static NSString *kProgressViewPathAnimationKey = @"path";
static NSString *kCircularProgressViewAnimationKey = @"transform.rotation";

@interface LCCircularProgressView()

@property (assign, nonatomic) CGFloat lastValue;
@property (assign, nonatomic) CGFloat currentValue;
@property (assign, nonatomic) CGFloat progressLineWidth;
@property (strong, nonatomic) UIColor *progressColor;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation LCCircularProgressView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    self.lastValue = 0.0f;
    self.currentValue = 0.0f;
    self.isInfiniteProgress = NO;
    [self setCircleLineWidth:0.0f andColor:[UIColor clearColor]];
}

- (void)updateSpinnerPath
{
    CGFloat startAngle = _isInfiniteProgress? (-M_PI_4): ( - M_PI_2);
    CGFloat endAngle =  _isInfiniteProgress ? (2 * M_PI_2) :  (self.currentValue * 2 * M_PI + startAngle);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.shapeLayer.lineWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.shapeLayer.path =path.CGPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createShapeLayer];
    [self updateSpinnerPath];
    [self refreshShapeLayer];
}

-(void)setCircleLineWidth:(CGFloat)lineWidth andColor:(UIColor *)color
{
    self.layer.borderWidth = lineWidth;
    self.layer.borderColor = [color CGColor];
    self.layer.cornerRadius = self.bounds.size.width/2;
}

-(void)setProgressLineWidth:(CGFloat)lineWidth andColor:(UIColor *)color
{
     _progressColor = color;
    _progressLineWidth = lineWidth;
}

- (void)createShapeLayer
{
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.shapeLayer];
    }
    
    self.shapeLayer.lineWidth = self.progressLineWidth;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineJoin = kCALineJoinBevel;
    self.shapeLayer.strokeColor = self.progressColor.CGColor;
    self.shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.layer.cornerRadius = self.bounds.size.width/2;
}

- (void)refreshShapeLayer
{
    if ((self.currentValue != self.lastValue) || _isInfiniteProgress) {
        
        CGFloat fromValue = _isInfiniteProgress ? 0.0f :  ((1 * self.lastValue) / self.currentValue);
        
        CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:[self animationKeypath]];
        CABasicAnimation *animation = _isInfiniteProgress ? [CABasicAnimation animation] : progressAnimation;
        
        animation.duration = 0.5;
        animation.fromValue = @(fromValue) ;
        animation.toValue = _isInfiniteProgress ? @(2*M_PI) : @(1.0f) ;
        animation.repeatCount = _isInfiniteProgress ? INFINITY : 0;
        [self.shapeLayer addAnimation:animation forKey:[self animationKeypath]];
    }
    self.lastValue = self.currentValue;
}

-(BOOL)isAnimating
{
    return [self.shapeLayer animationForKey:[self animationKeypath]];
}

- (void)startAnimating
{
    if ([self isAnimating]){
        [self stopAnimating];
    }
    [self refreshShapeLayer];
}

- (void)stopAnimating
{
    if ([self isAnimating]){
        [self.shapeLayer removeAnimationForKey:[self animationKeypath]];
    }
}

-(NSString *)animationKeypath
{
    return _isInfiniteProgress ? kCircularProgressViewAnimationKey : kProgressViewPathAnimationKey;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    self.currentValue = MAX(MIN(progressValue, 1.0f), 0.0f);
    [self setNeedsLayout];
}


@end
