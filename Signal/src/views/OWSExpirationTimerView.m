//  Created by Michael Kirk on 9/29/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSExpirationTimerView.h"
#import <QuartzCore/CAShapeLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSExpirationTimerView ()

@property (nonatomic) uint32_t initialDurationSeconds;
@property (nonatomic) NSTimer *animationTimer;
@property (atomic) uint64_t expiresAtSeconds;

@property (nonatomic, readonly) UIImageView *emptyHourglassImageView;
@property (nonatomic, readonly) UIImageView *fullHourglassImageView;
@property CGFloat ratioRemaining;

@end

@implementation OWSExpirationTimerView

- (void)dealloc
{
    DDLogDebug(@"%@ invalidating old animation timer in dealloc", self.logTag);
    [_animationTimer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }

    _emptyHourglassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hourglass_empty"]];
    [self insertSubview:_emptyHourglassImageView atIndex:0];

    _fullHourglassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hourglass_full"]];
    [self insertSubview:_fullHourglassImageView atIndex:1];
    _fullHourglassImageView.clipsToBounds = YES;

    _ratioRemaining = 1.0f;
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return self;
    }

    _emptyHourglassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hourglass_empty"]];
    [self insertSubview:_emptyHourglassImageView atIndex:0];

    _fullHourglassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hourglass_full"]];
    [self insertSubview:_fullHourglassImageView atIndex:1];
    _fullHourglassImageView.clipsToBounds = YES;

    _ratioRemaining = 1.0f;

    return self;
}

- (void)layoutSubviews
{
    CGFloat leftMargin = 6.0f;
    CGRect hourglassFrame = CGRectMake(leftMargin, 0, self.frame.size.height, self.frame.size.height);
    self.emptyHourglassImageView.frame = hourglassFrame;
    self.fullHourglassImageView.frame = hourglassFrame;

    CGFloat yOffset = (1 - self.ratioRemaining) * hourglassFrame.size.height;

    // Lifted from http://stackoverflow.com/questions/11391058/simply-mask-a-uiview-with-a-rectangle
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectOffset(hourglassFrame, -leftMargin, yOffset);
    // Create a path with the rectangle in it.
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    // Set the path to the mask layer.
    maskLayer.path = path;
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);

    self.fullHourglassImageView.layer.mask = maskLayer;
}

- (void)endAnyTimer
{
    if (self.animationTimer) {
        DDLogDebug(@"%@ invalidating old animation timer", self.logTag);
        [self.animationTimer invalidate];
    }
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow
{
    if (!newWindow) {
        DDLogVerbose(@"%@ expiring timer since we're leaving view.", self.logTag);
        [self endAnyTimer];
    }
}

- (void)startTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds
                initialDurationSeconds:(uint32_t)initialDurationSeconds
{
    DDLogDebug(@"%@ Starting animation timer with expiresAtSeconds: %llu initialDurationSeconds: %d",
        self.logTag,
        expiresAtSeconds,
        initialDurationSeconds);

    self.expiresAtSeconds = expiresAtSeconds;
    self.initialDurationSeconds = initialDurationSeconds;

    [self animateTimer];

    __weak typeof(self) wself = self;
    self.animationTimer =
        [NSTimer scheduledTimerWithTimeInterval:initialDurationSeconds / 16.0 // assumes a 10 step timer animation.
                                         target:wself
                                       selector:@selector(animateTimer)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)animateTimer
{
    double secondsLeft = self.expiresAtSeconds - [NSDate new].timeIntervalSince1970;

    if (secondsLeft > INT_MAX) { // overflow
        secondsLeft = 0;
        DDLogDebug(@"%@ Ending timer because time ran out.", self.logTag);
        [self endAnyTimer];
    }

    DDLogVerbose(@"%@ Animating timer with seconds left: %f", self.logTag, secondsLeft);
    self.ratioRemaining = (CGFloat)secondsLeft / (CGFloat)self.initialDurationSeconds;

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Logging

+ (NSString *)logTag
{
    return [NSString stringWithFormat:@"[%@]", self.class];
}

- (NSString *)logTag
{
    return self.class.logTag;
}

@end

NS_ASSUME_NONNULL_END
