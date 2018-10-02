#ifndef OAuthAPI_h
#define OAuthAPI_h

#pragma mark - LOG
#define kOAuth_LOG_MANAGER_DEVELOPER YES // 개발확인 로그
#define kOAuth_LOG_MANAGER NO  // 로그인 모듈 로그 노출
#define kOAuth_LOG_NAVER YES   // 네이버 로그인 로그 노출
#define kOAuth_LOG_KAKAO YES
#define kOAuth_LOG_FACEBOOK YES
#define kOAuth_LOG_GOOGLE YES


#pragma mark- LOGIN OAUTH NAME
#define kOAuth_NULL 99
#define kOAuth_NAVER 0
#define kOAuth_KAKAO 1
#define kOAuth_FACEBOOK 2
#define kOAuth_GOOGLE 3


#pragma mark- OPEN URL
#define kOAuthOpenURLSchemeKEY @"UIApplicationOpenURLOptionsSourceApplicationKey"
#define kOAuthOpenURLSchemeKEY_NAVER @"com.nhncorp.NaverSearch"


#pragma mark- Naver Define

#define kOAuthNaverServiceAppUrlScheme    @"loginmoduleappdeeplinkscheme"
#define kOAuthNaverConsumerKey            @"DMM9F1vOnLoTdfm8Qx6w"
#define kOAuthNaverConsumerSecret         @"5_uvXsmbPj"
#define kOAuthNaverServiceAppName         @"loginmoduleapp"





#endif 
