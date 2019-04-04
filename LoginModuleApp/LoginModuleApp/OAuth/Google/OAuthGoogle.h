#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "OAuthBase.h"

typedef NS_ENUM(int,google_Error){
    googleError_Login,
    googleError_Logout,
    googleError_UserData,
};

@import GoogleSignIn;

@interface OAuthGoogle : OAuthBase<GIDSignInDelegate,GIDSignInUIDelegate>{
    BOOL appFirstState;                                     //  최초 실행 여부
}
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userIDToken;

- (void)signInSilently;                                     // 로그인 정보 확인 (앱 최초 실행시)
    
@end

