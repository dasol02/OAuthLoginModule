#ifndef OAuthAPI_h
#define OAuthAPI_h

#pragma mark - TYPDEF BLOCK RESPONSE
typedef void (^responseOAuthResult)(bool result) ; // 로그인 결과
typedef void (^responseUserData)(bool result, NSString *userData) ; // 사용자 데이터 조회
typedef void (^responseToken)(bool result, NSString *token) ; // 토큰값 출력

#pragma mark - OATUTH TYPE ENUM
typedef NS_ENUM(NSUInteger,OAUTH_TYPE){
    OAUTH_TYPE_NAVER,
    OAUTH_TYPE_KAKAO,
    OAUTH_TYPE_FACEBOOK,
    OAUTH_TYPE_GOOGLE
};

#endif /* OAuthAPI_h */
