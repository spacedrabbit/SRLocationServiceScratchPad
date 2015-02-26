//
//  ViewController.m
//  SRLocationScratchPad
//
//  Created by Tur, Louis on 2/26/15.
//  Copyright (c) 2015 Tur, Louis. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) UILabel * serviceStatus;

@property (strong, nonatomic) NSString * currentStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.currentStatus = @"Determining...";
    
    [self createLocationServicesButton];
    [self createServiceStatusLabel];
    
    [self createStopServicesButton];
}

-(void)createLocationServicesButton{
    UIButton * locationStartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [locationStartButton setFrame:CGRectMake(20, 100, 150, 60)];
    [locationStartButton setBackgroundColor:[UIColor purpleColor]];
    [locationStartButton setTitle:@"Start Services" forState:UIControlStateNormal];
    [locationStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [locationStartButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [locationStartButton addTarget:self action:@selector(startLocationServices:) forControlEvents:UIControlEventTouchUpInside];
    [locationStartButton setEnabled:YES];
    [self.view addSubview:locationStartButton];
}
-(void)createServiceStatusLabel{
    self.serviceStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 44 )];
    [self.serviceStatus setTextAlignment:NSTextAlignmentCenter];
    [self.serviceStatus setTextColor:[UIColor greenColor]];
    self.serviceStatus.text = self.currentStatus;
    [self.view addSubview:self.serviceStatus];
}
-(void)refreshLabel{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.serviceStatus.text = self.currentStatus;
    }];
}

-(void)createStopServicesButton{
    UIButton * locationEndButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [locationEndButton setFrame:CGRectMake(20, 240, 150, 60)];
    [locationEndButton setBackgroundColor:[UIColor orangeColor]];
    [locationEndButton setTitle:@"End Services" forState:UIControlStateNormal];
    [locationEndButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [locationEndButton.titleLabel setAdjustsFontSizeToFitWidth:YES];

    [locationEndButton addTarget:self action:@selector(denyLocationService) forControlEvents:UIControlEventTouchUpInside];
    [locationEndButton setEnabled:YES];
    [self.view addSubview:locationEndButton];
}
-(void)startLocationServices:(id)sender{
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Requesting...");
        [self.locationManager requestAlwaysAuthorization];
    }
}
-(void)denyLocationService{
    NSLog(@"Cancelling Request...");
    
    //opens user's settings menu
    NSURL * cancelSettingsMenu = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:cancelSettingsMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
 
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Status Not Determined");
            self.currentStatus = @"Status Not Determined";
            break;
        case kCLAuthorizationStatusRestricted :
            NSLog(@"Status Restricted");
            self.currentStatus = @"Status Restricted";
            break;
        case kCLAuthorizationStatusDenied :
            NSLog(@"Status Denied");
            self.currentStatus = @"Status Denied";
            break;
        case kCLAuthorizationStatusAuthorizedAlways :
            NSLog(@"Status Authorized Always");
            self.currentStatus = @"Status Authorized Always";
            break;
        case  kCLAuthorizationStatusAuthorizedWhenInUse :
            NSLog(@"Status Authorized When in Use");
            self.currentStatus = @"Status Authorized When in Use";
            break;
        default:
            NSLog(@"Unexpected status: %d", status);
            self.currentStatus = @"Unexpected Status";
            break;
    }
    
    [self refreshLabel];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Location Manager Started");
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error encountered: %@", error);
}

@end
