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

@interface HomeViewController () 
- (IBAction)didLogout:(id)sender;
- (IBAction)takePicture:(id)sender;
@end

@implementation HomeViewController

- (IBAction)didLogout:(id)sender {
    NSLog(@"logout pushed");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
   // LoginViewController *vc = [[LoginViewController alloc] init];;
    //[self.navigationController popToViewController:vc animated:true];
    //[self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nill];
    [self dismissViewControllerAnimated:YES completion:nil];
   //[self performSegueWithIdentifier:@"toLogin2" sender:nil];
}

- (IBAction)takePicture:(id)sender {
    [self performSegueWithIdentifier:@"toCamera" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"home page");
   
}
////
/////*
//#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
