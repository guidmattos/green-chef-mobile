//
//  RecipeListViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeTableViewCell.h"
#import "Recipe.h"
#import "HTTPRequest.h"
#import "SVProgressHUD.h"
#import "RecipeDetailsViewController.h"

@interface RecipeListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *recipesList;
@property NSIndexPath *selectedRecipeIndexPath;
@property Recipe *selectedRecipe;

@end

@implementation RecipeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    self.recipesList = [[NSMutableArray alloc] init];
    
    [SVProgressHUD show];
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorization:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/recipes", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager GET:url
                                           parameters:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  for (NSDictionary *dict in [responseObject objectForKey:@"recipes"]) {
                                                      [self.recipesList addObject:[[Recipe alloc] initWithDictionary:dict]];
                                                  }
                                                  
                                                  [self.tableView reloadData];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Usuário e/ou senha incorretos."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
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
    
    Recipe *recipe = [self.recipesList objectAtIndex:indexPath.row];
    [cell fillWithRecipe:recipe];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedRecipe = [self.recipesList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"RecipeDetailSegue" sender:self];
    self.selectedRecipeIndexPath = indexPath;

}

-(void)viewWillDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:self.selectedRecipeIndexPath animated:NO];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    RecipeDetailsViewController *viewController = [segue destinationViewController];
    viewController.recipe = self.selectedRecipe;
}


@end
