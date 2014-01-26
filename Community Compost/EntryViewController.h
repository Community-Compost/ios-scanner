//
//  EntryViewController.h
//  Community Compost
//
//  Created by Amy Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import "ScanViewController.h"

#import <CoreData/CoreData.h>

@interface EntryViewController : UIViewController <ScanViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
