//
//  MUZTracksSearchBar.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZTracksSearchBar.h"

@interface MUZTracksSearchBar()
<
  UISearchBarDelegate
>

@property (nonatomic,weak) id<MUZTracksSearchBarDelegate> myDelegate;

@end

@implementation MUZTracksSearchBar

- (instancetype)initWithDelegate:(id<MUZTracksSearchBarDelegate>)delegate
{
  self = [super initWithFrame:CGRectZero];
  if (!self) return nil;

  self.myDelegate = delegate;

  return self;
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  
  [self configureSearchBar];
}

#pragma mark Private

- (void)configureSearchBar
{
  self.placeholder = NSLocalizedString(@"TrackList.SearchBar.Placeholder", nil);
  
  self.delegate = self;
  self.autocapitalizationType = UITextAutocapitalizationTypeNone;
  
  [self sizeToFit];
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  BOOL should = YES;
  id<MUZTracksSearchBarDelegate> delegate = self.myDelegate;
  if ([_myDelegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
    should = [delegate searchBarShouldBeginEditing:self];
  }
  
  self.showsCancelButton = should;
  
  return should;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
  searchBar.showsCancelButton = NO;
  self.enabled = NO;
  return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  searchBar.text = nil;
  self.enabled = NO;
  [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  searchBar.showsCancelButton = NO;
  id<MUZTracksSearchBarDelegate> delegate = self.myDelegate;
  if ([_myDelegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
    [delegate searchBarSearchButtonClicked:self];
  }
}

@end
