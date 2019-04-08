#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OAuthAPI.h"

#pragma mark-
@interface OAuthBase : NSObject
- (BOOL)requestOAuthIsLogin;                                                    // 연동 정보 확인
- (void)requestOAuthGetUserData:(responseUserData)responseUserData;       // 사용자 데이터 호출
- (void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult;             // 로그인
- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult;             // 로그아웃
- (void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult;            // 인증해제
- (void)requestOAuthGetToken:(responseToken)responseToken;                      // 토큰값 호출
- (void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult;      // 토큰 업데이트
- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options; // 스키마 전달

#pragma makr- SDK Setting
- (void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; // 앱 시작
- (void)requestDidOAuth; // 앱 종료

@end
