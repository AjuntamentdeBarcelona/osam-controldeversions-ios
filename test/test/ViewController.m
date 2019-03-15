//
//  ViewController.m
//  test
//
//  Created by Jose Manuel Ramírez Martínez on 26/05/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import "ViewController.h"
#import "T21AlertComponent.h"
#import "T21ServiceComponent.h"
#import "T21LegalComponent.h"

#define kActionURL_Live 1

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action Methods
#pragma mark -

- (IBAction)alertViewWithoutButtons:(id)sender
{
    [_T21AlertComponent showAlertWithTitle:@"Alert Title" message:@"This is the message of the alert without buttons." okTitle:nil okActionURL:nil andCancelTitle:nil];
}

- (IBAction)alertViewWithOkButtons:(id)sender
{
    [_T21AlertComponent showAlertWithTitle:@"Alert Title" message:@"This is the message of the alert with ok button." okTitle:@"OK" okActionURL:nil andCancelTitle:nil];
}

- (IBAction)alertViewWithCancelAndOkButtonActionURL:(id)sender
{
    NSString *actionURL = @"http://www.google.com";
    [_T21AlertComponent showAlertWithTitle:@"Alert Title" message:@"This is the message of the alert with ok and cancel button." okTitle:@"OK" okActionURL:actionURL andCancelTitle:@"Cancel"];
}

- (IBAction)alertViewByServiceURL:(id)sender
{
    
    NSString *actionURL = kActionURL_Live ? @"http://www.bcn.cat/mobil/apps/controlVersions/bustiaciutadana/versionControl_ios.json" : @"alertData.txt";
    
    [_T21AlertComponent showAlertWithService:actionURL withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    /*
    NSString *actionURL = kActionURL_Live ? @"http://api.adventuriq.com/app_version_control.json" : @"alertData.txt";
    
    [_T21AlertComponent showAlertWithService:actionURL withLanguage:@"en" andCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];*/
        
    // Example: Check service enabled
    /*
    NSString *actionURL = @"https://fs1.tempos21.com/wwwpub-temporal/public/osam/geolocation.json";
    
    [_T21ServiceComponent verifyServiceEnabledURL:actionURL withCompletionBlock:^(BOOL isEnabled) {
        if (isEnabled) {
            NSLog(@"Test: Service is enabled");
        } else {
            NSLog(@"Test: Service is disabled");
        }
    }];*/
}


- (IBAction)alertViewByLegalURL:(id)sender {
    NSString* legalUrl = @"https://w9.bcn.cat/mobil/apps/controlVersions/butxaca/versionControl_ios.json";
    
    [_T21LegalComponent showLegalWithService:legalUrl withQueryParams:nil withConfigDict:nil withCompletionBlock:^(NSError *error) {
        if(error){
            NSLog(@"%@", error);
        }
    }];
}


@end
