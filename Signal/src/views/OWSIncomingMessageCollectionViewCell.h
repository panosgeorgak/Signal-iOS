//  Created by Michael Kirk on 9/29/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import <JSQMessagesViewController/JSQMessagesCollectionViewCellIncoming.h>
#import "OWSExpirableMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSIncomingMessageCollectionViewCell : JSQMessagesCollectionViewCellIncoming <OWSExpirableMessageView>

@end

NS_ASSUME_NONNULL_END
