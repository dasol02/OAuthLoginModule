#import <Foundation/Foundation.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "OAuthAPI.h"
#import "OAuthDelegate.h"

@interface OAuthKakao : NSObject
    
@property (weak, nonatomic) id<OAuthDelegate> delegate;

+ (OAuthKakao *)sharedInstnace;
    
- (BOOL)getLoginState; // 연동 정보 확인
- (void)oAuthKakaoUserData; // 사용자 데이터 호출
- (void)oAuthKakaoLogin; // 로그인
- (void)oAuthKakaoLogout; // 로그아웃
- (void)oAuthKakaoDelete; // 인증해제
- (void)oAuthKakaoGetToken; // 토큰값 호출
- (void)oAuthKakaoRefreshToken; // 토큰 업데이트

    
#pragma mark- OPEN URL
- (BOOL)isKakaoAccountLoginCallback:(NSURL *)url;
- (BOOL)handleOpenURL:(NSURL *)url;
@end

