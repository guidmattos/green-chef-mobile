//
//  DeliveryViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "DeliveryViewController.h"
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"
#import "OrderConfirmationViewController.h"
#define METERS_PER_MILE 1609.344

@interface DeliveryViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressComplementTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmAddressButton;
@property CLLocationManager *locationManager;
@property Order *order;

@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.locationManager.location.coordinate.latitude;
    zoomLocation.longitude= self.locationManager.location.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchAddress:(id)sender {
    
    if (!self.addressTextField.text || [self.addressTextField.text isEqualToString:@""] || !self.addressNumberTextField.text || [self.addressNumberTextField.text isEqualToString:@""]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                             message:@"Por favor preencha todos os campos"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        return;
    }
    
    if(!self.addressComplementTextField.text || [self.addressComplementTextField.text isEqualToString:@""]) {
        [self.addressComplementTextField setText:@"-"];
    }
    
    NSString *location = [NSString stringWithFormat:@"%@, %@ - %@", self.addressTextField.text, self.addressNumberTextField.text, self.addressComplementTextField.text];
    
    [SVProgressHUD show];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         
                         [self.confirmAddressButton setEnabled:YES];
                         [self.confirmAddressButton setAlpha:1.0];
                         
                         [SVProgressHUD dismiss];
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:placemark];
                     } else {
                         
                         [SVProgressHUD dismiss];
                         UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                                              message:@"Falha ao localizar o endereço informado. Por favor, corrija e tente novamente!"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                         [errorAlert show];
                     }
                 }
     ];
}



- (IBAction)confirmAdress:(id)sender {
    
    self.order = [[Order alloc] init];
    self.order.recipe = self.recipe;
    self.order.deliveryAddress = self.addressTextField.text;
    self.order.deliveryAddressNumber = self.addressNumberTextField.text;
    self.order.deliveryAddressComplement = self.addressComplementTextField.text;
    
    [self performSegueWithIdentifier:@"OrderConfirmationSegue" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrderConfirmationViewController *viewController = [segue destinationViewController];
    viewController.order = self.order;
}


@end
