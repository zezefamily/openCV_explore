//
//  ViewController.m
//  openCV_explore
//
//  Created by 泽泽 on 2020/9/9.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVSample.h"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/core/types.hpp>
using namespace cv;
using namespace std;
using namespace cv::cuda;
@interface ViewController ()<CvVideoCameraDelegate>
{
    
}
@property (nonatomic,strong) CvVideoCamera *videoCamera;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    OpenCVSample *sample = [[OpenCVSample alloc]init];
    UIImageView *captureView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 640, 480)];
    captureView.center = self.view.center;
    captureView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:captureView];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:captureView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeSystem];
    start.frame = CGRectMake(100, 100, 100, 50);
    [start setTitle:@"开始" forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    UIButton *stop = [UIButton buttonWithType:UIButtonTypeSystem];
    stop.frame = CGRectMake(100, 100+60, 100, 50);
    [stop setTitle:@"停止" forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopCapture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
    
    
    [self loadCascade];
}

- (void)startCapture
{
    [self.videoCamera start];
}
- (void)stopCapture
{
    [self.videoCamera stop];
}
#ifdef __cplusplus
// delegate method for processing image frames
- (void)processImage:(cv::Mat&)image
{
    // Do some OpenCV stuff with the image
//    Mat image_copy;
//    cvtColor(image, image_copy, COLOR_BGR2GRAY);
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    //Convert BGR to BGRA (three channel to four channel)
//    Mat bgr;
//    cvtColor(image_copy, bgr, COLOR_GRAY2BGR);
//    cvtColor(bgr, image, COLOR_BGR2BGRA);
    
    detectAndDisplay(image);
    
//    UIImage *bufferImg = [OpenCVSample UIImageFromCVMat2:image];
//    CIContext *context = [CIContext contextWithOptions:nil];
//
//    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
//    NSArray *faces = [faceDetector featuresInImage:bufferImg.CIImage];
    
//    cv::Mat img;
//    vector<cv::Rect> faceRects;
//    double scalingFactor = 1.1;
//    int minNeighbors = 2;
//    int flags = 0;
//    cv::Size minimumSize(30,30);
//    face_cascade.detectMultiScale(image, faceRects,scalingFactor, minNeighbors, flags,cv::Size(30, 30));
    
    
}

CascadeClassifier face_cascade;
CascadeClassifier eyes_cascade;

- (void)loadCascade
{
    int a =  cv::cuda::getCudaEnabledDeviceCount();
    if(a == 0){
       NSLog(@"当前设备opencv 不支持GPU加速");
    }
    
    NSString *face_cascade_path = [[NSBundle mainBundle]pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];

    const CFIndex CASCADE_NAME_LEN = 2048;
    
    char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)face_cascade_path, CASCADE_NAME, CASCADE_NAME_LEN);
//    CascadeClassifier faceDetector;
    face_cascade.load(CASCADE_NAME);
    
    NSString *eyes_cascade_path = [[NSBundle mainBundle]pathForResource:@"haarcascade_eye_tree_eyeglasses" ofType:@"xml"];
    char *CASCADE_NAME_2 = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)eyes_cascade_path, CASCADE_NAME_2, CASCADE_NAME_LEN);
    eyes_cascade.load(CASCADE_NAME_2);
    
////    face_cascade = CascadeClassifier(face_cascade_path.UTF8String);
////    eyes_cascade = CascadeClassifier(eyes_cascade_path.UTF8String);
//    if(!face_cascade.load(face_cascade_path.UTF8String)){
//        cout << "--(!)Error loading face cascade\n";
//        return;
//    }
//    if(!eyes_cascade.load(eyes_cascade_path.UTF8String)){
//        cout << "--(!)Error loading eyes cascade\n";
//        return;
//    }
}

void detectAndDisplay(Mat frame)
{
    Mat frame_gray;
    cvtColor( frame, frame_gray, COLOR_BGR2GRAY);
    equalizeHist( frame_gray, frame_gray );
    //-- Detect faces
    std::vector<cv::Rect> faces;
    face_cascade.detectMultiScale(frame_gray, faces);
    for ( size_t i = 0; i < faces.size(); i++ )
    {
        cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
        ellipse( frame, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, Scalar( 255, 0, 255 ), 4 );
        Mat faceROI = frame_gray( faces[i] );
//        -- In each face, detect eyes
        std::vector<cv::Rect> eyes;
        eyes_cascade.detectMultiScale( faceROI, eyes );
        for ( size_t j = 0; j < eyes.size(); j++ )
        {
            cv::Point eye_center( faces[i].x + eyes[j].x + eyes[j].width/2, faces[i].y + eyes[j].y + eyes[j].height/2 );
            int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25 );
            circle(frame, eye_center, radius, Scalar( 255, 0, 0 ), 4 );
        }
    }
    //-- Show what you got
//    imshow( "Capture - Face detection", frame);
}

#endif


@end




