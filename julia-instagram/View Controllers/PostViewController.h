//
//  PostViewController.h
//  julia-instagram
//
//  Created by jpearl on 7/9/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostViewController : UIViewController
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@end

NS_ASSUME_NONNULL_END
