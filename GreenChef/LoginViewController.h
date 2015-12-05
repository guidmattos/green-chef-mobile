//
//  ViewController.h
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 9/20/15.
//  Copyright (c) 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

-(void) login;

@end

