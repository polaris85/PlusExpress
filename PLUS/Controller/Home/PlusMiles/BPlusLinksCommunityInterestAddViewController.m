//
//  BPlusLinksCommunityInterestAddViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksCommunityInterestAddViewController.h"
#import "NSData+Base64.h"
#import "Constants.h"
@interface BPlusLinksCommunityInterestAddViewController ()

@end

@implementation BPlusLinksCommunityInterestAddViewController

@synthesize idInterestCatg = _idInterestCatg;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleLabel.text = @"Post Community Interest";
    
    [self createUI];
}

- (void)createUI {
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT-statusBarHeight)];
    [[self view] addSubview:mainScrollView];
    
    UILabel *titleStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 10.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [titleStringLabel setText:@"Title"];
    [titleStringLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [titleStringLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:titleStringLabel];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleStringLabel.frame.origin.x  , titleStringLabel.frame.origin.y + titleStringLabel.frame.size.height + 5.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [titleTextField setDelegate:self];
    [titleTextField setFont:[UIFont systemFontOfSize:14.0f]];
    [titleTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:titleTextField];
    
    photoButton = [[UIButton alloc] init];
    [photoButton setFrame:CGRectMake(titleTextField.frame.origin.x, titleTextField.frame.origin.y + titleTextField.frame.size.height + 10.0f, titleTextField.frame.size.width, 150.0f)];
    [photoButton setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [photoButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [[photoButton titleLabel] setFont:[UIFont systemFontOfSize:13.0f]];
    [photoButton setTitle:@"Choose Photo" forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(doTakePhoto) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:photoButton];
    
    UILabel *descriptionStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, photoButton.frame.origin.y + photoButton.frame.size.height + 10.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [descriptionStringLabel setText:@"Description"];
    [descriptionStringLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [descriptionStringLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:descriptionStringLabel];
    
    descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(descriptionStringLabel.frame.origin.x  , descriptionStringLabel.frame.origin.y + descriptionStringLabel.frame.size.height + 5.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [descriptionTextField setDelegate:self];
    [descriptionTextField setFont:[UIFont systemFontOfSize:14.0f]];
    [descriptionTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:descriptionTextField];
    
    UILabel *locationStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, descriptionTextField.frame.origin.y + descriptionTextField.frame.size.height + 10.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [locationStringLabel setText:@"Location"];
    [locationStringLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [locationStringLabel setTextColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:locationStringLabel];
    
    locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(locationStringLabel.frame.origin.x  , locationStringLabel.frame.origin.y + locationStringLabel.frame.size.height + 5.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [locationTextField setDelegate:self];
    [locationTextField setFont:[UIFont systemFontOfSize:14.0f]];
    [locationTextField setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [mainScrollView addSubview:locationTextField];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setFrame:CGRectMake(mainScrollView.frame.size.width - 130.0f - 10.0f, locationTextField.frame.origin.y + locationTextField.frame.size.height + 10.0f, 130.0f, 20.0f)];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [[submitButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.50f]];
    [submitButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [submitButton addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:submitButton];
}

- (void)doTakePhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionSheet showFromTabBar:[self tabBarController].tabBar];
}

- (void)doSubmit {
    if ([CheckNetwork connectedToNetwork]) {
        NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        int intDeviceType = 0;
        NSString *strEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.LoginId"];
        NSString *strPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.Password"];
        NSData *imageData = UIImagePNGRepresentation([photoButton backgroundImageForState:UIControlStateNormal]);
        
        NSMutableDictionary *Record = [[NSMutableDictionary alloc] init];
        [Record setObject:_idInterestCatg forKey:@"idInterestCatg"];
        [Record setObject:[titleTextField text] forKey:@"strTitle"];
        [Record setObject:[descriptionTextField text] forKey:@"strDescription"];
        //[Record setObject:[imageData base64Encoding] forKey:@"strPicture"];
        [Record setObject:imageData forKey:@"strPicture"];
        [Record setObject:[NSNumber numberWithInt:0] forKey:@"floLatitude"];
        [Record setObject:[NSNumber numberWithInt:0] forKey:@"floLongitude"];
        
        HttpData *httpData = [[HttpData alloc] init];
        httpData.dele = self;
        httpData.didFinished = @selector(didPostCommunityInterestDataFinished:);
        httpData.didFailed = @selector(didRetrieveDataError);
        
        [self creatHUD];
        [httpData postCommunityInterest:strUniqueId intDeviceType:intDeviceType strEmail:strEmail strPassword:strPassword record:Record];
    }
}

#pragma mark HttpData
- (void)didPostCommunityInterestDataFinished:(id)data {
    [self hideHud];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] isEqualToString:@"00"]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)didRetrieveDataError {
    [self hideHud];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [photoButton setBackgroundImage:image forState:UIControlStateNormal];
    [photoButton setTitle:@"" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
