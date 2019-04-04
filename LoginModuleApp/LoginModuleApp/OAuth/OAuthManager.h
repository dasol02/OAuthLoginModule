#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OAuthAPI.h"

@interface OAuthManager : NSObject
@property (strong, nonatomic) NSString *oAuthAccessToken;
@property (strong, nonatomic) NSString *oAuthRefreshToken;

+ (OAuthManager *)sharedInstnace;

#pragma mark - request
- (BOOL)requestOAuthManagerIsLogin;                                                                            // 로그인 상태
- (void)requestOAuthManagerGetUserData:(responseUserData)responseUserData;                               // 사용자 데이터 호출
- (void)requestOAuthManagerLogin:(OAUTH_TYPE)loginOAuthType handler:(responseOAuthResult)responseOAuthResult;  // 로그인
- (void)requestOAuthManagerLogout:(responseOAuthResult)responseOAuthResult;                             // 로그아웃
- (void)requestOAuthManagerRemove:(responseOAuthResult)responseOAuthResult;                                    // 인증해제
- (void)requestOAuthManagerRefreshToken:(responseOAuthResult)responseOAuthResult;                                          // 토큰 업데이트

- (BOOL)requestOAuthManagerNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options; // 외부 로그인 앱 연동 스키마 전달

#pragma mark - SDK Setting
- (void)requestStartOAuthManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; // 앱 시작
- (void)requestDidOAuthManager; // 앱 종료

@end

