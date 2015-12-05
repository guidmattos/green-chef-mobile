//
//  RecipeTableViewCell.h
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeUnitValueLabel;

- (void)fillWithRecipe:(Recipe *) recipe;

@end
