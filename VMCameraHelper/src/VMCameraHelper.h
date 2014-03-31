//
//  VMCameraHelper.h
//  VMCameraHelper
//
//  Created by Vincent.Wen on 14-3-31.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface VMCameraHelper : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *catureOutput;
@property (strong, nonatomic) AVCaptureConnection *connection;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) UIImageOrientation imageOrientation;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

/*
 开始运行
 **/
+ (void) startRunning;

/*
 停止运行
 **/
+ (void) stopRunning;

/*
 获取图片
 **/
+ (UIImage *) image;

/*
 获取静止的图片
 **/
+ (void)captureStillImage;

/*
 插入预览视图到主视图中
 **/
+ (void)embedPreviewInView: (UIView *)aView;

/*
 改变预览视图的方向
 **/
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
