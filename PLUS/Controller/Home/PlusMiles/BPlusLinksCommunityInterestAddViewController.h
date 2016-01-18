//
//  BPlusLinksCommunityInterestAddViewController.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BaseViewController.h"
#import "CheckNetwork.h"
#import "HttpData.h"
@interface BPlusLinksCommunityInterestAddViewController : BaseViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    UIScrollView *mainScrollView;
    UITextField *titleTextField;
    UITextField *descriptionTextField;
    UIButton *photoButton;
    UITextField *locationTextField;
}

@property (nonatomic, retain) NSString *idInterestCatg;

@end

