//
//  BInformationPhotoDetailViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"

@interface BInformationPhotoDetailViewController : BaseViewController<UIScrollViewDelegate, UIWebViewDelegate> {
    UIScrollView *pictureScrollView;
    UIPageControl *picturePageControl;
    int pictureLoadCount;
    
    UILabel *descriptionView;
}

@property (nonatomic,retain) NSMutableArray *infoPictureArr;

@end
