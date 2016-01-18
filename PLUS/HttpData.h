//
//  HttpData.h
//  PhotoSharing
//
//  Created by user on 12-1-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"


@interface HttpData : NSObject<ASIHTTPRequestDelegate, CLLocationManagerDelegate>{
    
    NSMutableData *receivedData;
    
	SEL didFinished;
	SEL didFailed;
	id dele;
}

@property(nonatomic,weak)id dele;

@property(nonatomic,assign) SEL didFinished;
@property(nonatomic,assign) SEL didFailed;

@property (nonatomic,retain) NSOperationQueue *queue;

- (void)firstTimeLoad:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS;
- (void)registerDevice:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS;
- (void)retrieveAd:(int)intDeviceType strUniqueId:(NSString *)strUniqueId strOS:(NSString *)strOS;
- (void)retrieveLatestData:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId strLastKnownLoc:(NSString *)strLastKnownLoc;
- (void)retrieveTableConfig:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId;

- (void)retrieveAnnouncement:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId;
- (void)retrieveTrafficUpdate:(NSString *)dtLastUpdateDate strUniqueId:(NSString *)strUniqueId intType:(NSInteger)intType;

- (void)updatePushPreference:(NSArray *)arrHighway strModule:(NSDictionary *)strModule strToken:(NSString *)strToken
                 strUniqueId:(NSString *)strUniqueId latitude:(double)latitude longitude:(double)longitude;

- (void)retrievePromotion:(NSString *)dtLastPromoUpdate strUniqueId:(NSString *)strUniqueId latitude:(double)latitude longitude:(double)longitude;
- (void)retrieveCommunityInterestCategory:(NSString *)strUniqueId intType:(NSInteger)intType;
- (void)retrieveCommunityInterestPaging:(NSString *)strUniqueId email:(NSString *)email strCategoryId:(NSString *)categoryId dtLastUpdateDate:(NSString *)dtLastUpdateDate intPageSelect:(int)intPageSelect;
- (void)retrieveCommunityInterestReply:(NSString *)strUniqueId email:(NSString *)email idCommunity:(NSString *)idCommunity;
- (void)postCommunityInterestReply:(NSString *)strUniqueId intDeviceType:(int)intDeviceType strEmail:(NSString *)strEmail strPassword:(NSString *)strPassword idCommunity:(NSString *)idCommunity record:(NSString *)record;
- (void)postCommunityInterest:(NSString *)strUniqueId intDeviceType:(int)intDeviceType strEmail:(NSString *)strEmail strPassword:(NSString *)strPassword record:(NSMutableDictionary *)record;
- (void)retrieveCCTV;
- (void)postSOS:(NSString *)sms intDeviceType:(int)intDeviceType deviceId:(NSString *)deviceId mobileNo:(NSString *)mobileNo to:(NSString *)to latitude: (float)latitude longitude:(float)longitude;

- (void)retrieveMobileUpdate:(NSInteger) intDeviceType;
- (void)getUpdateContent:(NSInteger) idmobileupd;
- (void)getFacilityCCTV:(NSInteger) intFacilityType idFacility: (NSString *)idFacility intDeviceType:(NSInteger) intDeviceType strDeviceId:(NSString *) strDeviceId;
// Token
- (void)getUserToken:(NSString *)strEmail strUniqueId:(NSString *)strUniqueId;
- (void)linkDevice:(NSString *)strEmail strToken:(NSString *)strToken strUniqueId:(NSString *)strUniqueId;

- (void)sendRequestByGet:(NSDictionary*)dict;
@end
