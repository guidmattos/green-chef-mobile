//
//  OrderConfirmationViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 11/4/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#define CASH 2
#define CARD 1

#import "OrderConfirmationViewController.h"
#import "HTTPRequest.h"
#import "SVProgressHUD.h"

@interface OrderConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitRecipeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *peopleNumberStepper;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property NSInteger numberOfPeople;
@property double recipeUnitValue;
@property NSInteger paymentMethodSelected;

@end

@implementation OrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.recipeNameLabel setText:self.order.recipe.name];
    NSString *deliveryAddress;
    if (![self.order.deliveryAddressComplement isEqualToString:@"-"]) {
        deliveryAddress = [NSString stringWithFormat:@"%@, %@ - %@", self.order.deliveryAddress, self.order.deliveryAddressNumber, self.order.deliveryAddressComplement];
    } else {
        deliveryAddress = [NSString stringWithFormat:@"%@, %@", self.order.deliveryAddress, self.order.deliveryAddressNumber];
    }
    [self.addressLabel setText:deliveryAddress];
    
    self.recipeUnitValue = self.order.recipe.unityValue;
    self.numberOfPeople = 1;
    self.peopleNumberStepper.minimumValue = 1.0;
    [self.unitRecipeValueLabel setText:[NSString stringWithFormat:@"%.2f", self.recipeUnitValue]];
    [self.totalOrderValueLabel setText:[NSString stringWithFormat:@"%.2f", self.numberOfPeople * self.recipeUnitValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setCashSelected:(id)sender {
    self.paymentMethodSelected = CASH;
    [self.cashButton setBackgroundColor:[UIColor colorWithRed:2.0/255 green:179.0/255 blue:1.0/255 alpha:1]];
    [self.cardButton setBackgroundColor:[UIColor colorWithRed:137.0/255 green:34.0/255 blue:37.0/255 alpha:1]];
}

- (IBAction)setCardSelected:(id)sender {
    self.paymentMethodSelected = CARD;
    [self.cardButton setBackgroundColor:[UIColor colorWithRed:2.0/255 green:179.0/255 blue:1.0/255 alpha:1]];
    [self.cashButton setBackgroundColor:[UIColor colorWithRed:137.0/255 green:34.0/255 blue:37.0/255 alpha:1]];
}

- (IBAction)peopleNumberChanged:(UIStepper *)sender {
    
    self.numberOfPeople = (int) [sender value];
    [self.peopleNumberLabel setText:[NSString stringWithFormat:@"%ld", (long) self.numberOfPeople]];
    [self.totalOrderValueLabel setText:[NSString stringWithFormat:@"%.2f", self.numberOfPeople * self.recipeUnitValue]];
}

- (IBAction)confirmOrder:(id)sender {
    
    if (self.paymentMethodSelected == CARD)
        self.order.paymentMethod = @"CARD";
    if (self.paymentMethodSelected == CASH)
        self.order.paymentMethod = @"CASH";
    self.order.totalValue = self.totalOrderValueLabel.text;
    self.order.peopleServed = self.peopleNumberLabel.text;
    
    if(!self.paymentMethodSelected ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                        message:@"Por favor, escolha um método de pagamento!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    [SVProgressHUD show];
    
    NSDictionary *parameters = @{@"address": self.order.deliveryAddress,
                                 @"number" : self.order.deliveryAddressNumber,
                                 @"complement" : self.order.deliveryAddressComplement,
                                 @"quantity_of_people" : self.order.peopleServed,
                                 @"recipe_id" : self.order.recipe.dbId,
                                 @"payment_method" : self.order.paymentMethod};
    
    // Manager
    HTTPRequest *manager = [[HTTPRequest alloc] initWithAuthorizationHTTPResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/order", BASE_URL];
    
    // Operation
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  [self performSegueWithIdentifier:@"ConfirmOrderSegue" sender:self];
                                                  
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"FAILURE");
                                                  [SVProgressHUD dismiss];
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                                                  message:@"Não foi possível enviar o seu pedido no momento. Por favor, tente novamente mais tarde."
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    [operation start];
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
