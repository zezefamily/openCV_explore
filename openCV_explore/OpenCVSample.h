//
//  OpenCVSample.h
//  openCV_explore
//
//  Created by 泽泽 on 2020/9/9.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVSample : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;

+ (cv::Mat)cvMatFromUIImage2:(UIImage *)image;

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

+ (UIImage *)UIImageFromCVMat2:(cv::Mat)cvMat;

+ (NSData *)NSDataFromCVMat:(cv::Mat)cvMat;

@end

NS_ASSUME_NONNULL_END
