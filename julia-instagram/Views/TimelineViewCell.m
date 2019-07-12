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

- (IBAction)hitLike:(id)sender {
    int addition = 1;
    NSString *pic = @"heart2";
    NSString *username1 = [PFUser currentUser].username;
    NSLog(@"%d", [self.post.likeSet containsObject:username1]);
    if ([self.post.likeSet containsObject:username1]){
        [self.post.likeSet removeObject:username1];
        addition = -1;
        pic = @"heart";
    } else {
        [self.post.likeSet addObject:[PFUser currentUser].username];
    }
    self.post[@"likeCount"] = @([self.post.likeCount intValue] + addition);
    
    self.post[@"likeSet"] = self.post.likeSet;
    [self.likeButton setImage:[UIImage imageNamed:pic] forState:UIControlStateNormal];
    [self.post saveInBackground];
}


@end
