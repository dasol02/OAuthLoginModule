#import <Foundation/Foundation.h>
#import "OAuthAPI.h"
#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import "OAuthDelegate.h"

@interface OAuthNaver : NSObject<NaverThirdPartyLoginConnectionDelegate>
@property (strong, nonatomic) NaverThirdPartyLoginConnection *thirdPartyLoginConn;
@property (weak, nonatomic) id<OAuthDelegate> delegate;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
    
+ (OAuthNaver *)sharedInstnace;

- (BOOL)getLoginState;                  // 연동 정보 확인
- (void)oAuthNaverUserData;             // 사용자 데이터 호출
- (void)oAuthNaverLogin;                // 로그인
- (void)oAuthNaverLogout;               // 로그아웃
- (void)oAuthNaverDelete;               // 인증해제
- (void)oAuthNaverRefreshToken;         // 토큰 업데이트

- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options; // 스키마 전달

@end

