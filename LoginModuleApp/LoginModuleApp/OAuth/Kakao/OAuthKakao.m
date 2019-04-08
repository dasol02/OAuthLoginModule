#import "OAuthKakao.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

#pragma mark - Kakao Propert Key
#define KAKAO_PROPERTKEY_EMAIL      @"kakao_account.email"
#define KAKAO_PROPERTKEY_NICKNAME   @"properties.nickname"
#define KAKAO_PROPERTKEY_BIRTHDAY   @"kakao_account.birthday"
#define KAKAO_PROPERTKEY_AGE_RANGE  @"kakao_account.age_range"
#define KAKAO_PROPERTKEY_GENDER     @"kakao_account.gender"
#pragma mark -

@interface OAuthKakao()
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@end

@implementation OAuthKakao
    
-(instancetype)init{
    self = [super init];
    self.accessToken = [[[KOSession sharedSession] token] accessToken];
    self.refreshToken = [[[KOSession sharedSession] token] refreshToken];
    return self;
}

#pragma mark - SDK Setting
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

-(void)requestOAuthGetUserData:(responseUserData)responseUserData{
    [KOSessionTask userMeTaskWithPropertyKeys:@[KAKAO_PROPERTKEY_EMAIL,
                                                KAKAO_PROPERTKEY_NICKNAME,
                                                KAKAO_PROPERTKEY_BIRTHDAY,
                                                KAKAO_PROPERTKEY_AGE_RANGE,
                                                KAKAO_PROPERTKEY_GENDER]
                                   completion:^(NSError *error, KOUserMe *me) {
                                       struct OAuthUserInfo userInfo;
                                       
                                       if (error) {
                                           userInfo.userName = @"";
                                           responseUserData(NO,userInfo);
                                       } else {
                                           userInfo.userID = me.ID;
                                           userInfo.userEmail = me.account.email;
                                           userInfo.userNickName = me.nickname;
                                           userInfo.userBirthday = me.account.birthday;
                                           userInfo.userAccessToken = self.accessToken;
                                           userInfo.userRefreshToken = self.refreshToken;
                                           userInfo.userAgeRang = [self getKOUserAgeRange: me.account.ageRange];
                                           
                                           responseUserData(YES,userInfo);
                                       }
                                   }];
}

- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    if([KOSession isKakaoAccountLoginCallback:url]){
        return [KOSession handleOpenURL:url];
    }else{
        return NO;
    }
}


#pragma mark - Privite
- (NSString *)getKOUserAgeRange:(KOUserAgeRange)age{
    
    NSString *result;
    
    if (!age) {
        return result;
    }
    
    switch (age) {
        case KOUserAgeRangeType15:
            result = @"15세~19세"; break;
        case KOUserAgeRangeType20:
            result = @"20세~29세"; break;
        case KOUserAgeRangeType30:
            result = @"30세~39세"; break;
        case KOUserAgeRangeType40:
            result = @"40세~49세"; break;
        case KOUserAgeRangeType50:
            result = @"50세~59세"; break;
        case KOUserAgeRangeType70:
            result = @"60세~69세"; break;
        case KOUserAgeRangeType80:
            result = @"70세~79세"; break;
        case KOUserAgeRangeType90:
            result = @"80세~89세"; break;
        default:
            break;
    }
    
    return result;
    
}


    
@end
