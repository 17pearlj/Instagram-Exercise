//
//  TimelineViewCell.h
//  julia-instagram
//
//  Created by jpearl on 7/9/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "username_button.h"


NS_ASSUME_NONNULL_BEGIN

@interface TimelineViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *propic;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet username_button *username;
@property (assign, nonatomic) BOOL liked;
//@property (weak, nonatomic) IBOutlet UIButton< *username;
//@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UIButton *picButton;
@property (strong, nonatomic) Post *post;
@end


NS_ASSUME_NONNULL_END
