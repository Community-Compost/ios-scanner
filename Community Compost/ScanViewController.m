//
//  ScanViewController.m
//  Community Compost
//
//  Created by Amy Coelho on 1/25/14.
//  Copyright (c) 2014 Community Compost. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
@end

@implementation ScanViewController

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
    
    // Initially make the captureSession object nil.
    self.captureSession = nil;
    
    // Set the initial value of the flag to NO.
    self.isReading = NO;
    
    if (!_isReading) {
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    NSLog(@"Scanning started.");

    return YES;
}

- (void)stopReading {
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    NSLog(@"Scanning stopped.");
    
    [self performSegueWithIdentifier:@"unwind" sender:self];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            self.binID = [metadataObj stringValue];
            NSLog(@"User ID: %@", self.binID);
            [self.delegate scannedItem:[metadataObj stringValue]];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
            
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self stopReading];
}

@end
