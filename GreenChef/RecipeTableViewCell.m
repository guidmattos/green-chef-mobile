//
//  RecipeTableViewCell.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "RecipeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RecipeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.recipeNameLabel.numberOfLines = 0;
    [self.recipeNameLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithRecipe:(Recipe *) recipe {
    
    [self.recipeNameLabel setText:recipe.name];
    [self.recipeUnitValueLabel setText:[NSString stringWithFormat:@"%.2f", recipe.unityValue]];
    [self.recipeImageView sd_setImageWithURL:[NSURL URLWithString:recipe.image] placeholderImage:[UIImage imageNamed:@"GreenChefLogo.jpg"]];
}

@end
