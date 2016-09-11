//
//  MUZTracksSearchBar.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUZTracksSearchBar;

@protocol MUZTracksSearchBarDelegate <NSObject>

- (BOOL)searchBarShouldBeginEditing:(MUZTracksSearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(MUZTracksSearchBar *)searchBar;

@end

@interface MUZTracksSearchBar : UISearchBar

@property (nonatomic,assign) BOOL enabled;

- (instancetype)initWithDelegate:(id<MUZTracksSearchBarDelegate>)delegate;

@end
