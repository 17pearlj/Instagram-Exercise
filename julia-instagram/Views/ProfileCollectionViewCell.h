//
//  ProfileCollectionViewCell.h
//  julia-instagram
//
//  Created by jpearl on 7/10/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@end

NS_ASSUME_NONNULL_END
