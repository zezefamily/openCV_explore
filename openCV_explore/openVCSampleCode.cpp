//
//  openVCSampleCode.cpp
//  openCV_explore
//
//  Created by 泽泽 on 2020/9/9.
//  Copyright © 2020 泽泽. All rights reserved.
//


#include "openVCSampleCode.hpp"
#include "opencv2/core.hpp"

using namespace cv;



void SampleClass::ShowMsg(const char * msg){
    printf("%s", msg);
    cv::Mat A(100,100,CV_64F);
    cv::Mat B = A;
    Mat C = B.row(3);
    Mat D = B.clone();
    B.row(5).copyTo(C);
    A = D;
    B.release();
    C = C.clone();
    

}

