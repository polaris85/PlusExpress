
#import "BUserGuideViewController.h"
#import "Constants.h"

@interface BUserGuideViewController ()

@end

@implementation BUserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    currentPage = 0;
    
    [[self view] setUserInteractionEnabled:TRUE];
    
    userGuideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight)];
    [userGuideScrollView setContentSize:CGSizeMake(11 * self.view.frame.size.width, self.view.frame.size.height)];
    [userGuideScrollView setPagingEnabled:TRUE];
    [userGuideScrollView setDelegate:self];
    [userGuideScrollView setBackgroundColor:[UIColor clearColor]];
    [userGuideScrollView setUserInteractionEnabled:TRUE];
    [[self view] addSubview:userGuideScrollView];
    
    float buttonWidth = 130.0f;
    float buttonHeight = 20.0f;
    float buttonY = 270.0f;
    float fontSize = 18;
    float padding = 10;
    if (IS_IPAD) {
        buttonWidth = 260.0f;
        buttonHeight = 40.0f;
        buttonY = 540.0f;
        fontSize = 30;
        padding = 20;
    }
    
    for (int i = 0; i < 11; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0.0f, self.view.frame.size.width, userGuideScrollView.frame.size.height)];
        //[imageView setContentMode:UIViewContentModeScaleToFill | UIViewContentModeTop];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ios-pg%d.png", (i + 1)]]];
        [imageView setUserInteractionEnabled:TRUE];
        [userGuideScrollView addSubview:imageView];
        
        if (i == 0) {
            UIButton *startTutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [startTutorialButton setFrame:CGRectMake((userGuideScrollView.frame.size.width - buttonWidth) / 2.0f, buttonY, buttonWidth, buttonHeight)];
            [startTutorialButton setBackgroundColor:[UIColor clearColor]];
            [startTutorialButton setTitle:@"Start Tutorial" forState:UIControlStateNormal];
            [[startTutorialButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
            [startTutorialButton addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
            [userGuideScrollView addSubview:startTutorialButton];
            
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [skipButton setFrame:CGRectMake((userGuideScrollView.frame.size.width - buttonWidth) / 2.0f, buttonY+buttonHeight+padding, buttonWidth, buttonHeight)];
            [skipButton setBackgroundColor:[UIColor clearColor]];
            [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
            [[skipButton titleLabel] setFont:[UIFont boldSystemFontOfSize:fontSize]];
            [skipButton addTarget:self action:@selector(doSkip:) forControlEvents:UIControlEventTouchUpInside];
            [userGuideScrollView addSubview:skipButton];
        } else {
            UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [prevButton setFrame:CGRectMake(i * userGuideScrollView.frame.size.width, 5.0f, 50.0f, 20.0f)];
            [prevButton setBackgroundColor:[UIColor clearColor]];
            [prevButton setTitle:@"Prev" forState:UIControlStateNormal];
            [[prevButton titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [prevButton addTarget:self action:@selector(doPrev:) forControlEvents:UIControlEventTouchUpInside];
            [userGuideScrollView addSubview:prevButton];
            
            UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextButton setFrame:CGRectMake(i * userGuideScrollView.frame.size.width + userGuideScrollView.frame.size.width - 50.0f, 5.0f, 50.0f, 20.0f)];
            [nextButton setBackgroundColor:[UIColor clearColor]];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
            [[nextButton titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [nextButton addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
            [userGuideScrollView addSubview:nextButton];
        
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [skipButton setFrame:CGRectMake(i * userGuideScrollView.frame.size.width + (userGuideScrollView.frame.size.width - 150.0f) / 2.0f, 5.0f, 150.0f, 20.0f)];
            [skipButton setBackgroundColor:[UIColor clearColor]];
            [skipButton setTitle:@"Skip Tutorial" forState:UIControlStateNormal];
            [[skipButton titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [skipButton addTarget:self action:@selector(doSkip:) forControlEvents:UIControlEventTouchUpInside];
            [userGuideScrollView addSubview:skipButton];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [userGuideScrollView setDelegate:nil];
}

- (void)doPrev:(id)sender {
    if (currentPage > 0) {
        CGRect frame = userGuideScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        frame.origin.y = 0;
        [userGuideScrollView scrollRectToVisible:frame animated:YES];
        currentPage--;
    }
}

- (void)doNext:(id)sender {
    if (currentPage < 10) {
        CGRect frame = userGuideScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage + 1);
        frame.origin.y = 0;
        [userGuideScrollView scrollRectToVisible:frame animated:YES];
        currentPage++;
    }
}

- (void)doSkip:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView {
    @try {
        CGPoint offset = userGuideScrollView.contentOffset;
        currentPage = offset.x / userGuideScrollView.bounds.size.width;
    }
    @catch (NSException *e) {

    }
}

@end
