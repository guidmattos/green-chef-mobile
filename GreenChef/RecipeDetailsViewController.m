//
//  RecipeDetailsViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "IngredientTableViewCell.h"

@interface RecipeDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *ingredientsList;

@end

@implementation RecipeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ingredientsList = [[NSMutableArray alloc] initWithObjects:@"2 colheres de sopa de farinha de trigo",
                            @"300 ml de leite",
                            @"2 colheres de sopa de manteiga ou margarina",
                            @"1 pitada de sal",
                            @"50 g de queijo ralado",
                            @"4 ovos",
                            @"Legumes cozidos e cortados em cubos", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredientsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientTableViewCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IngredientTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell.titleLabel setText:[self.ingredientsList objectAtIndex:indexPath.row]];
    return cell;
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
