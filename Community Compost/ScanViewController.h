//
//  ScanViewController.h
//  Community Compost
//
//  Created by Gavin Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanViewController;

@protocol ScanViewControllerDelegate
- (void)scanViewControllerDidFinish:(ScanViewController *)controller;
@end

@interface ScanViewController : UIViewController

@property (weak, nonatomic) id <ScanViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
