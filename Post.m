//
//  Post.m
//
//
//  Created by jpearl on 7/9/19.
//

#import "Post.h"
@implementation Post


@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic createdAt;
@dynamic likeSet;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.likeSet = [NSMutableArray new];
    //newPost.createdAt = createdAt;
    
    
    [newPost saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

   // return [PFRole fileWithName:@"image.png" data:imageData];
    return [PFFileObject fileObjectWithName:@"readyToPost.png" data:imageData];
}

@end
