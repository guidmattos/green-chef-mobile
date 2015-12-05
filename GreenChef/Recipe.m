//
//  Recipe.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 11/5/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

-(Recipe *) initWithDictionary:(NSDictionary *) dict {
    
    self.dbId = [dict objectForKey:@"id"];
    self.name = [dict objectForKey:@"nome"];
    self.image = [dict objectForKey:@"imagem"];
    self.dificulty = [dict objectForKey:@"dificuldade"];
    self.peopleServed = [dict objectForKey:@"quantidade"];
    self.unityValue = [[dict objectForKey:@"valor"] doubleValue];
    return self;
}

@end
