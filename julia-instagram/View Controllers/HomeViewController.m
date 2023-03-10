//
//  HomeViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/8/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TimelineViewCell.h"
#import "PostViewController.h"
#import "DateTools.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "username_button.h"
#import "ProfileViewController.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
- (IBAction)didLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *timeline;
- (IBAction)takePicture:(id)sender;


@property (strong, nonatomic) NSArray<Post *> *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int postLoaded;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.justPosted = YES;
    if (self.justPosted){
        [SVProgressHUD show];
        [self.timeline reloadData];
        self.justPosted = !(self.justPosted);
        [SVProgressHUD dismiss];
        
    }
    self.postLoaded = 20;
    self.timeline.dataSource = self;
    self.timeline.delegate = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.timeline insertSubview:refreshControl atIndex:0];
    // construct query
    [SVProgressHUD show];
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = self.postLoaded;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.timeline reloadData];
            [SVProgressHUD dismiss];
        }
    }];
    
    
}


- (IBAction)didLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"notAuth"];
    appDelegate.window.rootViewController = navigationController;
}

- (IBAction)takePicture:(id)sender {
    [self performSegueWithIdentifier:@"toCamera" sender:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineViewCell *cell = [self.timeline dequeueReusableCellWithIdentifier: @"Time"];
    Post *post =  self.posts[indexPath.row];
    cell.propic.layer.cornerRadius = 25;
    cell.propic.clipsToBounds = YES;
    PFFileObject *propicImageFile = (PFFileObject *)post.author[@"propic"];
    [propicImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.propic.image = [UIImage imageWithData:imageData];
        }
    }];
    cell.caption.text = post.caption;
    cell.post = post;
    [cell.username setTitle:post.author.username forState:UIControlStateNormal];
    cell.username.author = post.author;
    if ([post.likeSet containsObject:[PFUser currentUser].username]){
        [cell.likeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
    cell.createdAt.text = post.createdAt.timeAgoSinceNow;
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
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.timeline reloadData];
        }
    }];
    [refreshControl endRefreshing];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        self.isMoreDataLoading = true;
        
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.timeline.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.timeline.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.timeline.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        
        }
    }
}
    
-(void)loadMoreData{
    
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    self.postLoaded += 20;
    postQuery.limit = self.postLoaded;
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error");
            // do something with the data fetched
        } else
        {
            // Update flag
            self.isMoreDataLoading = false;
            
            // ... Use the new data to update the data source ...
            self.posts = posts;
            // Reload the tableView now that there is new data
            [self.timeline reloadData];
        }
    }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:UIButton.class]){
        username_button *button = sender;
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.author = button.author;
    }
    if ([sender isKindOfClass:TimelineViewCell.class]){
        TimelineViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.timeline indexPathForCell:tappedCell];
        if (indexPath.row >= 0){
            Post *post = self.posts[indexPath.row];
            PostViewController *postVC = [segue destinationViewController];
            postVC.post = post;
            if ([post.likeSet containsObject:[PFUser currentUser].username]){
                [postVC.likeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
                
            } else {
                [postVC.likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
            }
        }
    }
}



@end
