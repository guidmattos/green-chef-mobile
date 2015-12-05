//
//  LoginViewControllerTestcase.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/15/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LoginViewController.h"


@interface LoginViewControllerTestcase : XCTestCase

@property (nonatomic) LoginViewController *loginViewController;

@end

@implementation LoginViewControllerTestcase

- (void)setUp {
    [super setUp];
    self.loginViewController = [[LoginViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testLogoSize {
    XCTAssertEqual(self.loginViewController.logoImageView.frame.size.height, self.loginViewController.logoImageView.frame.size.width);
}

- (void)testValidLoginFields {
    
    [self.loginViewController.emailTextField setText:@"example@example.com"];
    [self.loginViewController.passwordTextField setText:@"teste123"];
    
    XCTAssertNil(self.loginViewController.emailTextField);
    XCTAssertNil(self.loginViewController.passwordTextField);
}


@end
