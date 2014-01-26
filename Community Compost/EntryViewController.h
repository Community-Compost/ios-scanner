//
//  EntryViewController.h
//  Community Compost
//
//  Created by Amy Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import "ScanViewController.h"

#import <CoreData/CoreData.h>

@interface EntryViewController : UIViewController <ScanViewControllerDelegate> {
    NSURLConnection *currentConnection;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userWeightLabel;
@property (retain, nonatomic) NSMutableData *apiReturnData;

- (IBAction)numberButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue;

@end
