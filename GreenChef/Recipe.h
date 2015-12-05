//
//  Recipe.h
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 11/5/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property NSString *dbId;
@property NSString *name;
@property NSString *image;
@property NSString *dificulty;
@property NSString *peopleServed;
@property double unityValue;

-(Recipe *) initWithDictionary:(NSDictionary *) dict;

@end
