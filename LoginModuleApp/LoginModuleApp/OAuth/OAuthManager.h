#import <Foundation/Foundation.h>
#import "OAuthAPI.h"
#import "IndicatorView.h"
#import "OAuthDelegate.h"
#import "OAuthNaver.h"

@protocol OAuthManagerDelegate<NSObject>
@optional
- (void)getOAuthManagerUserData:(NSString *)userData;
- (void)responseLoginResult:(BOOL)state;
@end

@interface OAuthManager : NSObject<OAuthDelegate>{
    int oAuthLoginName;
}
@property (weak, nonatomic) id<OAuthManagerDelegate> delegate;
@property (strong, nonatomic) OAuthNaver *oAuthNaver;

+ (OAuthManager *)sharedInstnace;

- (BOOL)oAuthManagerLoginState; // 로그인 상태
- (void)oAuthManagerUserData; // 사용자 데이터 호출

- (void)oAuthManagerLogin:(int)loginOAuthName; // 로그인
- (void)oAuthManagerLogout; // 로그아웃
- (void)oAuthManagerDelete; // 인증해제
- (void)oAuthManagerRefreshToken; // 토큰 업데이트

- (int)oAuthgetLoginName;

// 외부 로그인 앱 연동 스키마 전달
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;

@end
