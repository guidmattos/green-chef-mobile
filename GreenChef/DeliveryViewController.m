//
//  DeliveryViewController.m
//  GreenChef
//
//  Created by Guilherme Duarte Mattos on 10/26/15.
//  Copyright © 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import "DeliveryViewController.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface DeliveryViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPeopleTextField;

@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -23.4823096;
    zoomLocation.longitude= -46.5014849;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
