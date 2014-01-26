//
//  ScanViewController.h
//  Community Compost
//
//  Created by Gavin Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "EntryViewController.h"

@class ScanViewController;

@protocol ScanViewControllerDelegate
- (void)scanViewControllerDidFinish:(ScanViewController *)controller;
- (void)scannedItem:(NSString *)scannedID;
@end

@interface ScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate> {
    NSURLConnection *currentConnection;
}
@property (weak, nonatomic) id <ScanViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *binID;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

- (IBAction)cancel:(id)sender;

@end
