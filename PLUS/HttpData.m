

#import "HttpData.h"

//static NSString *baseUrl = @"http://pushserver.quangbagoogle.org/service";
//static NSString *baseUrl = @"http://plus-v3.aviven.net/service/v3";
static NSString *baseUrl = @"http://plus-v3.aviven.net/push/service/v3/";
//static NSString *baseUrl = @"http://plus.aviven.net/push/service2";

static NSString *API_ID = @"c32d2e25";
static NSString *API_KEY = @"f8a3f542424e727b48c1fbae96625ca6";

static NSString *CCTV_ACCESS_CODE = @"01mwCLypOumyny0x";

@implementation HttpData
@synthesize dele;

@synthesize didFinished;
@synthesize didFailed;
@synthesize queue;


- (void)dealloc{

    [receivedData release];
    [super dealloc];
}


- (void)firstTimeLoad:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS{    
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:intDeviceType] forKey:@"intDeviceType"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:strOS forKey:@"strOS"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"FirstTimeLoad" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
   
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}


- (void)registerDevice:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS{    
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:intDeviceType] forKey:@"devicetype"];
    [parameters setObject:strUniqueId forKey:@"deviceid"];
    [parameters setObject:@"1.5" forKey:@"version"];
    [parameters setObject:@"1001001" forKey:@"userid"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RegisterDevice" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveAd:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS{    
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:intDeviceType] forKey:@"intDeviceType"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:strOS forKey:@"strOS"];
	[parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveAd" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}


- (void)retrieveLatestData:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId strLastKnownLoc:(NSString *)strLastKnownLoc{    
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  // [parameters setObject:@"2012-08-11 22:12:03" forKey:@"dtLastUpdateDate"];
    [parameters setObject:dtLastUpdateDate forKey:@"dtLastUpdateDate"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:@"1.2135, 1.2365" forKey:@"strLastKnownLoc"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];

    [reqDict setObject:@"RetrieveLatestData" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];

   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveTableConfig:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId {
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"intType"]; // 0 : iphone
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveTableConfig" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveAnnouncement:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId{    
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:dtLastUpdateDate forKey:@"dtAnnouncementLastUpdate"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveAnnouncement" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)updatePushPreference:(NSArray *)arrHighway strModule:(NSDictionary *)strModule strToken:(NSString *)strToken
                 strUniqueId:(NSString *)strUniqueId latitude:(double)latitude longitude:(double)longitude {
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[arrHighway JSONRepresentation] forKey:@"Highway"];
    [parameters setObject:[strModule JSONRepresentation] forKey:@"strModule"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:strToken forKey:@"strToken"];
    [parameters setObject:[NSNumber numberWithDouble:latitude] forKey:@"Latitude"];
    [parameters setObject:[NSNumber numberWithDouble:longitude] forKey:@"Longitude"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"intDeviceType"]; // 0 : iphone
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"UpdatePushPreference" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrievePromotion:(NSString *)dtLastPromoUpdate strUniqueId:(NSString *)strUniqueId latitude:(double)latitude longitude:(double)longitude {
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:dtLastPromoUpdate forKey:@"dtLastPromoUpdate"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithDouble:0] forKey:@"Latitude"];
    [parameters setObject:[NSNumber numberWithDouble:0] forKey:@"Longitude"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrievePromotion" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveCommunityInterestCategory:(NSString *)strUniqueId intType:(NSInteger)intType {
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithInteger:intType] forKey:@"intType"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveCommunityInterestCategory" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveCommunityInterestPaging:(NSString *)strUniqueId email:(NSString *)email strCategoryId:(NSString *)categoryId dtLastUpdateDate:(NSString *)dtLastUpdateDate intPageSelect:(int)intPageSelect {
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:email forKey:@"strEmail"];
    [parameters setObject:categoryId forKey:@"strCategoryId"];
    [parameters setObject:dtLastUpdateDate forKey:@"dtLastUpdateDate"];
    [parameters setObject:[NSNumber numberWithInt:intPageSelect] forKey:@"intPageSelect"];
    [parameters setObject:[NSNumber numberWithInt:10] forKey:@"intRowsPerPage"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveCommunityInterestPaging" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveCommunityInterestReply:(NSString *)strUniqueId email:(NSString *)email idCommunity:(NSString *)idCommunity {
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:email forKey:@"strEmail"];
    [parameters setObject:idCommunity forKey:@"idCommunity"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveCommunityInterestReply" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)postCommunityInterestReply:(NSString *)strUniqueId intDeviceType:(int)intDeviceType strEmail:(NSString *)strEmail strPassword:(NSString *)strPassword idCommunity:(NSString *)idCommunity record:(NSString *)record {
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithInt:intDeviceType] forKey:@"intDeviceType"];
    [parameters setObject:strEmail forKey:@"strEmail"];
    [parameters setObject:strPassword forKey:@"strPassword"];
    [parameters setObject:idCommunity forKey:@"idCommunity"];
    [parameters setObject:record forKey:@"Record"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"PostCommunityInterestReply" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)postCommunityInterest:(NSString *)strUniqueId intDeviceType:(int)intDeviceType strEmail:(NSString *)strEmail strPassword:(NSString *)strPassword record:(NSMutableDictionary *)record {
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithInt:intDeviceType] forKey:@"intDeviceType"];
    [parameters setObject:strEmail forKey:@"strEmail"];
    [parameters setObject:strPassword forKey:@"strPassword"];
    [parameters setObject:record forKey:@"Record"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"PostCommunityInterest" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)postSOS:(NSString *)sms intDeviceType:(int)intDeviceType deviceId:(NSString *)deviceId mobileNo:(NSString *)mobileNo to:(NSString *)to latitude: (float)latitude longitude:(float)longitude {
    
    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"c32d2e25" forKey:@"api_id"];
    [parameters setObject:@"f8a3f542424e727b48c1fbae96625ca6" forKey:@"api_key"];
    
    [parameters setObject:@"95E9CB2F-B68A-45D1-A91A-C00E336D4CCF" forKey:@"deviceid"];
    [parameters setObject:@"0" forKey:@"devicetype"];
    [parameters setObject:@"0123126252" forKey:@"mobileno"];
    [parameters setObject:@"SOS" forKey:@"to"];
    [parameters setObject:@"sms" forKey:@"smscontent"];
    [parameters setObject:@"0" forKey:@"latitude"];
    [parameters setObject:@"0" forKey:@"longtitude"];

    
    [reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"PostSOS" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    [self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveTrafficUpdate:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId intType:(NSInteger)intType {
    NSString *lastUpdateKey = [NSString stringWithFormat:@"%ld_LiveTrafficLastUpdate", (long)intType];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:lastUpdateKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2011-01-01 00:00:00" forKey:lastUpdateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:lastUpdateKey] forKey:@"dtLastUpdateDate"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:[NSNumber numberWithInteger:intType] forKey:@"intType"]; // 0 : iphone
    [parameters setObject:[NSNumber numberWithDouble:0] forKey:@"Latitude"];
    [parameters setObject:[NSNumber numberWithDouble:0] forKey:@"Longitude"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"UpdateLiveTrafficBasic" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    NSLog(@"result parameter : %@", reqDict);
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)getFacilityCCTV:(NSInteger) intFacilityType idFacility: (NSString *)idFacility intDeviceType:(NSInteger) intDeviceType strDeviceId:(NSString *) strDeviceId{
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSNumber numberWithInteger:intDeviceType] forKey:@"intDeviceType"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    [parameters setObject:[NSNumber numberWithInteger:intFacilityType] forKey:@"intFacilityType"];
    [parameters setObject:idFacility forKey:@"idFacility"];
    [parameters setObject:strDeviceId forKey:@"strDeviceId"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"GetFacilityCCTV" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    NSLog(@"result parameter : %@", reqDict);
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}


- (void)retrieveMobileUpdate:(NSInteger) intDeviceType {
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSNumber numberWithInteger:intDeviceType] forKey:@"devicetype"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"GetMobileUpdate" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    NSLog(@"result parameter : %@", reqDict);
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)getUpdateContent:(NSInteger) idmobileupd{
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSNumber numberWithInteger:idmobileupd] forKey:@"idmobileupd"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"GetUpdateContent" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    NSLog(@"result parameter : %@", reqDict);
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)retrieveCCTV{
    
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:CCTV_ACCESS_CODE forKey:@"strAccessCode"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"RetrieveCCTV" forKey:@"method"];
    [reqDict setObject:@"3" forKey:@"id"];
    
    NSLog(@"result parameter : %@", reqDict);
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)getUserToken:(NSString *)strEmail strUniqueId:(NSString *)strUniqueId {
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strEmail forKey:@"PLUSMilesEmail"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"GetUserToken" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

- (void)linkDevice:(NSString *)strEmail strToken:(NSString *)strToken strUniqueId:(NSString *)strUniqueId {
    NSMutableDictionary* reqDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:strEmail forKey:@"PLUSMilesEmail"];
    [parameters setObject:strToken forKey:@"Token"];
    [parameters setObject:strUniqueId forKey:@"strUniqueId"];
    [parameters setObject:API_ID forKey:@"api_id"];
    [parameters setObject:API_KEY forKey:@"api_key"];
    
	[reqDict setObject:parameters forKey:@"params"];
    [parameters release];
    
    [reqDict setObject:@"LinkDevicePLUSMiles" forKey:@"method"];
	[reqDict setObject:@"3" forKey:@"id"];
    
    
   	[self sendRequestByGet:reqDict];
    [reqDict release];
}

#pragma mark - 
- (void)sendRequestByGet:(NSDictionary*)dict{
        
    
    NSString *str_post = [dict JSONRepresentation];
    
    NSLog(@"str_post==%@",str_post);
    //body
    NSData *myRequestData = [str_post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *urlPost=[NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
   // NSLog(@"urlPost:%@",urlPost);

    /*
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:urlPost];
    [request appendPostData:myRequestData];
    [request setDelegate:self];
    [request startAsynchronous];
    [request release];
     */

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlPost];	//prepare http body
	[request setHTTPMethod: @"POST"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: myRequestData];

    receivedData=[[NSMutableData alloc] initWithData:nil];
    
    
	 NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
    [urlConnection release];
}


- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response {
  
}


- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data {

    [receivedData appendData:data];

}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error{

    if (dele && [dele respondsToSelector:didFailed]) {
        [dele performSelector:didFailed];		
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)aConn {
    
    NSString *results = [[[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding] autorelease];

    NSLog(@"results=%@",results);

    if (dele && [dele respondsToSelector:didFinished]) {
        [dele performSelector:didFinished withObject:results];
    }  
}

/*
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    // NSLog(@"requestFinished");
    NSString *apiResponse = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    
    if (dele && [dele respondsToSelector:didFinished]) {
        [dele performSelector:didFinished withObject:apiResponse];
    }  
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
    //NSError *error = [request error];  
     //NSLog(@"requestFailed=%@",error);

    if (dele && [dele respondsToSelector:didFailed]) {
        [dele performSelector:didFailed];		
    }
}
 */
@end
