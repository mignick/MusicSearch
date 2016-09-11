//
//  MUZSearchTableViewCell.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUZSearchCellViewModel;

@interface MUZSearchTableViewCell : UITableViewCell

- (void)configureWithViewModel:(MUZSearchCellViewModel *)viewModel;

@end
