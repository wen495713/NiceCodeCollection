//
//  VMCameraHelper.m
//  VMCameraHelper
//
//  Created by Vincent.Wen on 14-3-31.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import "VMCameraHelper.h"

#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>

@implementation VMCameraHelper

static VMCameraHelper *sharedInstance = nil;

- (void)initialize{
    NSError *error = nil;
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!captureInput) {
        NSLog(@"%@",error.debugDescription);
        return;
    }
    
    [self.session addInput:captureInput];
    
    self.catureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = @{AVVideoCodecJPEG: AVVideoCodecKey};
    
    self.catureOutput.outputSettings = outputSettings;
    
    [self.session addOutput:self.catureOutput];
}

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)embedPreviewInView:(UIView *)aView{
    if (!self.session) {
        return;
    }
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer:self.preview];
}

- (AVCaptureConnection *)connection{
    
    if (!_connection) {
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *_conn in self.catureOutput.connections) {
            for (AVCaptureInputPort *port in _conn.inputPorts) {
                if ([port.mediaType isEqual:AVMediaTypeAudio]) {
                    videoConnection = _conn;
                    break;
                }
            }
            if (videoConnection) {
                break;
            }
        }
        _connection = videoConnection;
    }
    return _connection;
}

- (void)catureImage{
    
    [self.catureOutput captureStillImageAsynchronouslyFromConnection:self.connection
                                                   completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                       CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, nil);
                                                       if (exifAttachments) {
                                                           
                                                       }
                                                       NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                       UIImage *_tmpImage = [UIImage imageWithData:imageData];
                                                       
                                                       self.image = [UIImage imageWithCGImage:_tmpImage.CGImage scale:1.5 orientation:UIImageOrientationRight];
                                                   }];
}

- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.imageOrientation = UIImageOrientationRight;
//        self.preview.orientation = AVCaptureVideoOrientationLandscapeRight;
        self.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.imageOrientation = UIImageOrientationLeft;
//        self.preview.orientation = AVCaptureVideoOrientationLandscapeLeft;
        self.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
}

#pragma mark Class Interface

+ (VMCameraHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)startRunning{
    [[[self sharedInstance] session] startRunning];
}

+ (void)stopRunning{
    [[[self sharedInstance] session] stopRunning];
}

+ (UIImage *)image{
    return [[self sharedInstance] image];
}

+ (void)captureStillImage{
    [[self sharedInstance] catureImage];
}

+ (void)embedPreviewInView:(UIView *)aView{
    [[self sharedInstance] embedPreviewInView:aView];
}

+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[self sharedInstance] changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation];
}

@end
