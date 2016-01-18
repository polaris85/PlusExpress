//
//  BPlusLinksCommunityInterestViewController.m
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "BPlusLinksCommunityInterestViewController.h"
#import "Constants.h"
@interface BPlusLinksCommunityInterestViewController ()

@end

@implementation BPlusLinksCommunityInterestViewController

@synthesize communityInterestDictionary = _communityInterestDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleLabel.text = @"Community Interest";
    
    replyArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    
    [self retrieveCommunityInterestReply];
    
    [self setContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

- (void)dealloc {
    replyArray = nil;
}

- (void)createUI {
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - TOP_HEADER_HEIGHT-statusBarHeight - 26.0f)];
    [[self view] addSubview:mainScrollView];
    
    CITitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.view.frame.size.width - 10.0f, 18.0f)];
    [CITitleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [CITitleLabel setNumberOfLines:0];
    [mainScrollView addSubview:CITitleLabel];
    
    CIImageView = [[UIButton alloc] initWithFrame:CGRectMake(CITitleLabel.frame.origin.x, CITitleLabel.frame.origin.y + CITitleLabel.frame.size.height + 5.0f, CITitleLabel.frame.size.width, 150.0f)];
    [CIImageView addTarget:self action:@selector(doZoomImage) forControlEvents:UIControlEventTouchDown];
    [mainScrollView addSubview:CIImageView];
    
    CIDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [CIDescriptionLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [CIDescriptionLabel setNumberOfLines:0];
    [mainScrollView addSubview:CIDescriptionLabel];
    
    CIPostedByLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [CIPostedByLabel setFont:[UIFont italicSystemFontOfSize:11.0f]];
    [CIPostedByLabel setNumberOfLines:0];
    [mainScrollView addSubview:CIPostedByLabel];
    
    CIReplyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [CIReplyTableView setDelegate:self];
    [CIReplyTableView setDataSource:self];
    [CIReplyTableView setScrollEnabled:NO];
    [mainScrollView addSubview:CIReplyTableView];
    
    replyBoxView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 26.0f, self.view.frame.size.width, 26.0f)];
    replyBoxTextField = [[UITextField alloc] initWithFrame:CGRectMake(2.0f, 2.0f, self.view.frame.size.width - 50.0f, 22.0f)];
    [replyBoxTextField setFont:[UIFont systemFontOfSize:11.0f]];
    replyBoxTextField.layer.borderWidth = 0.5f;
    [replyBoxTextField setDelegate:self];
    [replyBoxView addSubview:replyBoxTextField];
    
    replyButton = [[UIButton alloc] init];
    [replyButton setFrame:CGRectMake(replyBoxTextField.frame.origin.x + replyBoxTextField.frame.size.width + 5.0f, replyBoxTextField.frame.origin.y, self.view.frame.size.width - (replyBoxTextField.frame.origin.x + replyBoxTextField.frame.size.width + 5.0f) - 2.0f, 22.0f)];
    [replyButton setTitle:@"Reply" forState:UIControlStateNormal];
    [replyButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:110.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[replyButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.50f]];
    [replyButton setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [replyButton addTarget:self action:@selector(doReply) forControlEvents:UIControlEventTouchDown];
    [replyBoxView addSubview:replyButton];
    
    [[self view] addSubview:replyBoxView];
}

- (void)resize {
    [CIDescriptionLabel setFrame:CGRectMake(CIImageView.frame.origin.x, CIImageView.frame.origin.y + CIImageView.frame.size.height + 5.0f, CIDescriptionLabel.frame.size.width, CIDescriptionLabel.frame.size.height)];
    
    [CIPostedByLabel setFrame:CGRectMake(CIDescriptionLabel.frame.origin.x, CIDescriptionLabel.frame.origin.y + CIDescriptionLabel.frame.size.height, CIDescriptionLabel.frame.size.width, CIPostedByLabel.frame.size.height)];
    
    [CIRepliesLabel setFrame:CGRectMake(CIPostedByLabel.frame.origin.x, CIPostedByLabel.frame.origin.y + CIPostedByLabel.frame.size.height + 5.0f, CIRepliesLabel.frame.size.width, CIRepliesLabel.frame.size.height)];
    
    [CIReplyTableView setFrame:CGRectMake(0.0f, CIRepliesLabel.frame.origin.y + CIRepliesLabel.frame.size.height + 5.0f, CIReplyTableView.frame.size.width, CIReplyTableView.frame.size.height)];
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, CIReplyTableView.frame.origin.y + CIReplyTableView.frame.size.height)];
}

- (void)setContent {
    double titleHeight = [self heightOfString:[_communityInterestDictionary objectForKey:@"strTitle"] withLabel:CITitleLabel];
    [CITitleLabel setFrame:CGRectMake(CITitleLabel.frame.origin.x, CITitleLabel.frame.origin.y, CITitleLabel.frame.size.width, titleHeight)];
    [CITitleLabel setText:[_communityInterestDictionary objectForKey:@"strTitle"]];
    
    if ([_communityInterestDictionary objectForKey:@"strPicture"]) {
        [CIImageView setImageWithURL:[NSURL URLWithString:[_communityInterestDictionary objectForKey:@"strPicture"]] success:^(UIImage *image, BOOL cached) {
            double ratio = CIImageView.frame.size.width / image.size.width;
            [CIImageView setFrame:CGRectMake(CIImageView.frame.origin.x, CIImageView.frame.origin.y, CIImageView.frame.size.width, ratio * image.size.height)];
            
            [self performSelector:@selector(resize)];
        } failure:nil];
    }
    
    [CIDescriptionLabel setFrame:CGRectMake(CIImageView.frame.origin.x, CIImageView.frame.origin.y + CIImageView.frame.size.height + 5.0f, CITitleLabel.frame.size.width, 18.0f)];
    double descriptionHeight = [self heightOfString:[_communityInterestDictionary objectForKey:@"strDescription"] withLabel:CIDescriptionLabel];
    [CIDescriptionLabel setFrame:CGRectMake(CIDescriptionLabel.frame.origin.x, CIDescriptionLabel.frame.origin.y, CIDescriptionLabel.frame.size.width, descriptionHeight)];
    [CIDescriptionLabel setText:[_communityInterestDictionary objectForKey:@"strDescription"]];
    
    NSString *timeString = [_communityInterestDictionary objectForKey:@"dtSubmitdate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:timeString];
    
    [CIPostedByLabel setFrame:CGRectMake(CIDescriptionLabel.frame.origin.x, CIDescriptionLabel.frame.origin.y + CIDescriptionLabel.frame.size.height, CIDescriptionLabel.frame.size.width, 18.0f)];
    NSString *postedByString = [NSString stringWithFormat:@"Posted by %@, %@", [_communityInterestDictionary objectForKey:@"strCustomerName"], [dateFromString timeAgo]];
    double postedByHeight = [self heightOfString:postedByString withLabel:CIPostedByLabel];
    [CIPostedByLabel setFrame:CGRectMake(CIPostedByLabel.frame.origin.x, CIPostedByLabel.frame.origin.y, CIPostedByLabel.frame.size.width, postedByHeight)];
    [CIPostedByLabel setText:postedByString];
    
    CIRepliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CIPostedByLabel.frame.origin.x, CIPostedByLabel.frame.origin.y + CIPostedByLabel.frame.size.height + 5.0f, CIPostedByLabel.frame.size.width, 18.0f)];
    [CIRepliesLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [CIRepliesLabel setText:@"Replies"];
    [mainScrollView addSubview:CIRepliesLabel];
    
    [CIReplyTableView setFrame:CGRectMake(0.0f, CIRepliesLabel.frame.origin.y + CIRepliesLabel.frame.size.height + 5.0f, mainScrollView.frame.size.width, mainScrollView.frame.size.height - (CIRepliesLabel.frame.origin.y + CIRepliesLabel.frame.size.height + 5.0f))];
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, CIReplyTableView.frame.origin.y + CIReplyTableView.frame.size.height)];
}

- (void)doReply {
    @autoreleasepool {
        if ([CheckNetwork connectedToNetwork]) {
            NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
            int intDeviceId = 0;
            NSString *strEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.LoginId"];
            NSString *strPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.Password"];
            NSString *idCommunity = [_communityInterestDictionary objectForKey:@"idCommunity"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[_communityInterestDictionary objectForKey:@"strTitle"] forKey:@"strTitle"];
            [dict setObject:[replyBoxTextField text] forKey:@"strDescription"];
            NSString *record = [dict JSONRepresentation];
            
            HttpData *httpData = [[HttpData alloc] init];
            httpData.dele = self;
            httpData.didFinished = @selector(didPostCommunityInterestReplyDataFinished:);
            httpData.didFailed = @selector(didReceiveDataSelector);
            
            [self creatHUD];
            [httpData postCommunityInterestReply:strUniqueId intDeviceType:intDeviceId strEmail:strEmail strPassword:strPassword idCommunity:idCommunity record:record];
        }
    }
}

- (void)doZoomImage {
    
}

- (void)retrieveCommunityInterestReply {
    @autoreleasepool {
        if ([CheckNetwork connectedToNetwork]) {
            NSString *strUniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
            NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"Plus.LoginId"];
            
            HttpData *httpData = [[HttpData alloc] init];
            httpData.dele = self;
            httpData.didFinished = @selector(didRetrieveCommunityInterestReplyDataFinished:);
            httpData.didFailed = @selector(didRetrieveDataError);
            
            [self creatHUD];
            [httpData retrieveCommunityInterestReply:strUniqueId email:email idCommunity:[_communityInterestDictionary objectForKey:@"idCommunity"]];
        }
    }
}

- (void)didPostCommunityInterestReplyDataFinished:(id)data {
    [self hideHud];
    
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] isEqualToString:@"00"]) {
        [replyBoxTextField setText:@""];
        [replyBoxTextField resignFirstResponder];
        [self retrieveCommunityInterestReply];
    }
}

- (void)didRetrieveCommunityInterestReplyDataFinished:(id)data {
    [self hideHud];
    if ([[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Status"] intValue] == 1) {
        NSArray *contentArr = [[[[data JSONValue] objectForKey:@"result"] objectForKey:@"Messages"] objectForKey:@"tblcommunityreply"];
        
        [replyArray removeAllObjects];
        [replyArray addObjectsFromArray:contentArr];
        
        NSString *CellIdentifier = @"CommunityInterestCell";
        double totalHeight = 0;
        for (int i = 0; i < [contentArr count]; i++) {
            BCommunityInterestCell *cell = [CIReplyTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[BCommunityInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setCommunityInterestInfo:[replyArray objectAtIndex:i]];
            totalHeight += cell.totalHeight;
        }
        
        [CIReplyTableView setFrame:CGRectMake(CIReplyTableView.frame.origin.x, CIReplyTableView.frame.origin.y, CIReplyTableView.frame.size.width, totalHeight)];
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, CIReplyTableView.frame.origin.y + CIReplyTableView.frame.size.height)];
        [CIReplyTableView reloadData];
    }
}

- (void)didRetrieveDataError {
    [self hideHud];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [replyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommunityInterestCell";
    
    BCommunityInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BCommunityInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCommunityInterestInfo:[replyArray objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommunityInterestCell";
    
    BCommunityInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BCommunityInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCommunityInterestInfo:[replyArray objectAtIndex:[indexPath row]]];
    
    return cell.totalHeight;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark NsNotificationCenter
- (void)keyboardWasShown:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [mainScrollView setFrame:CGRectMake(mainScrollView.frame.origin.x, mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height - 216.0f)];
    [replyBoxView setFrame:CGRectMake(replyBoxView.frame.origin.x, replyBoxView.frame.origin.y - 216.0f , replyBoxView.frame.size.width, replyBoxView.frame.size.height)];
    [UIView commitAnimations];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [mainScrollView setFrame:CGRectMake(mainScrollView.frame.origin.x, mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height + 216.0f)];
    [replyBoxView setFrame:CGRectMake(replyBoxView.frame.origin.x, replyBoxView.frame.origin.y + 216.0f , replyBoxView.frame.size.width, replyBoxView.frame.size.height)];
    [UIView commitAnimations];
}

@end
