//
//  EntryViewController.m
//  Community Compost
//
//  Created by Amy Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.weightLabel.text = @"0.00";
    self.userNameLabel.text = @"";
    self.userAddressLabel.text = @"";
    self.userWeightLabel.text = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)scanViewControllerDidFinish:(ScanViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue {
    NSLog(@"Unwind");
    [self getUserInfo:@"1234567890"];
    //    UIViewController *sourceViewController = unwindSegue.sourceViewController;
}

#pragma mark - Keypad

- (IBAction)numberButtonPressed:(id)sender {
    NSInteger i = [sender tag];
    NSString *currentValue = self.weightLabel.text;
    NSUInteger currentLength = [currentValue length];
    if (currentLength < 5) {
        NSString *updatedValue = [currentValue stringByAppendingFormat:@"%ld", (long)i];
        CGFloat floatValue = (CGFloat)[updatedValue floatValue];
        self.weightLabel.text = [NSString stringWithFormat:@"%0.2f",floatValue*10];
    }
}

- (IBAction)clearButtonPressed:(id)sender {
    self.weightLabel.text = @"0.00";
}

- (IBAction)submitButtonPressed:(id)sender {
    [self updateUserWeight:@"1234567890"];
    [self getUserInfo:@"1234567890"];
}

#pragma mark - API call
- (void)getUserInfo:(NSString *)binID {
    NSString *restCallString = [NSString stringWithFormat:@"http://compostdenton.com:3000/api/%@", binID ];
    
    // Clear out the return message label
    self.userNameLabel.text = @"";
    self.userAddressLabel.text = @"";
//    self.userIDLabel.text = @"";
    self.userWeightLabel.text = @"";
    
    // Create the URL to make the rest call.
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    // we will want to cancel any current connections
    if( currentConnection) {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc]   initWithRequest:restRequest delegate:self];
    
    // If the connection was successful, create the XML that will be returned.
    self.apiReturnData = [NSMutableData data];
}

- (void)updateUserWeight:(NSString *)binID {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://compostdenton.com:3000/api/%@", binID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //    NSString *jsonString = @"bin_id=%@&weight=%@",;
    NSString *bodydata=[NSString stringWithFormat:@"bin_id=%@&weight=%@", binID, self.weightLabel.text];
    
    NSData *requestBody=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", responseString);
}

// Delegates for NSURLConnection
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    [self.apiReturnData setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.apiReturnData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
    currentConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Connection Finished Loading");
    NSError *jsonError = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.apiReturnData options:0 error:&jsonError];
    if(!jsonError && result) {
        [_userNameLabel setText:[result valueForKey:@"name"]];
        [_userAddressLabel setText:[result valueForKey:@"address"]];
//        [_userIDLabel setText:[NSString stringWithFormat:@"%@",[result valueForKey:@"bin_id"]]];
        [_userWeightLabel setText:[NSString stringWithFormat:@"%@",[result valueForKey:@"weight"]]];
    }
    currentConnection = nil;
}

@end
