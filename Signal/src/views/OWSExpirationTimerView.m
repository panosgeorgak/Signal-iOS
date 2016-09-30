//  Created by Michael Kirk on 9/29/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSExpirationTimerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSExpirationTimerView ()

@property (nonatomic) uint32_t initialDurationSeconds;
@property (nonatomic) NSTimer *animationTimer;
@property (atomic) uint64_t expiresAtSeconds;

@end

@implementation OWSExpirationTimerView

- (void)dealloc
{
    DDLogDebug(@"%@ invalidating old animation timer in dealloc", self.logTag);
    [_animationTimer invalidate];
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
        [NSTimer scheduledTimerWithTimeInterval:initialDurationSeconds / 10.0 // assumes a 10 step timer animation.
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
    }

    DDLogVerbose(@"%@ Animating timer with seconds left: %f", self.logTag, secondsLeft);
    // TODO better animation.
    self.alpha = ((CGFloat)secondsLeft / (CGFloat)self.initialDurationSeconds);
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
