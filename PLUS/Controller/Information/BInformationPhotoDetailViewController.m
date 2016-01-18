//
//  BInformationPhotoDetailViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BInformationPhotoDetailViewController.h"
#import "ImageCache.h"

@interface BInformationPhotoDetailViewController ()

@end

@implementation BInformationPhotoDetailViewController
@synthesize infoPictureArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self creatAnnouncements];
    NSLog(@"INFO PICTURE ARR : %@",self.infoPictureArr);
    
    [self creatUI];
    
    for (NSDictionary *dict in self.infoPictureArr) {
        [self loadImageWithUrl:[dict objectForKey:@"strPicture"]];
    }
    
    [self reloadPictureViewer]; //TESTING
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UI

- (void)creatUI{
    
    pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+statusBarHeight, 320, 240)];
	pictureScrollView.contentSize = CGSizeMake(1 * 320.0f, pictureScrollView.frame.size.height);
	pictureScrollView.pagingEnabled = YES;
	pictureScrollView.delegate = self;
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    [pictureScrollView setTag:111];
    [self.view addSubview:pictureScrollView];
    
    picturePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 270+statusBarHeight, 300, 20)];
    picturePageControl.numberOfPages = [self.infoPictureArr count];
	picturePageControl.currentPage = 0;
	[picturePageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:picturePageControl];
    
    descriptionView = [[UILabel alloc] initWithFrame:CGRectMake(10, 310+statusBarHeight, 300, self.view.frame.size.height-64-220)];
    [descriptionView setNumberOfLines:0];
    [descriptionView setFont:[UIFont systemFontOfSize:14]];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:descriptionView];
    
    
    if (self.infoPictureArr && [self.infoPictureArr count] > 0) {
        NSString *description = [[self.infoPictureArr objectAtIndex:0] objectForKey:@"strDescription"];
        
        CGSize labelSize = CGSizeMake(0.0f, 0.0f);
        if (![description isEqualToString:@""]) {
            labelSize = [description sizeWithFont:descriptionView.font
                                constrainedToSize:CGSizeMake(300, 240)
                                    lineBreakMode:descriptionView.lineBreakMode];
        }
        [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, descriptionView.frame.origin.y,
                                             labelSize.width, labelSize.height)];
        [descriptionView setText:description];
    }
}

- (void)reloadPictureViewer {
    int count = [self.infoPictureArr count];
    
    pictureScrollView.contentSize = CGSizeMake(count * pictureScrollView.frame.size.width,
                                               pictureScrollView.frame.size.height);
    [pictureScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!self.infoPictureArr || self.infoPictureArr.count <=0) {
        return;
    }
    
    CGFloat maxY = 0;
    for (int i = 0; i < count; i++) {
        NSDictionary *dict = [infoPictureArr objectAtIndex:i];
        UIImage *picture = (UIImage *)[dict objectForKey:@"image_data"];
        
        if (!picture || picture == nil) {
            CGSize pictureViewSize = CGSizeMake(320, 240);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0.0f,
                                                                                   pictureViewSize.width,
                                                                                   pictureViewSize.height)];
            [imageView setImage:[UIImage imageNamed:@"no_image.png"]];
            
            if (maxY == 0) {
                maxY = imageView.bounds.size.height;
            }
            
            [pictureScrollView addSubview:imageView];
            
        } else {
            CGSize pictureViewSize = CGSizeMake(320, 240);
            
            // set up box frame
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0.0f,
                                                                                   pictureViewSize.width,
                                                                                   pictureViewSize.height)];
            [imageView setImage:picture];
            
            if (maxY == 0) {
                maxY = imageView.bounds.size.height;
            }
            
            [pictureScrollView addSubview:imageView];
        }
        
    }
    
    [pictureScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
    int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	pictureScrollView.contentOffset = CGPointMake(pictureScrollView.bounds.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
    if ([aScrollView tag] == 111) {
        CGPoint offset = aScrollView.contentOffset;
        picturePageControl.currentPage = offset.x / pictureScrollView.bounds.size.width;
        
        NSString *description = [[self.infoPictureArr objectAtIndex:picturePageControl.currentPage] objectForKey:@"strDescription"];
        
        CGSize labelSize = CGSizeMake(0.0f, 0.0f);
        if (![description isEqualToString:@""]) {
            labelSize = [description sizeWithFont:descriptionView.font
                                constrainedToSize:CGSizeMake(300, 240)
                                    lineBreakMode:descriptionView.lineBreakMode];
        }
        [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, descriptionView.frame.origin.y,
                                             labelSize.width, labelSize.height)];
        [descriptionView setText:description];
    }
}

#pragma mark - ImageCache
- (void)loadImageWithUrl:(NSString *)url {
	
	if (url && [url length] > 0) {
		NSString *_cacheKey = [[NSString alloc] initWithFormat:@"icon_%@", url];
		if ( [[ImageCache sharedImageCache] hasImageWithKey:_cacheKey] ) {
			// if cache exist, load from cache
            
            pictureLoadCount--;
            for (NSMutableDictionary *new in infoPictureArr) {
                if ([url isEqualToString:[new objectForKey:@"strPicture"]]) {
                    [new setObject:[[ImageCache sharedImageCache] imageForKey:_cacheKey] forKey:@"image_data"];
                }
            }
            
            [self performSelector:@selector(reloadPictureViewer)];
            
		} else {
			NSMutableDictionary *_imageDictionary = [NSMutableDictionary dictionary];
			[_imageDictionary setObject:url forKey:@"photoUrl"];
			[self performSelectorInBackground:@selector(loadImageInSubThread:) withObject:_imageDictionary];
		}
	}
}

- (void)loadImageInSubThread:(NSMutableDictionary *)imageDictionary {
	
    NSURL *_url = [NSURL URLWithString:[imageDictionary objectForKey:@"photoUrl"]];
	NSData *_imageData = [[NSData alloc] initWithContentsOfURL:_url];
	if (_imageData) {
		UIImage *_image = [[UIImage alloc] initWithData:_imageData];
		if (_image)
			[imageDictionary setObject:_image forKey:@"image"];
	}
    
	[self performSelectorOnMainThread:@selector(processShowImage:) withObject:imageDictionary waitUntilDone:YES];
}

- (void)processShowImage:(NSMutableDictionary *)imageDictionary {
    
	UIImage *image = [imageDictionary objectForKey:@"image"];
	if (image) {
		NSString *url = [imageDictionary objectForKey:@"photoUrl"];
        
        NSString *_cacheKey = [[NSString alloc] initWithFormat:@"icon_%@", url];
		[[ImageCache sharedImageCache] storeImage:image withKey:_cacheKey];
        
        pictureLoadCount--;
        for (NSMutableDictionary *new in infoPictureArr) {
            if ([url isEqualToString:[new objectForKey:@"strPicture"]]) {
                [new setObject:image forKey:@"image_data"];
            }
        }
        
        [self performSelector:@selector(reloadPictureViewer)];
	}
}

@end