#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "OAuthAPI.h"
#import "OAuthDelegate.h"
typedef NS_ENUM(int,facebook_Error){
    facebookError_Login,
    facebookError_Logout,
    facebookError_UserData,
    facebookError_RefreshToken
};

@interface OAuthFacebook : NSObject
@property (strong, nonatomic) FBSDKLoginManager *fbManager;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *userID;

@property (weak, nonatomic) id<OAuthDelegate> delegate;

+ (OAuthFacebook *)sharedInstnace;

- (BOOL)getLoginState; // 연동 정보 확인
- (void)oAuthFacebookUserData; // 사용자 데이터 호출
- (void)oAuthFacebookLogin; // 로그인
- (void)oAuthFacebookLogout; // 로그아웃
- (void)oAuthFacebookRefreshToken; // 토큰 업데이트

@end
