//
//  HomeTabBarViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 11/6/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "HomeTabBarViewController.h"

@interface HomeTabBarViewController ()

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
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
