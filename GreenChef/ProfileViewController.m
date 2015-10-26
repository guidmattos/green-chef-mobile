//
//  ProfileViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "ProfileViewController.h"
#import "IngredientTableViewCell.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *ingredientTextField;
@property NSMutableArray *ingredientList;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ingredientList = [[NSMutableArray alloc] initWithObjects:@"Ovo",
                           @"Leite", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addIngredient:(id)sender {
    if (![self.ingredientTextField.text isEqualToString:@""]) {
        [self.ingredientList addObject:self.ingredientTextField.text];
        [self.ingredientTextField setText:@""];
        [self.tableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredientList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientTableViewCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IngredientTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell.titleLabel setText:[self.ingredientList objectAtIndex:indexPath.row]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.ingredientList removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
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
