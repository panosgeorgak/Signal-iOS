//  Created by Michael Kirk on 9/29/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSIncomingMessageCollectionViewCell.h"
#import "OWSExpirationTimerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSIncomingMessageCollectionViewCell ()

@property (nonatomic) IBOutlet OWSExpirationTimerView *expirationTimerView;

@end

@implementation OWSIncomingMessageCollectionViewCell

- (void)startExpirationTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds
                          initialDurationSeconds:(uint32_t)initialDurationSeconds
{
    [self.expirationTimerView startTimerWithExpiresAtSeconds:expiresAtSeconds
                                      initialDurationSeconds:initialDurationSeconds];
}

- (void)endAnyExpirationTimer
{
    [self.expirationTimerView endAnyTimer];
}

@end

NS_ASSUME_NONNULL_END
