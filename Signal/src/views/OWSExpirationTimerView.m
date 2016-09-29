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
    [_animationTimer invalidate];
}

- (void)endAnyTimer
{
    if (self.animationTimer) {
        DDLogDebug(@"%@ invalidating old animation timer", self.logTag);
        [self.animationTimer invalidate];
    }
}

- (void)startTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds initialDurationSeconds:(uint32_t)initialDurationSeconds
{
    DDLogDebug(@"%@ Starting animation timer with expiresAtSeconds: %llu initialDurationSeconds: %d", self.logTag, expiresAtSeconds, initialDurationSeconds);
    self.expiresAtSeconds = expiresAtSeconds;
    self.initialDurationSeconds = initialDurationSeconds;


    [self animateTimer];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:initialDurationSeconds / 10.0 // assumes a 10 step timer animation.
                                                           target:self
                                                         selector:@selector(animateTimer)
                                                         userInfo:nil
                                                          repeats:YES];

}

- (void)animateTimer
{
    uint64_t secondsLeft = self.expiresAtSeconds - (uint64_t)[NSDate new].timeIntervalSince1970;
    DDLogVerbose(@"%@ Animating timer with seconds left: %llu", self.logTag, secondsLeft);

    // TODO better animation.
    self.alpha = (secondsLeft / (float)self.initialDurationSeconds)/2;
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
