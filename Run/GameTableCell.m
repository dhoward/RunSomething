//
//  GameTableCell.m
//  Run
//
//  Created by Daniel Howard on 3/3/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "GameTableCell.h"

@implementation GameTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
