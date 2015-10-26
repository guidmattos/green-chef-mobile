//
//  ViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 9/20/15.
//  Copyright (c) 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "LoginViewController.h"
#import "HTTPRequest.h"
#import "SVProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    if ([FBSDKAccessToken currentAccessToken]) {
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(performLogin) userInfo:nil repeats:NO]; // delay for facebook animation
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Process error");
    } else if (result.isCancelled) {
        NSLog(@"Cancelled");
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(performLogin) userInfo:nil repeats:NO]; // delay for facebook animation
    }
}

-(void)performLogin {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"Logged out");
}

- (IBAction)login:(id)sender {
    
    if (![self validateFields]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                        message:@"Por favor, preencha todos os campos."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self loginWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text];
}

-(void) loginWithEmail:(NSString *) email andPassword:(NSString *) password {
    
    [SVProgressHUD show];
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
    
    // Parameter
    NSDictionary *parameters = @{@"email": email,
                                 @"password": password};
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] init];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
//    NSString *url = @"http://pad-development-env.elasticbeanstalk.com/api/v1/auth/signin";
    NSString *url = @"http://pad-prime-api.app/api/v1/auth/signin";
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Usuário e/ou senha incorretos."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
}

-(BOOL) validateFields
{
    if (self.emailTextField.text == nil || [self.emailTextField.text isEqualToString:@""])
        return false;
    
    if (self.passwordTextField.text == nil || [self.passwordTextField.text isEqualToString:@""])
        return false;
    
    return true;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Login");
}



@end
