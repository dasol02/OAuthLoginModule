#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import "IndicatorView.h"

#pragma mark- Naver Define

#define kAuthNaverServiceAppUrlScheme    @"loginmoduleappdeeplinkscheme"
#define kAuthNaverConsumerKey            @"DMM9F1vOnLoTdfm8Qx6w"
#define kAuthNaverConsumerSecret         @"5_uvXsmbPj"
#define kAuthNaverServiceAppName         @"loginmoduleapp"

@protocol OAuthManagerDelegate<NSObject>
@optional
- (void)getOAuthManagerUserData:(NSString *)userData;
@end
@interface OAuthManager : NSObject<NaverThirdPartyLoginConnectionDelegate>
@property (strong, nonatomic) NaverThirdPartyLoginConnection *thirdPartyLoginConn;
@property (weak, nonatomic) id<OAuthManagerDelegate> delegate;

+ (OAuthManager *)sharedInstnace;

- (BOOL)oAuthManagerLoginState;
- (void)oAuthManagerUserData;

- (void)oAuthManagerLogout;
- (void)oAuthManagerDelete;
- (void)oAuthManagerRefreshToken;
- (NSArray*)oAUthManagerGetAccessToken;


#pragma mark - OAuth First Setting
- (void)setOAuthNaverSetting;

#pragma mark - OAuth openURL Cehck
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;

#pragma mark- NAVER LOGIN
- (void) requestThirdpartyLogin;

@end
