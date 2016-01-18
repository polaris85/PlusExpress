
#import "BFunctionViewController.h"

#import "BSettingViewController.h"
#import "BAgreementViewController.h"
#import "MapViewController.h"
#import "WebViewController.h"
#import "Constants.h"
@interface BFunctionViewController ()

@end

@implementation BFunctionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)createUI {
    
    titleLabel.text = @"About Us";
    
    float titleImageWidth = 341/2.5;
    float titleImageHeight = 241/2.5;
    float logoImageWidth = 233/2.5;
    float logoImageHeight = 153/2.5;
    float brandImageWidth = 655/5.0;
    float brandImageHeight = 124/5.0;
    float functionButtonSize = 75/2;
    
    float padding = 10;
    float labelHeight = 20;
    float fontSize = 16;
    if (IS_IPAD) {
        padding = 20;
        titleImageWidth = 341/2.5 *2;
        titleImageHeight = 241/2.5 *2;
        logoImageWidth = 233/2.5*2;
        logoImageHeight = 153/2.5*2;
        brandImageWidth = 655/5.0*2;
        brandImageHeight = 124/5.0*2;
        functionButtonSize = 75;
        
        labelHeight = 40;
        fontSize = 30;
    }
    
    UIImageView *titleImg = [[UIImageView alloc] init];
    titleImg.backgroundColor = [UIColor clearColor];
    titleImg.image = [UIImage imageNamed:@"Expressways Malaysia"];

    titleImg.frame = CGRectMake(self.view.center.x - titleImageWidth/2,
                                TOP_HEADER_HEIGHT + statusBarHeight + padding,
                                titleImageWidth,
                                titleImageHeight);
    [self.view addSubview:titleImg];
    
    UILabel *lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(titleImg.frame.origin.x,
                                                                 titleImg.frame.origin.y + titleImg.frame.size.height+padding,
                                                                 titleImg.frame.size.width,
                                                                 labelHeight)];
    lblVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    lblVersion.textColor = [UIColor blackColor];
    lblVersion.font = [UIFont systemFontOfSize:fontSize];
    lblVersion.textAlignment = NSTextAlignmentCenter;
    lblVersion.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lblVersion];
    UILabel *lblDeve = [[UILabel alloc] initWithFrame:CGRectMake(titleImg.frame.origin.x,
                                                                 lblVersion.frame.origin.y + lblVersion.frame.size.height+padding,
                                                                 titleImg.frame.size.width,
                                                                 labelHeight)];
    lblDeve.text = @"Developed For:";
    lblDeve.textColor = [UIColor blackColor];
    lblDeve.font = [UIFont systemFontOfSize:fontSize];
    lblDeve.textAlignment = NSTextAlignmentCenter;
    lblDeve.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lblDeve];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - logoImageWidth/2,
                                                                         lblDeve.frame.origin.y + lblDeve.frame.size.height+padding,
                                                                         logoImageWidth,logoImageHeight)];
    logoImg.backgroundColor = [UIColor clearColor];
    logoImg.image = [UIImage imageNamed:@"PLUS Logo + Version"];
    [self.view addSubview:logoImg];
    
    UILabel *lblBy = [[UILabel alloc] initWithFrame:CGRectMake(logoImg.frame.origin.x,
                                                               logoImg.frame.origin.y + logoImg.frame.size.height + padding,
                                                               logoImg.frame.size.width,
                                                               labelHeight)];
    lblBy.text = @"By";
    lblBy.textColor = [UIColor blackColor];
    lblBy.font = [UIFont systemFontOfSize:fontSize];
    lblBy.textAlignment = 1;
    lblBy.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lblBy];
    
    UIImageView *imgBrand = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - brandImageWidth/2,
                                                                  lblBy.frame.origin.y + lblBy.frame.size.height+padding,
                                                                  brandImageWidth, brandImageHeight)];
    imgBrand.backgroundColor =[UIColor clearColor];
    imgBrand.image = [UIImage imageNamed:@"AvivenLogoSharp"];
    [self.view addSubview:imgBrand];
    
    float startX = (self.view.frame.size.width-functionButtonSize*4-padding*3)/2;
    for (int i = 0; i < 4; i ++) {
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX + (functionButtonSize+padding)*i, imgBrand.frame.origin.y + imgBrand.frame.size.height+padding, functionButtonSize, functionButtonSize)];
        
        if (i == 0) {
        //    functionBtn.frame = CGRectMake(startX, imgBrand.frame.origin.y + imgBrand.frame.size.height+padding, functionButtonSize, functionButtonSize);
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"Aviven Website Button"] forState:UIControlStateNormal];
        }else if (i == 1) {
            //functionBtn.frame = CGRectMake(startX + (functionButtonSize+padding)*i , imgBrand.frame.origin.y + imgBrand.frame.size.height+padding, functionButtonSize, functionButtonSize);
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"Customer Feedback Button"] forState:UIControlStateNormal];
        }else if (i == 2) {
            //functionBtn.frame = CGRectMake(startX + (functionButtonSize+padding)*i, imgBrand.frame.origin.y + imgBrand.frame.size.height+padding, functionButtonSize, functionButtonSize);
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"Call Sales Button"] forState:UIControlStateNormal];
        }else if (i == 3) {
            //functionBtn.frame = CGRectMake(startX + (functionButtonSize+padding)*i, imgBrand.frame.origin.y + imgBrand.frame.size.height+padding, functionButtonSize, functionButtonSize);
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"Map to Aviven Button"] forState:UIControlStateNormal];
        }
        
        functionBtn.tag = 1000 + i;
        [functionBtn addTarget:self action:@selector(doFunction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:functionBtn];
    }
    
}

- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doFunction:(UIButton *)btn {
    switch (btn.tag) {
        case 1000: {
            
            //WebViewController *websiteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
            //[self.navigationController pushViewController:websiteVC animated:YES];

            //NSString *strUrl5 = [NSURL URLWithString:@"http://www.aviven.net/"];
            //NSUrl *url = [NSURL URLWithString:strUrl5];
            //NSString *strUrl5 = [NSURL URLWithString:@"www.aviven.net"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aviven.net"]];
        }
            break;
        case 1001: {
            
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
            if(mailCompose)
            {
                
                [mailCompose setMailComposeDelegate:self];
                
                NSArray *toAddress = [NSArray arrayWithObject:@"plusmobileapp.techsupport@aviven.net"];
//                NSArray *ccAddress = [NSArray arrayWithObject:@"17333245@qq.com"];

                
            
                [mailCompose setToRecipients:toAddress];
                
//                [mailCompose setCcRecipients:ccAddress];
                
//                [mailCompose setMessageBody:emailBody isHTML:YES];
                
                
                [mailCompose setSubject:@"Feedback : PLUS Mobile App"];
                [self presentViewController:mailCompose animated:YES completion:nil];
            }
        }
            break;
        case 1002: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"PLUS Mobile Application\nDeveloped by Aviven Sdn Bhd\nPhone +6012 312 6252"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Call",@"Cancel", nil];
            [alertView show];
        }
            break;
        case 1003: {
            MapViewController *mapVC = [[MapViewController alloc] init];
            [self.navigationController pushViewController:mapVC animated:YES];
        }
            break;
        case 1004: {
            BAgreementViewController *tncVC = [self.storyboard instantiateViewControllerWithIdentifier:@"agreementViewController"];
            [tncVC setSettingMode:YES];
            [self.navigationController pushViewController:tncVC animated:YES];
        }
            break;
        case 1005: {
            BSettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *phoneNum = @"60123126252";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertWithTitle:(NSString *)title  msg:(NSString *)msg
{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:nil];
        [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
