#ifndef OAuthAPI_h
#define OAuthAPI_h

#pragma mark - OAuth User Info Struct
typedef struct OAuthUserInfo {
    NSString *userName;
    NSString *userID;
    NSString *userGender;
    NSString *userEmail;
    NSString *userNickName;
    NSString *userAgeRang;
    NSString *userBirthday;
    NSString *userProfileImage;
    NSString *userAccessToken;
    NSString *userRefreshToken;
    NSString *userTokenRefreshDate;
} OAuthUserInfo;

#pragma mark - TYPDEF BLOCK RESPONSE
typedef void (^responseOAuthResult)(bool result) ; // 로그인 결과
typedef void (^responseUserData)(bool result, OAuthUserInfo userInfo) ; // 사용자 데이터 조회
typedef void (^responseToken)(bool result, NSString *token) ; // 토큰값 출력

#pragma mark - OATUTH TYPE ENUM
typedef NS_ENUM(NSUInteger,OAUTH_TYPE){
    OAUTH_TYPE_NAVER,
    OAUTH_TYPE_KAKAO,
    OAUTH_TYPE_FACEBOOK,
    OAUTH_TYPE_GOOGLE
};

#endif /* OAuthAPI_h */
