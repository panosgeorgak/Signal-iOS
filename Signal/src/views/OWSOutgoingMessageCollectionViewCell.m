//  Created by Michael Kirk on 9/28/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSOutgoingMessageCollectionViewCell.h"
#import "OWSExpirationTimerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSOutgoingMessageCollectionViewCell ()

@property (nonatomic) IBOutlet OWSExpirationTimerView *expirationTimerView;

@end

@implementation OWSOutgoingMessageCollectionViewCell

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
