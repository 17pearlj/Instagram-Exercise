//
//  username_button.h
//  julia-instagram
//
//  Created by jpearl on 7/11/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface username_button : UIButton
@property (nonatomic, strong) PFUser *author;
@end

NS_ASSUME_NONNULL_END
