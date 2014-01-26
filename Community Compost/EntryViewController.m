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

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue {
    NSLog(@"Unwind");
//    UIViewController *sourceViewController = unwindSegue.sourceViewController;
}

@end
