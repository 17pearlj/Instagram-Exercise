//
//  TimelineViewCell.m
//  julia-instagram
//
//  Created by jpearl on 7/9/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "TimelineViewCell.h"

@implementation TimelineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setPost:self.post];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
