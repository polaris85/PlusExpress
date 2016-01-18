//
//  BKembaraViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/23/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//
#define MAGAZINE_URL "http://plustrafik.plus.com.my/assets/magazines/"

#import "BKembaraViewController.h"
#import "BKembaraTableViewCell.h"
#import "Constants.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "BDMultiDownloader.h"

@interface BKembaraViewController ()
{
    NSMutableArray *pBarArray;
    NSMutableArray *downloadingStatusArray;
}

@end

@implementation BKembaraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = @"Kembara Plus";
    
    // Do any additional setup after loading the view.
    magazineArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self creatUI];
    [self creatKembaraData];
    
    [BDMultiDownloader shared].onDownloadProgressWithProgressAndSuggestedFilename = ^(double progress, NSString *filename){
        for (int i=0; i<magazineArray.count; i++) {
            NSString *url1 = [NSString stringWithFormat:@"%s%@", MAGAZINE_URL, [[magazineArray objectAtIndex:i] objectForKey:@"FileName"]];
            if ([[url1 lastPathComponent] isEqualToString:filename])
                [[pBarArray objectAtIndex:i] setProgress:progress animated:YES];
        }
        
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Kembara Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void) creatKembaraData
{
    //NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"magazines" ofType:@"plist"];
    //magazineArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    NSString *plistPath = @"http://plustrafik.plus.com.my/assets/magazines/Magazines.plist";
    magazineArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:plistPath]];
    NSLog(@"Magazines=%@", magazineArray);
    
    pBarArray = [[NSMutableArray alloc] initWithCapacity:magazineArray.count];
    downloadingStatusArray = [[NSMutableArray alloc] initWithCapacity:magazineArray.count];
    
    int padding = 10;
    int coverImageWidth = 180;
    int paddingTop = 35;
    if (IS_IPAD) {
        padding = 20;
        coverImageWidth = 360;
        paddingTop = 60;
    }
    for (int i=0; i<magazineArray.count; i++) {
        
        UIProgressView *progressView= [[UIProgressView alloc] initWithFrame:CGRectMake(padding, paddingTop, coverImageWidth-padding*2, 20.0f)];
        progressView.progress = 0.0;
        [pBarArray addObject:progressView];
        
        NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                      [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                      stringByAppendingPathComponent:@"Documents"
                                                                      ]];
        
        NSString *filePath = [resourceDocPath stringByAppendingPathComponent:[[magazineArray objectAtIndex:i] objectForKey:@"FileName"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [downloadingStatusArray addObject:@"2"];
        else
            [downloadingStatusArray addObject:@"0"];
    }
}
-(void) creatUI
{
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT + statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [background setImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:background];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorColor = [UIColor grayColor];
    table.scrollEnabled = YES;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"[[tollPlazaArray objectAtIndex:section] count]:%d",[[tollPlazaArray objectAtIndex:section] count]);
    
    return magazineArray.count;
}

- (BKembaraTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *data = [magazineArray objectAtIndex:indexPath.row];
    
    int titleFont = 16;
    int subTitleFont = 14;
    int paddingTop = 20;
    int labelWidth = 250;
    int labelHeight = 20;
    int coverImageWidth = 180;
    int coverImageHeight = 200;
    int downloadButtonHeight = 30;
    int padding = 10;
    int progressViewHeight = 44;
    if (IS_IPAD) {
        titleFont = 30;
        subTitleFont = 25;
        paddingTop = 40;
        padding = 20;
        labelWidth = 500;
        labelHeight = 40;
        coverImageWidth = 360;
        coverImageHeight = 400;
        downloadButtonHeight = 60;
        progressViewHeight = 88;
    }
    
    BKembaraTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BKembaraTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        if (magazineArray.count > 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.font = [UIFont systemFontOfSize:titleFont];
            cell.subTitleLabel.font = [UIFont systemFontOfSize:subTitleFont];
            
            cell.titleLabel.frame = CGRectMake((self.view.frame.size.width-labelWidth)/2, paddingTop, labelWidth, labelHeight);
            cell.subTitleLabel.frame = CGRectMake((self.view.frame.size.width-labelWidth)/2, paddingTop + labelHeight, labelWidth, labelHeight);
            cell.coverImageView.frame = CGRectMake((self.view.frame.size.width-coverImageWidth)/2, paddingTop + labelHeight*2, coverImageWidth, coverImageHeight);
            cell.downloadButton.frame = CGRectMake((self.view.frame.size.width-coverImageWidth)/2, paddingTop + labelHeight*2 + coverImageHeight + padding, coverImageWidth, downloadButtonHeight);
            cell.progressView.frame = CGRectMake((self.view.frame.size.width-coverImageWidth)/2, paddingTop + labelHeight*2 + coverImageHeight - progressViewHeight, coverImageWidth, progressViewHeight);
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.progressView.frame.size.width, cell.progressView.frame.size.height)];
            iv.backgroundColor = [UIColor blackColor];
            iv.alpha = 0.7;
            
            [cell.progressView addSubview:iv];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0f, cell.progressView.frame.size.width, labelHeight)];
            label.text = @"Download in progress";
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:subTitleFont];
            label.textAlignment = NSTextAlignmentCenter;
            
            [cell.progressView addSubview:label];
            
            cell.titleLabel.text = [data objectForKey:@"Title"];
            cell.subTitleLabel.text = [data objectForKey:@"Subtitle"];
            
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.titleLabel.backgroundColor = [UIColor clearColor];
            cell.subTitleLabel.textColor = [UIColor whiteColor];
            cell.subTitleLabel.backgroundColor = [UIColor clearColor];
            
            cell.downloadButton.tag = indexPath.row;
            [cell.downloadButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.progressView addSubview: [pBarArray objectAtIndex:indexPath.row]];
            
            if ([[downloadingStatusArray objectAtIndex:indexPath.row] intValue] == 0) {
                [cell.progressView setHidden:YES];
                [cell.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
            }else if ([[downloadingStatusArray objectAtIndex:indexPath.row] intValue] == 1) {
                [cell.progressView setHidden:NO];
                [cell.downloadButton setTitle:@"Cancel" forState:UIControlStateNormal];
            }else if ([[downloadingStatusArray objectAtIndex:indexPath.row] intValue] == 2) {
                [cell.progressView setHidden:YES];
                [cell.downloadButton setTitle:@"Read" forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%s%@", MAGAZINE_URL, [data objectForKey:@"FileName"]];
    NSString *coverURL = [strURL stringByReplacingOccurrencesOfString:@".pdf" withString:@".png"];
    UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:coverURL]]; //Img_URL is NSString of your image URL
    if (img) {       //If image is previously downloaded set it and we're done.
        [cell.coverImageView setImage:img];
        //[[SDImageCache sharedImageCache] removeImageForKey:coverURL fromDisk:YES];
    }else{
        [cell.coverImageView setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:nil success:^(UIImage *image, BOOL cached) {
        } failure:^(NSError *error) {
            
        }];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return 640;
    }
    return 320;
}

-(void) btnClick:(UIButton *) sender
{
    currentIndex = sender.tag;
    //NSString *url = @"http://162.242.225.64/CensorgramTest/Example-Result.pdf";
    
    UIView *parentCell = sender.superview;
    NSLog(@"Class=%@", [parentCell class]);
    if (![parentCell isKindOfClass:[BKembaraTableViewCell class]]) {
        parentCell = sender.superview.superview;
        if (![parentCell isKindOfClass:[BKembaraTableViewCell class]]) {
            parentCell = sender.superview.superview.superview;
            if (![parentCell isKindOfClass:[BKembaraTableViewCell class]]) {
                return;
            }
        }
    };
    BKembaraTableViewCell *cell = (BKembaraTableViewCell *)parentCell;
    
    NSInteger status = [[downloadingStatusArray objectAtIndex:sender.tag] intValue];
    
    if (status == 0) {
        [[pBarArray objectAtIndex:sender.tag] setProgress:0.0];
        [cell.progressView setHidden:NO];
        [cell.downloadButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [downloadingStatusArray replaceObjectAtIndex:sender.tag withObject:@"1"];
        
         NSString *url = [NSString stringWithFormat:@"%s%@", MAGAZINE_URL, [[magazineArray objectAtIndex:sender.tag] objectForKey:@"FileName"]];
        
        [[BDMultiDownloader shared] queueRequest:url
                                      completion:^(NSData *data){
                                          //if  (data == nil){
                                          //bail out if data is nil.
                                          //    return;
                                          
                                          NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                                                        [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                                                        stringByAppendingPathComponent:@"Documents"
                                                                                                        ]];
                                          
                                          NSArray* fileNameArray = [[[magazineArray objectAtIndex:sender.tag] objectForKey:@"FileName"] componentsSeparatedByString: @"/"];
                                          NSString* subFolderPath = [resourceDocPath stringByAppendingPathComponent:[fileNameArray objectAtIndex: 0]];
                                          NSString *filePath = [resourceDocPath stringByAppendingPathComponent:[[magazineArray objectAtIndex:sender.tag] objectForKey:@"FileName"]];
                                          
                                          NSLog(@"File Path=%@", subFolderPath);
                                          NSError *error;
                                          
                                          if (![[NSFileManager defaultManager] fileExistsAtPath:subFolderPath])
                                              [[NSFileManager defaultManager] createDirectoryAtPath:subFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
                                          
                                          [data writeToFile:filePath atomically:YES];
                                          
                                          [sender setTitle:@"Read" forState:UIControlStateNormal];
                                          
                                          [downloadingStatusArray replaceObjectAtIndex:sender.tag withObject:@"2"];
                                          // }
                                          
                                      }];
        
    }else if (status == 1) {
        [cell.progressView setHidden:YES];
//        [[pBarArray objectAtIndex:sender.tag] setProgress:0.0 animated:YES];
        [cell.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [downloadingStatusArray replaceObjectAtIndex:sender.tag withObject:@"0"];
        
        NSString *url = [NSString stringWithFormat:@"%s%@", MAGAZINE_URL, [[magazineArray objectAtIndex:sender.tag] objectForKey:@"FileName"]];
        [[BDMultiDownloader shared] dequeueWithPath:url];
        //[[BDMultiDownloader shared] clearQueue];
        
    }else if (status == 2) {
        [cell.progressView setHidden:YES];
        [cell.downloadButton setTitle:@"Read" forState:UIControlStateNormal];
        [downloadingStatusArray replaceObjectAtIndex:sender.tag withObject:@"2"];
        
        NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
        
        NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                      [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                      stringByAppendingPathComponent:@"Documents"
                                                                      ]];
        
        NSString *filePath = [resourceDocPath stringByAppendingPathComponent:[[magazineArray objectAtIndex:sender.tag] objectForKey:@"FileName"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
            
            if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
            {
                ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
                
                readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                
                readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentViewController:readerViewController animated:YES completion:NULL];
                
                //            [self.navigationController pushViewController:readerViewController animated:YES];
                
            }
            else // Log the error so that we know that something went wrong
            {
                NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
            }
        }
    }

}

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
//	[self.navigationController popViewControllerAnimated:YES];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
