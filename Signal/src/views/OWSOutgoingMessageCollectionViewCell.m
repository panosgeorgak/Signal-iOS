//  Created by Michael Kirk on 9/28/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSOutgoingMessageCollectionViewCell.h"
#import "OWSExpirationTimerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSOutgoingMessageCollectionViewCell ()

@property IBOutlet OWSExpirationTimerView *expirationTimerView;

@end

@implementation OWSOutgoingMessageCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.expirationTimerView.backgroundColor = [UIColor colorWithRed:0.2f green:0.8f blue:0.0f alpha:0.8f];
    //    self.footerView = [[UIView alloc] initWithFrame:self.cellBottomLabel.frame];
    //    self.footerView.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:.6f alpha:0.8];
}

- (void)startExpirationTimerWithExpiresAtSeconds:(uint64_t)expiresAtSeconds
                          initialDurationSeconds:(uint32_t)initialDurationSeconds;
{
    [self.expirationTimerView startTimerWithExpiresAtSeconds:expiresAtSeconds
                                      initialDurationSeconds:initialDurationSeconds];
}

- (void)endAnyExpirationTimerAnimation
{
    [self.expirationTimerView endAnyTimer];
}

@end

NS_ASSUME_NONNULL_END
