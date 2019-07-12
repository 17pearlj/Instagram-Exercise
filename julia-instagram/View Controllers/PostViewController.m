//
//  PostViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/9/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "PostViewController.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "Post.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;

@property (assign, nonatomic) BOOL liked;

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


- (IBAction)hitLike:(id)sender {
    int addition = 1;
    NSString *pic = @"heart2";
    NSString *username1 = [PFUser currentUser].username;
    if ([self.post.likeSet containsObject:username1]){
        [self.post.likeSet removeObject:username1];
        addition = -1;
        pic = @"heart";
    } else {
        [self.post.likeSet addObject:username1];
    }
    self.post[@"likeCount"] = @([self.post.likeCount intValue] + addition);
    self.likes.text = self.post.likeCount + addition
    self.post[@"likeSet"] = self.post.likeSet;
    [self.likeButton setImage:[UIImage imageNamed:pic] forState:UIControlStateNormal];
    [self.post saveInBackground];
    
    
    
    
}





@end
