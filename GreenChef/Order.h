//
//  Order.h
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 11/17/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface Order : NSObject

@property Recipe *recipe;
@property NSString *deliveryAddress;
@property NSString *deliveryAddressNumber;
@property NSString *deliveryAddressComplement;
@property NSString *peopleServed;
@property NSString *totalValue;
@property NSString *paymentMethod;

@end
