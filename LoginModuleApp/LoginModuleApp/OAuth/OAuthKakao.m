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
            // login success
            NSLog(@"kakao login succeeded.");
        } else {
            // failed
            NSLog(@"kakao login failed.");
        }
    }];
}
    
- (void)oAuthKakaoLogout{
    
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
           NSLog(@"oAuthKakaoLogout Success");
        } else {
           NSLog(@"oAuthKakaoLogout Fail");
        }
    }];
}
    
- (void)oAuthKakaoDelete{
    
    [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"oAuthKakaoDelete Success");
        } else {
            NSLog(@"oAuthKakaoDelete Fail");
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
                                           NSLog(@"oAuthKakaoUserData Fail");
                                           
                                       } else {
                                           NSString *userID = [NSString stringWithFormat:@"사용자 아이디: %@",me.ID];
                                           NSString *userEmail = [NSString stringWithFormat:@"사용자 이메일: %@",me.account.email];
                                           NSString *userNickName = [NSString stringWithFormat:@"사용자 닉네임: %@", me.nickname];
                                           NSString *userBirthday = [NSString stringWithFormat:@"사용자 생일: %@", me.account.birthday];
                                           NSString *userAgeRang = [NSString stringWithFormat:@"사용자 연령대: %lu", (unsigned long)me.account.ageRange];
                                           NSString *userGender = [NSString stringWithFormat:@"사용자 성별: %lu", (unsigned long)me.account.gender];
                                           
                                           
                                           NSString *responseStr = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n",userID,userEmail,userNickName,userBirthday,userAgeRang,userGender];
                                           
                                           if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseOAuthManagerUserData:)]){
                                               [self.delegate oAuthResponseOAuthManagerUserData:responseStr];
                                           }
                                       }
                                   }];
}
    
    
- (void)oAuthKakaoGetToken{
    
    [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
        if (error) {
            NSLog(@"oAuthKakaoGetToken Fail");
            switch (error.code) {
                case KOErrorDeactivatedSession:
                // 세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태
                break;
                default:
                // 예기치 못한 에러. 서버 에러
                break;
            }
        } else {
            // 성공 (토큰이 유효함)
            NSLog(@"남은 유효시간: %@ (단위: ms)", accessTokenInfo.expiresInMillis);
        }
    }];
}
    
    
- (void)oAuthKakaoRefreshToken{
    [KOSession sharedSession].automaticPeriodicRefresh = YES;
}
    
    
#pragma mark- OPEN URL
- (BOOL)isKakaoAccountLoginCallback:(NSURL *)url{
    return [KOSession isKakaoAccountLoginCallback:url];
}
- (BOOL)handleOpenURL:(NSURL *)url{
    return [KOSession handleOpenURL:url];
}
    
@end
