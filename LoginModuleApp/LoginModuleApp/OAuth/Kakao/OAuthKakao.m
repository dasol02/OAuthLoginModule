#import "OAuthKakao.h"

#define KAKAO_PROPERTKEY_EMAIL      @"kakao_account.email"
#define KAKAO_PROPERTKEY_NICKNAME   @"properties.nickname"
#define KAKAO_PROPERTKEY_BIRTHDAY   @"kakao_account.birthday"
#define KAKAO_PROPERTKEY_AGE_RANGE  @"kakao_account.age_range"
#define KAKAO_PROPERTKEY_GENDER     @"kakao_account.gender"

@implementation OAuthKakao
    
-(instancetype)init{
    self = [super init];
    self.accessToken = [[[KOSession sharedSession] token] accessToken];
    self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
    return self;
}

#pragma makr- SDK Setting
-(void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}

- (void)requestDidOAuth{
    [KOSession handleDidBecomeActive];
}

#pragma mark - request

- (BOOL)requestOAuthIsLogin{
    if([[KOSession sharedSession] state] == KOSessionStateOpen){
        return YES;
    }
    return NO;
}

-(void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
    [[KOSession sharedSession] close];
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            self.accessToken = [[[KOSession sharedSession] token] accessToken];
            self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
            responseOAuthResult(YES);
        } else {
            responseOAuthResult(NO);
        }
    } authType:(KOAuthType)KOAuthTypeTalk, nil];
}

-(void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) { 
        success ? responseOAuthResult(YES) : responseOAuthResult(NO);
    }];
}

-(void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult{
    [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
        success ?  responseOAuthResult(YES) : responseOAuthResult(NO);
    }];
}

-(void)requestOAuthGetUserData:(responseUserData)responseUserData{
    [KOSessionTask userMeTaskWithPropertyKeys:@[KAKAO_PROPERTKEY_EMAIL,
                                                KAKAO_PROPERTKEY_NICKNAME,
                                                KAKAO_PROPERTKEY_BIRTHDAY,
                                                KAKAO_PROPERTKEY_AGE_RANGE,
                                                KAKAO_PROPERTKEY_GENDER]
                                   completion:^(NSError *error, KOUserMe *me) {
                                       if (error) {
                                           [self kakaoResponseError:error Type:kakaoError_UserData];
                                           responseUserData(NO,@"");
                                       } else {
                                           
                                           NSString *userID = [NSString stringWithFormat:@"사용자 아이디: %@",me.ID];
                                           NSString *userEmail = [NSString stringWithFormat:@"사용자 이메일: %@",me.account.email];
                                           NSString *userNickName = [NSString stringWithFormat:@"사용자 닉네임: %@", me.nickname];
                                           NSString *userBirthday = [NSString stringWithFormat:@"사용자 생일: %@", me.account.birthday];
                                           NSString *userAgeRang = [NSString stringWithFormat:@"사용자 연령대: %lu", (unsigned long)me.account.ageRange];
                                           NSString *userGender = [NSString stringWithFormat:@"사용자 성별: %lu", (unsigned long)me.account.gender];
                                           NSString *responseStr = [NSString stringWithFormat:@"\nKakao\n\n%@\n%@\n%@\n%@\n%@\n%@\n\n토큰 : \n%@\n\n리플레시 토큰 : \n%@",userID,userEmail,userNickName,userBirthday,userAgeRang,userGender,self.accessToken,self.refreshToken];
                                           
                                           responseUserData(YES,responseStr);
                                       }
                                   }];
}

-(void)requestOAuthGetToken:(responseToken)responseToken{
    [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
        if (error) {
            responseToken(NO,@"");
        } else {
            self.accessToken = [[[KOSession sharedSession] token] accessToken];
            self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
            responseToken(YES,self.accessToken);
        }
    }];
}

-(void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult{
    [KOSession sharedSession].automaticPeriodicRefresh = YES;
    self.accessToken = [[[KOSession sharedSession] token] accessToken];
    self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
    responseOAuthResult(YES);
}

- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    if([KOSession isKakaoAccountLoginCallback:url]){
        return [KOSession handleOpenURL:url];
    }else{
        return NO;
    }
}
    
@end
