//
//  MUZTracksTableViewCell.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIImageView+AFNetworking.h>

#import "MUZTracksTableViewCell.h"
#import "MUZTrackCellViewModel.h"
#import "MUZTrack.h"

@interface MUZTracksTableViewCell()

@property (nonatomic,weak) IBOutlet UIImageView *artImageView;
@property (nonatomic,weak) IBOutlet UILabel *trackLabel;
@property (nonatomic,weak) IBOutlet UILabel *artistLabel;

@end

@implementation MUZTracksTableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  _artImageView.layer.cornerRadius = 8.0f;
  _artImageView.clipsToBounds = YES;
}

- (void)prepareForReuse
{
  [self.imageView cancelImageDownloadTask];
}

- (void)configureWithViewModel:(MUZTrackCellViewModel *)viewModel
{
  MUZTrack *track = viewModel.modelObject;
  self.trackLabel.text = track.trackName;
  self.artistLabel.text = [NSString stringWithFormat:@"%@ (%@)", track.artistName, track.collectionName];
  [self.artImageView setImageWithURL:[NSURL URLWithString:track.artworkBig]];
}

@end
