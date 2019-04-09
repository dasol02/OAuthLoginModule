#import "OAuthManager.h"
#import "OAuthBase.h"

#import "OAuthNaver.h"
#import "OAuthKakao.h"
#import "OAuthFacebook.h"
#import "OAuthGoogle.h"


@interface OAuthManager()
@property (strong, nonatomic) OAuthBase *oAuthObject;
@end

@implementation OAuthManager
+ (OAuthManager *)sharedInstnace{
    static OAuthManager *oAuthManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthManager = [[OAuthManager alloc] init];
    });
    
    return oAuthManager;
}

#pragma mark - SDK Info Setting
- (void)requestOAuthManagerInfoSettingScheme: (NSString *)naverService NaverConsumerKey: (NSString *)naverConsumerKey NaverConsumerSecret: (NSString *)naverConsumerSecret  NaverServiceAppName: (NSString *)naverServiceAppName  GoogleClientID: (NSString *)googleClientID{
    self.oAuthInfo_Naver_ServiceAppUrlScheme = naverService;
    self.oAuthInfo_Naver_ConsumerKey = naverConsumerKey;
    self.oAuthInfo_Naver_ConsumerSecret = naverConsumerSecret;
    self.oAuthInfo_Naver_ServiceAppName = naverServiceAppName;
    self.oAuthInfo_Google_ClientID = googleClientID;
}


#pragma mark - REQUEST
// 로그인
- (void)requestOAuthManagerLogin:(OAUTH_TYPE)loginOAuthType handler:(responseOAuthResult)responseOAuthResult{
    [self initSocialLogin:(OAUTH_TYPE)loginOAuthType];
    if ([self isOAuthObject] == NO) { responseOAuthResult(NO); return; }
    [self.oAuthObject requestOAuthLogin:responseOAuthResult];
}

// 로그아웃
- (void)requestOAuthManagerLogout:(responseOAuthResult)responseOAuthResult{
    if ([self isOAuthObject] == NO) { return; }
    [self.oAuthObject requestOAuthLogout:responseOAuthResult];
}

// 인증 해제
- (void)requestOAuthManagerRemove:(responseOAuthResult)responseOAuthResult{
    if ([self isOAuthObject] == NO) { responseOAuthResult(NO); return; }
    [self.oAuthObject requestOAuthRemove:responseOAuthResult];
}

// 토큰 갱신
- (void)requestOAuthManagerRefreshToken:(responseOAuthResult)responseOAuthResult{
    if ([self isOAuthObject] == NO) { return; }
    [self.oAuthObject requsetOAuthRefreshToken:responseOAuthResult];
}

// 사용자 데이터 조회
- (void)requestOAuthManagerGetUserData:(responseUserData)responseUserData{
    if ([self isOAuthObject] == NO) { return; }
    [self.oAuthObject requestOAuthGetUserData:responseUserData];
}

// 로그인 여부 확인
- (BOOL)requestOAuthManagerIsLogin{
    if ([self isOAuthObject] == NO) { return NO; }
    return [self.oAuthObject requestOAuthIsLogin];
}

// 네이티브 앱 로그인 연동
- (BOOL)requestOAuthManagerNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    if ([self isOAuthObject] == NO) { return NO; }
    return [self.oAuthObject requestOAuthNativeOpenURL:app openURL:url options:options];
}



#pragma makr- SDK Setting
// 앱 시작
-(void)requestStartOAuthManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if ([self isOAuthObject] == NO) { return; }
    [self.oAuthObject requestStartOAuth:application didFinishLaunchingWithOptions:launchOptions];
}

// 앱 종료
-(void)requestDidOAuthManager{
    if ([self isOAuthObject] == NO) { return; }
    [self.oAuthObject requestDidOAuth];
}


#pragma mark - privite

-(BOOL)isOAuthObject{
    if(self.oAuthObject == nil){
        return NO;
    }else{
        return YES;
    }
}

/**
 * SNS Social 로그인 클래스 생성
 */
- (void)initSocialLogin:(int)loginSocialType{
    
    self.oAuthObject = nil;
    
    switch (loginSocialType) {
        case OAUTH_TYPE_NAVER:
            self.oAuthObject = [[OAuthNaver alloc] init];
            break;
        case OAUTH_TYPE_KAKAO:
            self.oAuthObject = [[OAuthKakao alloc] init];
            break;
        case OAUTH_TYPE_FACEBOOK:
            self.oAuthObject = [[OAuthFacebook alloc] init];
            break;
        case OAUTH_TYPE_GOOGLE:
            self.oAuthObject = [[OAuthGoogle alloc] init];
            break;
        default:
            break;
    }
    
}

@end
