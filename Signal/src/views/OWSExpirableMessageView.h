//  Created by Michael Kirk on 9/29/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

NS_ASSUME_NONNULL_BEGIN

@class OWSExpirationTimerView;

@protocol OWSExpirableMessageView

@property (strong, nonatomic, readonly) IBOutlet OWSExpirationTimerView *expirationTimerView;
@property (strong, nonatomic, readonly) IBOutlet NSLayoutConstraint *expirationTimerViewWidthConstraint;

- (void)startExpirationTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds
                          initialDurationSeconds:(uint32_t)initialDurationSeconds;

- (void)endAnyExpirationTimer;

@end

NS_ASSUME_NONNULL_END
