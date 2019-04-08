#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OAuthAPI.h"

@interface OAuthManager : NSObject
+ (OAuthManager *)sharedInstnace;

#pragma mark - SDK Info Setting
@property (strong, nonatomic) NSString * oAuthInfo_Naver_ServiceAppUrlScheme;
@property (strong, nonatomic) NSString * oAuthInfo_Naver_ConsumerKey;
@property (strong, nonatomic) NSString * oAuthInfo_Naver_ConsumerSecret ;
@property (strong, nonatomic) NSString * oAuthInfo_Naver_ServiceAppName;
@property (strong, nonatomic) NSString * oAuthInfo_Google_ClientID;

#pragma mark - request
- (void)requestOAuthManagerInfoSettingScheme: (NSString *)naverService NaverConsumerKey: (NSString *)naverConsumerKey NaverConsumerSecret: (NSString *)naverConsumerSecret  NaverServiceAppName: (NSString *)naverServiceAppName  GoogleClientID: (NSString *)googleClientID;

- (BOOL)requestOAuthManagerIsLogin;                                                                              // 로그인 상태
- (void)requestOAuthManagerGetUserData:(responseUserData)responseUserData;                                       // 사용자 데이터 호출
- (void)requestOAuthManagerLogin:(OAUTH_TYPE)loginOAuthType handler:(responseOAuthResult)responseOAuthResult;    // 로그인
- (void)requestOAuthManagerLogout:(responseOAuthResult)responseOAuthResult;                                      // 로그아웃
- (void)requestOAuthManagerRemove:(responseOAuthResult)responseOAuthResult;                                      // 인증해제
- (void)requestOAuthManagerRefreshToken:(responseOAuthResult)responseOAuthResult;                                // 토큰 업데이트

- (BOOL)requestOAuthManagerNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options; // 외부 로그인 앱 연동 스키마 전달


#pragma mark - SDK Setting
- (void)requestStartOAuthManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; // 앱 시작
- (void)requestDidOAuthManager; // 앱 종료

@end

