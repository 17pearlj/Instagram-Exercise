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

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
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
    NSLog(@"constructing query!");
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = self.postLoaded;
    if ([self.restorationIdentifier isEqual: @"persProf"]){
        NSLog(@"MY PROF");
        self.objectIdString = [PFUser currentUser].objectId;
    }
    [postQuery whereKey:@"author" containsString:self.objectIdString];
    self.username.text = [PFUser currentUser].username;
    
//    PFUser *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"current_user"];
    NSLog(@"DATA %@", [PFUser currentUser].username);

    NSLog(@"query constructed!");
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts.count != 0) {
            NSLog(@"we have posts!");
            // do something with the data fetched
            self.posts = posts;
            self.count.text = [[NSNumber numberWithLong:posts.count] stringValue];
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"no posts :((");
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
            NSLog(@"we have posts!");
            // do something with the data fetched
            
            //self.tweets = newArray;
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
            NSLog(@"POST, %@", post);
            NSLog(@"%@", post.createdAt);
        }
    }
}

@end
