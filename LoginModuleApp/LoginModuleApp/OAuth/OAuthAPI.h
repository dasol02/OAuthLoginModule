#ifndef OAuthAPI_h
#define OAuthAPI_h

#pragma mark - LOG
#define OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER YES // 개발확인 로그
#define OAuth_LOG_MANAGER NO  // 로그인 모듈 로그 노출
#define OAuth_LOG_NAVER YES   // 네이버 로그인 로그 노출
#define OAuth_LOG_KAKAO YES
#define OAuth_LOG_FACEBOOK YES
#define OAuth_LOG_GOOGLE YES

#pragma mark- OPEN URL
#define OAuth_Open_URLSchemeKEY @"UIApplicationOpenURLOptionsSourceApplicationKey"
#define OAuth_Open_URLSchemeKEY_NAVER @"com.nhncorp.NaverSearch"

#pragma mark- Naver Define
#define OAuth_Naver_ServiceAppUrlScheme    @"loginmoduleappdeeplinkscheme"
#define OAuth_Naver_ConsumerKey            @"DMM9F1vOnLoTdfm8Qx6w"
#define OAuth_Naver_ConsumerSecret         @"5_uvXsmbPj"
#define OAuth_Naver_ServiceAppName         @"loginmoduleapp"



#endif 
