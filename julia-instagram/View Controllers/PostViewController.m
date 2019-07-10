//
//  PostViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/9/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "PostViewController.h"
#import "DateTools.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.post.author.username;
    self.createdAt.text = self.post.createdAt.timeAgoSinceNow;
    self.caption.text = self.post.caption;
    self.likes.text = [self.post.likeCount stringValue];
    self.comments.text = [self.post.commentCount stringValue];
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            self.pic.image = [UIImage imageWithData:imageData];
        }
    }];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
