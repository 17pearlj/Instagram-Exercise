//
//  ProfileViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/10/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "Parse/Parse.h"
#import "ProfileViewController.h"
#import "ProfileCollectionViewCell.h"
#import "Post.h"
#import "PostViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIImageView *propic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<Post *> *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) int postLoaded;




@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.propic.layer.cornerRadius = 25;
    self.propic.clipsToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    // construct query
    self.postLoaded = 20;
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = self.postLoaded;
    if ([self.restorationIdentifier isEqual: @"persProf"]){
        self.author = [PFUser currentUser];
    }
    if (self.author[@"propic"]){
        PFFileObject *propicImageFile = (PFFileObject *)self.author[@"propic"];
        [propicImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                self.propic.image = [UIImage imageWithData:imageData];
            }
        }];
    }
    [postQuery whereKey:@"author" containsString:self.author.objectId];
    self.username.text = self.author.username;


    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts.count != 0) {
            // do something with the data fetched
            self.posts = posts;
            self.count.text = [[NSNumber numberWithLong:posts.count] stringValue];
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
    

    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilecell" forIndexPath:indexPath];
    Post *post =  self.posts[indexPath.row];
    cell.post = post;
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.pic.image = [UIImage imageWithData:imageData];
        }
    }];
    
    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    self.postLoaded = 20;
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = self.postLoaded;
    NSLog(@"query constructed!");
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {

            self.posts = posts;
            [self.collectionView reloadData];
            [refreshControl endRefreshing];
        }
    }];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:ProfileCollectionViewCell.class]){
        ProfileCollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        if (indexPath.row >= 0){
            Post *post = self.posts[indexPath.row];
            PostViewController *postVC = [segue destinationViewController];
            postVC.post = post;

        }
    }
}

- (IBAction)changeProf:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        //camera not available
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.propic.image = editedImage;
    self.propic.image = [self resizeImage:self.propic.image withSize:CGSizeMake(500.0, 500.0)];
        //self.propic.image = [UIImage imageWithData:self.propic];
    [PFUser currentUser][@"propic"] = [Post getPFFileFromImage:self.propic.image];
    [[PFUser currentUser] saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (IBAction)post:(id)sender {
    [self performSegueWithIdentifier:@"toCamera" sender:nil];
}
- (IBAction)didLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"notAuth"];
    appDelegate.window.rootViewController = navigationController;
}

@end
