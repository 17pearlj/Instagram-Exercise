//
//  CameraViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/8/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "CameraViewController.h"
#import "Post.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *caption;

@property (weak, nonatomic) IBOutlet UIImageView *readyToPost;
//@property (strong, nonatomic) UIImage *myPost;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
    // dismisses keyboard fun call
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.readyToPost.image = editedImage;
    self.readyToPost.image = [self resizeImage:self.readyToPost.image withSize:CGSizeMake(500.0, 500.0)];
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
    HomeViewController *homeVC = [segue destinationViewController];
    homeVC.justPosted = YES;
    NSLog(@"JUST POSTED");
}

- (IBAction)clickHome:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
    appDelegate.window.rootViewController = tabController;
}

- (IBAction)clickPost:(id)sender {
    [Post postUserImage:self.readyToPost.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError *error) {
        if(error){
           // [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"Error taking action on tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully took action on the following Tweet");
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
            appDelegate.window.rootViewController = tabController;
//            HomeViewController *homeVC;
//            homeVC.justPosted = YES;
//            NSLog(@"JUST POSTED");
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
   
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
