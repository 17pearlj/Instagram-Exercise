//
//  LoginViewController.m
//  julia-instagram
//
//  Created by jpearl on 7/8/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()



@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButton:(id)sender;
- (IBAction)needsToRegister:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            // display view controller that needs to shown after successful login
            [self.navigationController popViewControllerAnimated:YES];

            
        }
    }];
}

// dismisses keyboard fun call
- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
    
}


- (IBAction)loginButton:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
            appDelegate.window.rootViewController = tabController;
        }
    }];
}

- (IBAction)needsToRegister:(id)sender {
    [self performSegueWithIdentifier:@"toRegister" sender:nil];
}


@end
