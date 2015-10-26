//
//  RecipeListViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeTableViewCell.h"

@interface RecipeListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *recipesList;

@end

@implementation RecipeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.tableView registerNib:[UINib nibWithNibName:@"RecipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipeTableViewCell"];
    self.recipesList = [[NSMutableArray alloc] init];
    [self.recipesList addObject:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeTableViewCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecipeTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"RecipeDetailSegue" sender:self];
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
