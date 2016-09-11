//
//  MUZTrackProfileViewController.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIImageView+AFNetworking.h>

#import "MUZTrackProfileViewController.h"
#import "MUZTrack.h"

@interface MUZTrackProfileViewController()

@property (nonatomic,weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic,weak) IBOutlet UILabel *trackLabel;
@property (nonatomic,weak) IBOutlet UILabel *albumLabel;
@property (nonatomic,weak) IBOutlet UILabel *genreLabel;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@property (nonatomic,strong) MUZTrack *track;

@end

@implementation MUZTrackProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self assertDependencies];
  
  [self configureUI];
}

- (void)configureUI
{
  self.title = NSLocalizedString(@"TrackProfile.Title", nil);

  [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.track.artworkBig]];
  self.trackLabel.text = [NSString stringWithFormat:NSLocalizedString(@"TrackProfile.TrackName", nil), self.track.trackName];
  NSString *year = [self.dateFormatter stringFromDate:self.track.releaseDate];
  self.albumLabel.text = [NSString stringWithFormat:NSLocalizedString(@"TrackProfile.AlbumName", nil), year, self.track.collectionName];
  self.genreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"TrackProfile.GenreName", nil), self.track.genre];
}

- (NSDateFormatter *)dateFormatter
{
  if (!_dateFormatter) {
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"yyyy";
  }
  
  return _dateFormatter;
}

#pragma mark MUZDependenciesProtocol

- (void)assertDependencies
{
  NSParameterAssert(self.track);
}

- (void)setDependenciesWithTrack:(MUZTrack *)track
{
  self.track = track;
}

@end
