//
//  RecipeDetailsViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "IngredientTableViewCell.h"
#import "HTTPRequest.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DeliveryViewController.h"

@interface RecipeDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *preparationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property NSMutableArray *ingredientsList;
@property NSMutableArray *preparationList;

@end

@implementation RecipeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ingredientsList = [[NSMutableArray alloc] init];
    self.preparationList = [[NSMutableArray alloc] init];
    
    [SVProgressHUD show];
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorization:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/recipe/%@", BASE_URL, self.recipe.dbId];
    [self.preparationLabel setText:@""];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager GET:url
                                          parameters:nil
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 
                                                 [SVProgressHUD dismiss];
                                                 [self.recipeImageView sd_setImageWithURL:[NSURL URLWithString:self.recipe.image] placeholderImage:[UIImage imageNamed:@"GreenChefLogo.jpg"]];
                                                 for (NSDictionary *dict in [responseObject objectForKey:@"stages"]) {
                                                     
                                                     self.ingredientsList = (NSMutableArray *) [dict objectForKey:@"ingredients"];
                                                     self.preparationList = (NSMutableArray *) [dict objectForKey:@"prepare"];
                                                     
                                                 }
                                                 
                                                 NSString *temp = @"";
                                                 
                                                 for (NSString *prepareStage in self.preparationList) {
                                                     
                                                     temp = [NSString stringWithFormat:@"%@ %@", temp, prepareStage];
                                                 }
                                                 
                                                 [self.preparationLabel setText:temp];
                                                 [self.tableView reloadData];
                                                 
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"FAILURE");
                                                 [SVProgressHUD dismiss];
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                 message:@"Falha ao carregar a receita. Por favor, tente novamente mais tarde"
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DeliveryViewController *viewController = [segue destinationViewController];
    viewController.recipe = self.recipe;
}


@end
