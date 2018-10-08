#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "OAuthAPI.h"
#import "OAuthDelegate.h"

typedef NS_ENUM(int,google_Error){
    googleError_Login,
    googleError_Logout,
    googleError_UserData,
};

@import GoogleSignIn;

@interface OAuthGoogle : NSObject<GIDSignInDelegate,GIDSignInUIDelegate>{
    BOOL appFirstState; //  최초 실행 여부
}
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userIDToken;
@property (weak, nonatomic) id<OAuthDelegate> delegate;

+ (OAuthGoogle *)sharedInstnace;

- (BOOL)getLoginState; // 연동 정보 확인
- (void)oAuthGoogleUserData; // 사용자 데이터 호출
- (void)oAuthGoogleLogin; // 로그인
- (void)oAuthGoogleLogout; // 로그아웃

- (BOOL)oAuthCheckOpenURL:(NSURL *)url options:(NSDictionary *)options; // 스키마 전달


@end

