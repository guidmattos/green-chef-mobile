//
//  ViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 9/20/15.
//  Copyright (c) 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HTTPRequest.h"
#import "SVProgressHUD.h"

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"access_token"]) {
        
        [self.emailTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
        [self.passwordTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];

        [self login];
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
        [self getUserFacebookInfo];
    }
}

- (void) getUserFacebookInfo {
    
    [SVProgressHUD show];
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"}];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            
            // Parameter
            NSDictionary *parameters = @{@"facebook_id": [result objectForKey:@"id"],
                                         @"email": [result objectForKey:@"email"],
                                         @"name": [result objectForKey:@"name"]};
            [self createFacebookUser:parameters];
        }
        else{
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
    [connection start];
}

-(void)createFacebookUser:(NSDictionary *) parameters {
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/client/create", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  NSString *accessToken = [[responseObject objectForKey:@"data"] objectForKey:@"access_token"];
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"access_token"];
                                                  
                                                  [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Não foi possível realizar o login pelo Facebook. Favor tente novamente mais tarde."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
}

-(void)performLogin {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"Logged out");
}

- (IBAction)login:(id)sender {
    [self login];
}

-(void) login {
    
    if (![self validateFields]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                        message:@"Por favor, preencha todos os campos."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [SVProgressHUD show];
    
    // Parameter
    NSDictionary *parameters = @{@"email": email,
                                 @"password": password};
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/auth/signin", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  NSString *accessToken = [[responseObject objectForKey:@"data"] objectForKey:@"access_token"];
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"access_token"];
                                                  [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
                                                  [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
                                                  
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
