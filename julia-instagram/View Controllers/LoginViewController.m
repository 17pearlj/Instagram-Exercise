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
    // Do any additional setup after loading the view.
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            //[self performSegueWithIdentifier:@"toHome" sender:nil];
            [self.navigationController popViewControllerAnimated:YES];
            // display view controller that needs to shown after successful login
            
        }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
    // dismisses keyboard fun call
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"CHECK!");
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
 
           // [self performSegueWithIdentifier:@"toHome" sender:nil];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
            appDelegate.window.rootViewController = tabController;
            // display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)needsToRegister:(id)sender {
    NSLog(@"register plz");
//    RegisterViewController* vc = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"toRegister" sender:nil];
   //[self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


@end
