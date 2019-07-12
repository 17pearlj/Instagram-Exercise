//
//  ProfileViewController.h
//  julia-instagram
//
//  Created by jpearl on 7/10/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) PFUser *author;
@end

NS_ASSUME_NONNULL_END
