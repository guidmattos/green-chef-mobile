//
//  DeliveryViewController.h
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Recipe.h"

@interface DeliveryViewController : BaseViewController <UITextFieldDelegate>

@property Recipe *recipe;

@end
