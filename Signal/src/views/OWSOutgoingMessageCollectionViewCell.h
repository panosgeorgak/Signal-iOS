//  Created by Michael Kirk on 9/28/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import <JSQMessagesViewController/JSQMessagesCollectionViewCellOutgoing.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSOutgoingMessageCollectionViewCell : JSQMessagesCollectionViewCellOutgoing

- (void)startExpirationTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds
                          initialDurationSeconds:(uint32_t)initialDurationSeconds;

- (void)endAnyExpirationTimerAnimation;

@end

NS_ASSUME_NONNULL_END
