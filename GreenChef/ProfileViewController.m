//
//  ProfileViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "ProfileViewController.h"
#import "IngredientTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HTTPRequest.h"
#import "SVProgressHUD.h"

@interface ProfileViewController ()

@property NSMutableArray *ingredientList;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UISwitch *meatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *glutenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eggSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *milkSwitch;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    self.ingredientList = [[NSMutableArray alloc] initWithObjects:@"Ovo",
                           @"Leite", nil];
    self.profileImageView.layer.cornerRadius = 25;
    self.profileImageView.layer.masksToBounds = YES;
    
    [self getUserFacebookInfo];
    [self getUserIngredientOptions];
}

- (void) getUserFacebookInfo {
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"}];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSString *pictureURL = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
            
            [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:pictureURL]
                                     placeholderImage:[UIImage imageNamed:@"profile_placeholder.png"]
                                              options:SDWebImageRefreshCached];
            
            [self.userEmailLabel setText:[result objectForKey:@"email"]];
            [self.userNameLabel setText:[result objectForKey:@"name"]];
        }
        else{
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
    [connection start];
}

- (void) getUserIngredientOptions {
    
    [SVProgressHUD show];
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorization:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/options/ingredients", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager GET:url
                                           parameters:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  if ([[responseObject objectForKey:@"carne"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                      [self.meatSwitch setOn:NO];
                                                  }
                                                  
                                                  if ([[responseObject objectForKey:@"gluten"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                      [self.glutenSwitch setOn:NO];
                                                  }
                                                  
                                                  if ([[responseObject objectForKey:@"ovo"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                      [self.eggSwitch setOn:NO];
                                                  }
                                                  
                                                  if ([[responseObject objectForKey:@"leite"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                      [self.milkSwitch setOn:NO];
                                                  }
                                                  
                                                  [SVProgressHUD dismiss];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Não foi possível receber suas preferências. Por favor, tente novamente mais tarde."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
}


- (IBAction)meatSwitchValueChanged:(id)sender {
    
    if (self.meatSwitch.isOn)
        [self includeOption:@"carne"];
    else
        [self excludeOption:@"carne"];
}

- (IBAction)glutenSwitchValueChanged:(id)sender {
    
    if (self.glutenSwitch.isOn)
        [self includeOption:@"gluten"];
    else
        [self excludeOption:@"gluten"];
}

- (IBAction)eggSwitchValueChanged:(id)sender {
    
    if (self.eggSwitch.isOn)
        [self includeOption:@"ovo"];
    else
        [self excludeOption:@"ovo"];
}

- (IBAction)milkSwitchValueChanged:(id)sender {
 
    if (self.milkSwitch.isOn)
        [self includeOption:@"leite"];
    else
        [self excludeOption:@"leite"];
}

- (void) includeOption:(NSString *) option {
    
    [SVProgressHUD show];
    
    NSDictionary *parameters = @{@"ingredient_name": option};
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorizationHTTPResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/options/ingredient/include", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  
                                                  if ([option isEqualToString:@"carne"]) {
                                                      [self.meatSwitch setOn:![self.meatSwitch isOn]];
                                                  } else if ([option isEqualToString:@"gluten"]) {
                                                      [self.glutenSwitch setOn:![self.glutenSwitch isOn]];
                                                  } else if ([option isEqualToString:@"ovo"]) {
                                                      [self.eggSwitch setOn:![self.eggSwitch isOn]];
                                                  } else if ([option isEqualToString:@"leite"]) {
                                                      [self.milkSwitch setOn:![self.milkSwitch isOn]];
                                                  }
                                                  
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Não foi possível atualizar suas preferências. Por favor, tente novamente mais tarde."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
}

- (void) excludeOption:(NSString *) option {
    
    [SVProgressHUD show];
    
    NSDictionary *parameters = @{@"ingredient_name": option};
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorizationHTTPResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/options/ingredient/exclude", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  
                                                  if ([option isEqualToString:@"carne"]) {
                                                      [self.meatSwitch setOn:![self.meatSwitch isOn]];
                                                  } else if ([option isEqualToString:@"gluten"]) {
                                                      [self.glutenSwitch setOn:![self.glutenSwitch isOn]];
                                                  } else if ([option isEqualToString:@"ovo"]) {
                                                      [self.eggSwitch setOn:![self.eggSwitch isOn]];
                                                  } else if ([option isEqualToString:@"leite"]) {
                                                      [self.milkSwitch setOn:![self.milkSwitch isOn]];
                                                  }
                                                  
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Não foi possível atualizar suas preferências. Por favor, tente novamente mais tarde."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
