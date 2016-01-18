

#import "BPlusLinksViewController.h"
#import "BPlusLinksWebViewController.h"
#import "Constants.h"
@interface BPlusLinksViewController ()

@end

@implementation BPlusLinksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    titleLabel.text = @"PLUS Links";
    //[self creatAnnouncements];
    
    urlArray = [[NSArray alloc] initWithObjects:@"http://www.plus.com.my",
//                @"http://plustrafik.plus.com.my",
                @"http://www.plusmiles.com.my",
                @"http://www.facebook.com",
//                @"fb343050668156://com.waze.iphone.fburl",
                @"http://www.waze.com",
//                @"http://www.plusmiles.com.my/safetytips",
                @"http://www.mufors.org.my",
                @"http://www.plus.com.my/",
                nil];
    
    urlActive = [[NSArray alloc] initWithObjects:@"http://www.plus.com.my",
//                @"https://twitter.com/plustrafik",
                @"http://www.plusmiles.com.my",
                @"http://www.facebook.com/pages/PLUSMiles/121786721239564",
                //                @"fb343050668156://com.waze.iphone.fburl",
                @"http://www.waze.com",
//                @"http://www.plusmiles.com.my/Data/Sites/1/Safety-tips/SafetyTips.html",
                @"http://www.mufors.org.my",
                @"http://www.plus.com.my/index.php?option=com_content&view=article&id=254&catid=1&Itemid=291&lang=en",
                nil];
    
    urlTitle = [[NSArray alloc] initWithObjects:@"PLUS",
//                @"PLUS Traffic",
                @"PLUSMiles",
                @"PLUSMiles Facebook",
                @"Waze",
//                @"Safety Tips",
                @"Mufors",
                @"Kembara Plus",
                nil];
    
    urlIcon = [[NSArray alloc] initWithObjects:@"PLUS.png",
//                @"LiveTrafficLink.png",
                @"PLUSMiles.png",
                @"Facebook.png",
                @"Waze.png",
//                @"SafetyTips.png",
                @"Mufors.png",
                @"KembaraPlus.png",
                nil];
    
    urlIcon_iPad = [[NSArray alloc] initWithObjects:@"PLUS_ipad.png",
               //                @"LiveTrafficLink.png",
               @"PLUSMiles_ipad.png",
               @"Facebook_ipad.png",
               @"Waze_ipad.png",
               //                @"SafetyTips.png",
               @"Mufors_ipad.png",
               @"KembaraPlus_ipad.png",
               nil];
    
    [self creatUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -  UI

- (void)creatUI{
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_HEIGHT+statusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOP_HEADER_HEIGHT-statusBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}


#pragma mark -  UIButton

- (void)goToPlusLinksWeb:(UIButton *)sender{
 
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[urlArray objectAtIndex:sender.tag]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else {
        if (sender.tag == 4) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Waze application is not present. Do you wish to install now ?" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [alert show];
            
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

   // NSLog(@"%d",buttonIndex);
    if (buttonIndex == 0) {
        NSURL *url=[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [urlArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    int fontSize1 = 14;
    int fontSize2 = 12;
    int imageSize = 32;
    NSString *imageName = [urlIcon objectAtIndex:row];
    
    if (IS_IPAD) {
        fontSize1 = 28;
        fontSize2 = 24;
        imageSize = 64;
        imageName = [urlIcon_iPad objectAtIndex:row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:[urlTitle objectAtIndex:row]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:fontSize1]];
    
    [cell.detailTextLabel setText:[urlArray objectAtIndex:row]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:fontSize2]];
    [cell.detailTextLabel setTextColor:[UIColor blueColor]];
    
    
    [[cell imageView] setImage:[UIImage imageNamed:imageName]];
    [[cell imageView] setFrame:CGRectMake(0, 0, imageSize, imageSize)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = [indexPath row];
    
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[urlActive objectAtIndex:row]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (row == 3) {
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:@"waze://"]]) {
            
            // Waze is installed. Launch Waze and start navigation
            NSString *urlStr = [NSString stringWithFormat:@"waze://"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Waze application is not present. Do you wish to install now ?" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [alert show];
            
        }
        
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return 130;
    }
    return 65;
}


@end
