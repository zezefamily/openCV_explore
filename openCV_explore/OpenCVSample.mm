//
//  OpenCVSample.m
//  openCV_explore
//
//  Created by 泽泽 on 2020/9/9.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "OpenCVSample.h"
#include "openVCSampleCode.hpp"
#import <opencv2/imgcodecs/ios.h>
@implementation OpenCVSample

// UIImage->cv::Mat
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
      CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
      CGFloat cols = image.size.width;
      CGFloat rows = image.size.height;
      //cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
      cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
      CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                     cols,                       // Width of bitmap
                                                     rows,                       // Height of bitmap
                                                     8,                          // Bits per component
                                                     cvMat.step[0],              // Bytes per row
                                                     colorSpace,                 // Colorspace
                                                     kCGImageAlphaNoneSkipLast |
                                                     kCGBitmapByteOrderDefault); // Bitmap info flags
      CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
      CGContextRelease(contextRef);
      return cvMat;
}

- (cv::Mat)cvMatFromUIImage2:(UIImage *)image
{
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4);
    UIImageToMat(image, cvMat);
    return cvMat;
}

//cv::Mat => UIImage
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [self NSDataFromCVMat:cvMat];
    CGColorSpaceRef colorSpace;
    if(cvMat.elemSize() == 1){
        colorSpace = CGColorSpaceCreateDeviceGray();
    }else{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                       cvMat.rows,                                 //height
                                       8,                                          //bits per component
                                       8 * cvMat.elemSize(),                       //bits per pixel
                                       cvMat.step[0],                            //bytesPerRow
                                       colorSpace,                                 //colorspace
                                       kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                       provider,                                   //CGDataProviderRef
                                       NULL,                                       //decode
                                       false,                                      //should interpolate
                                       kCGRenderingIntentDefault                   //intent
                                       );
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}
-(UIImage *)UIImageFromCVMat2:(cv::Mat)cvMat
{
    return MatToUIImage(cvMat);
}

//cvMat => NSData
- (NSData *)NSDataFromCVMat:(cv::Mat)cvMat
{
    return [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
}


@end
