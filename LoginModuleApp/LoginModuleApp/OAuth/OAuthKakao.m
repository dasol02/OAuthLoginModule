#import "OAuthKakao.h"

@implementation OAuthKakao

+ (OAuthKakao *)sharedInstnace{
    static OAuthKakao *oAuthKakao = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthKakao = [[OAuthKakao alloc] init];
    });
    
    return oAuthKakao;
}
    
    
-(instancetype)init{
    self = [super init];

    self.accessToken = [[[KOSession sharedSession] token] accessToken];
    self.refreshToken = [[[KOSession sharedSession] token] refreshToken];

    return self;
}

    
- (BOOL)getLoginState{
    if([[KOSession sharedSession] state] == KOSessionStateOpen){
        return YES;
    }
    return NO;
}
    
- (void)oAuthKakaoLogin{
    
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            self.accessToken = [[[KOSession sharedSession] token] accessToken];
            self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLoginResult:OAuthName:)]){
                [self.delegate oAuthResponseLoginResult:YES OAuthName:oAuthName_Kakao];
            }
//            NSLog(@"kakao login succeeded.");
        } else {
            [self kakaoResponseError:error Type:kakaoError_Login];
        }

    } authType:(KOAuthType)KOAuthTypeTalk, nil];
}
    
- (void)oAuthKakaoLogout{
    
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
                [self.delegate oAuthResponseLogoutResult:YES OAuthName:oAuthName_Kakao];
            }
//           NSLog(@"oAuthKakaoLogout Success");
        } else {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
                [self.delegate oAuthResponseLogoutResult:NO OAuthName:oAuthName_Kakao];
            }
        }
    }];
}
    
- (void)oAuthKakaoDelete{
    
    [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
                [self.delegate oAuthResponseLogoutResult:YES OAuthName:oAuthName_Kakao];
            }
//            NSLog(@"oAuthKakaoDelete Success");
        } else {
            [self kakaoResponseError:error Type:kakaoError_Delete];
        }
    }];
}
    
- (void)oAuthKakaoUserData{
    
    [KOSessionTask userMeTaskWithPropertyKeys:@[@"kakao_account.email",
                                                @"properties.nickname",
                                                @"kakao_account.birthday",
                                                @"kakao_account.age_range",
                                                @"kakao_account.gender"]
                                   completion:^(NSError *error, KOUserMe *me) {
                                       if (error) {
                                           [self kakaoResponseError:error Type:kakaoError_UserData];
                                       } else {
                                           NSString *userID = [NSString stringWithFormat:@"사용자 아이디: %@",me.ID];
                                           NSString *userEmail = [NSString stringWithFormat:@"사용자 이메일: %@",me.account.email];
                                           NSString *userNickName = [NSString stringWithFormat:@"사용자 닉네임: %@", me.nickname];
                                           NSString *userBirthday = [NSString stringWithFormat:@"사용자 생일: %@", me.account.birthday];
                                           NSString *userAgeRang = [NSString stringWithFormat:@"사용자 연령대: %lu", (unsigned long)me.account.ageRange];
                                           NSString *userGender = [NSString stringWithFormat:@"사용자 성별: %lu", (unsigned long)me.account.gender];
                                           
                                           
                                           NSString *responseStr = [NSString stringWithFormat:@"\nKakao\n\n%@\n%@\n%@\n%@\n%@\n%@\n\n토큰 : \n%@\n\n리플레시 토큰 : \n%@",userID,userEmail,userNickName,userBirthday,userAgeRang,userGender,self.accessToken,self.refreshToken];
                                           
                                           if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseOAuthManagerUserData:)]){
                                               [self.delegate oAuthResponseOAuthManagerUserData:responseStr];
                                           }
                                       }
                                   }];
}
    
    
- (void)oAuthKakaoGetToken{
    
    [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
        if (error) {
            [self kakaoResponseError:error Type:kakaoError_GetToken];
        } else {
            self.accessToken = [[[KOSession sharedSession] token] accessToken];
            self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
//            self.accessToken = [accessTokenInfo.ID stringValue];
            // 성공 (토큰이 유효함)
//            NSLog(@"남은 유효시간: %@ (단위: ms)", accessTokenInfo.expiresInMillis);
        }
    }];
}
    
    
- (void)oAuthKakaoRefreshToken{
    [KOSession sharedSession].automaticPeriodicRefresh = YES;
    self.accessToken = [[[KOSession sharedSession] token] accessToken];
    self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
}
    
    
#pragma mark- OPEN URL
- (BOOL)isKakaoAccountLoginCallback:(NSURL *)url{
    return [KOSession isKakaoAccountLoginCallback:url];
}
- (BOOL)handleOpenURL:(NSURL *)url{
    return [KOSession handleOpenURL:url];
}
    
#pragma mark- DELEGATE
- (void)kakaoResponseError:(NSError*)error Type:(int)type{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseErorr:OAuthName:)]){
        [self.delegate oAuthResponseErorr:error OAuthName:oAuthName_Kakao];
    }
    
#if defined(OAuth_LOG_KAKAO)
    NSString *strType;
    switch (type) {
        case kakaoError_Login:
        strType = @"LOGIN";
        break;
        case kakaoError_Logout:
        strType = @"Logout";
        break;
        case kakaoError_Delete:
        strType = @"Delete";
        break;
        case kakaoError_UserData:
        strType = @"UserData";
        break;
        case kakaoError_GetToken:
        strType = @"GetToken";
        break;
        default:
        strType = @"Default";
        break;
    }
    NSLog(@"\nOAuth Kakao Response Error %@",strType);
#endif
}
    
@end
