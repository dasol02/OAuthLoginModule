#ifndef OAuthAPI_h
#define OAuthAPI_h

#pragma mark - LOG
#define OAuth_LOG_MANAGER_DEVELOPER YES // 개발확인 로그
//#define OAuth_LOG_MANAGER           YES // 로그인 모듈 로그 노출
//#define OAuth_LOG_NAVER             YES // 네이버 로그인 로그 노출
//#define OAuth_LOG_KAKAO             YES // 카카오 로그인 로그 노출
//#define OAuth_LOG_FACEBOOK          YES // 페이스북 로그인 로그 노출
//#define OAuth_LOG_GOOGLE            YES // 구글 로그인 로그 노출

#pragma mark- OPEN                      URL
#define OAuth_Open_URLSchemeKEY         @"UIApplicationOpenURLOptionsSourceApplicationKey"
#define OAuth_Open_URLSchemeKEY_NAVER   @"com.nhncorp.NaverSearch"

#pragma mark- Naver                     Define
#define OAuth_Naver_ServiceAppUrlScheme @"loginmoduleappdeeplinkscheme"
#define OAuth_Naver_ConsumerKey         @"DMM9F1vOnLoTdfm8Qx6w"
#define OAuth_Naver_ConsumerSecret      @"5_uvXsmbPj"
#define OAuth_Naver_ServiceAppName      @"loginmoduleapp"


#pragma mark- Google                    Define
#define OAuth_Google_ClientID           @"463686728262-mqjt49pp0e46sf415ui9o7bo8cj9pgn6.apps.googleusercontent.com"



#endif 
