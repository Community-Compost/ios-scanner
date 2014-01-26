//
//  CCViewController.h
//  Community Compost
//
//  Created by Amy Coelho on 1/24/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CCViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate> {
    NSURLConnection *currentConnection;
}

@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userWeightLabel;

@property (copy, nonatomic) NSString *userID;
@property (retain, nonatomic) NSMutableData *apiReturnData;

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIView *viewEntry;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanButton;

- (void)getUserInfo:(NSString *)binID;

- (IBAction)getButton:(id)sender;
- (IBAction)updateUserWeight:(id)sender;
- (IBAction)startStopReading:(id)sender;

@end
