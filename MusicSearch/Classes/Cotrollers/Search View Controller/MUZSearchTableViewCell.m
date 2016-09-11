//
//  MUZSearchTableViewCell.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZSearchTableViewCell.h"
#import "MUZSearchCellViewModel.h"
#import "MUZSearch.h"

@interface MUZSearchTableViewCell()

@property (nonatomic,weak) IBOutlet UILabel *queryLabel;

@end

@implementation MUZSearchTableViewCell

- (void)configureWithViewModel:(MUZSearchCellViewModel *)viewModel
{
  MUZSearch *search = viewModel.modelObject;
  self.queryLabel.text = search.query;
}

@end
