#import "OAuthManager.h"

@implementation OAuthManager

+ (OAuthManager *)sharedInstnace{
    static OAuthManager *oAuthManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthManager = [[OAuthManager alloc] init];
    });
    
    return oAuthManager;
}

-(instancetype)init{
    self = [super init];
    
    // 네이버
    self.oAuthNaver = [[OAuthNaver sharedInstnace] init];
    self.oAuthNaver.delegate = self;
    
    
    // 카카오
    self.oAuthKakao = [[OAuthKakao sharedInstnace] init];
    self.oAuthKakao.delegate = self;
    
    [self oAuthManagerRefreshToken];
    

    return self;
}

// 카카오 토큰 확인
- (void)getOAuthToken{
    [self.oAuthKakao oAuthKakaoGetToken];
}

#pragma mark - REQUEST
- (void)oAuthManagerUserData{
#ifdef OAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"OAUTH MANAGER request UserData");
#endif
    
    [[IndicatorView sharedInstnace] show];
    switch (oAuthLoginName) {
        case oAuthName_Naver:
             [self.oAuthNaver oAuthNaverUserData];
            break;
            
        case oAuthName_Kakao:
            [self.oAuthKakao oAuthKakaoUserData];
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            break;
    }
}


// 로그인
- (void)oAuthManagerLogin:(int)loginoAuthName {
#ifdef OAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"OAUTH MANAGER request Login");
#endif
    [[IndicatorView sharedInstnace] show];
    switch (loginoAuthName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverLogin];
            break;
            
        case oAuthName_Kakao:
            [[IndicatorView sharedInstnace]dismiss];
            [self.oAuthKakao oAuthKakaoLogin];
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            [[IndicatorView sharedInstnace]dismiss];
            break;
    }
}


// 로그아웃
- (void)oAuthManagerLogout{
#ifdef OAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"OAUTH MANAGER request Logout");
#endif
    [[IndicatorView sharedInstnace]show];
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverLogout];
            break;
            
        case oAuthName_Kakao:
            [self.oAuthKakao oAuthKakaoLogout];
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            [[IndicatorView sharedInstnace]dismiss];
            break;
    }
}


// 인증 해제
- (void)oAuthManagerDelete{
#ifdef OAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"OAUTH MANAGER request Delete");
#endif
    [[IndicatorView sharedInstnace]show];
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverDelete];
            break;
            
        case oAuthName_Kakao:
            [self.oAuthKakao oAuthKakaoDelete];
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            [[IndicatorView sharedInstnace]dismiss];
            break;
    }
}


// 토큰 갱신
- (void)oAuthManagerRefreshToken{
#ifdef OAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"OAUTH MANAGER request RefreshToken");
#endif
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverRefreshToken];
            break;
            
        case oAuthName_Kakao:
            [self.oAuthKakao oAuthKakaoRefreshToken];
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            break;
    }
}

#pragma mark - GET OAUTH LOGIN NAME
- (NSString *)getOAuthgetLoginName{
    NSString *strOAuthLoginName;
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            strOAuthLoginName = @"NAVER";
            break;
            
        case oAuthName_Kakao:
            strOAuthLoginName = @"KAKAO";
            break;
            
        case oAuthName_Facebook:
            strOAuthLoginName = @"FACEBOOK";
            break;
            
        case oAuthName_Google:
            strOAuthLoginName = @"GOOGLE";
            break;
            
        default:
            strOAuthLoginName = @"NULL";
            break;
    }
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
    NSLog(@"OAUTH MANAGER LoginName == %@",strOAuthLoginName);
#endif
    return strOAuthLoginName;
}

// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
    if([self.oAuthNaver getLoginState]){
        oAuthLoginName = oAuthName_Naver;
        self.oAuthAccessToken = self.oAuthNaver.accessToken;
        self.oAuthRefreshToken = self.oAuthNaver.refreshToken;
        [self getOAuthgetLoginName];
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
        NSLog(@"OAUTH MANAGER Token \n==============================\noAuthAccessToken == %@\noAuthRefreshToken == %@ \n==============================",self.oAuthAccessToken,self.oAuthRefreshToken);
#endif
        return YES;
    }else if([self.oAuthKakao getLoginState]){
        oAuthLoginName = oAuthName_Kakao;
        self.oAuthAccessToken = self.oAuthKakao.accessToken;
        self.oAuthRefreshToken = self.oAuthKakao.refreshToken;
        [self getOAuthgetLoginName];
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
        NSLog(@"OAUTH MANAGER Token \n==============================\noAuthAccessToken == %@\noAuthRefreshToken == %@ \n==============================",self.oAuthAccessToken,self.oAuthRefreshToken);
#endif
        return YES;
    }else{
        oAuthLoginName = oAuthName_Default;
        [self getOAuthgetLoginName];
        self.oAuthAccessToken = nil;
        self.oAuthRefreshToken = nil;
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
        NSLog(@"OAUTH MANAGER Token \n==============================\noAuthAccessToken == %@\noAuthRefreshToken == %@ \n==============================",self.oAuthAccessToken,self.oAuthRefreshToken);
#endif
        return NO;
    }
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
    NSLog(@"OAUTH MANAGER request OpenURL");
#endif
    if([[options objectForKey:OAuth_Open_URLSchemeKEY] isEqualToString:OAuth_Open_URLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else if([self.oAuthKakao isKakaoAccountLoginCallback:url]){
        return [self.oAuthKakao handleOpenURL:url];
    }else{
        return NO;
    }
}

#pragma mark- DELEGATE

- (void)oAuthResponseLoginResult:(BOOL)state OAuthName:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
    NSLog(@"OAUTH MANAGER Response LOGIN %@, %@",state?@"YES":@"NO",[self getOAuthName:oAuthName]);
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLoginResult:)]){
        [self.delegate responseLoginResult:YES];
    }
    [[IndicatorView sharedInstnace]dismiss];
}
    
- (void)oAuthResponseLogoutResult:(BOOL)state OAuthName:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
     NSLog(@"OAUTH MANAGER Response Logout %@, %@",state?@"YES":@"NO",[self getOAuthName:oAuthName]);
#endif
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLogoutResult:)]){
        [self.delegate responseLogoutResult:state];
    }
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseOAuthManagerUserData:(NSString *)userData{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
    NSLog(@"OAUTH MANAGER Response OAuthManagerUserData");
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    [[IndicatorView sharedInstnace]dismiss];
}
    
    -(void)oAuthResponseSuccess:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
        NSLog(@"OAUTH MANAGER Response Success %@",[self getOAuthName:oAuthName]);
#endif
        [[IndicatorView sharedInstnace]dismiss];
    }
    
- (void)oAuthResponseErorr:(NSError *)error OAuthName:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER)
    NSLog(@"OAUTH MANAGER Response Erorr %@",[self getOAuthName:oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}
    
    
    
- (NSString *)getOAuthName:(int)oAuthName{
    NSString *strOauthName;
    switch (oAuthName) {
        case oAuthName_Naver:
        strOauthName = @"Naver";
        break;
        case oAuthName_Kakao:
        strOauthName = @"Kakao";
        break;
        case oAuthName_Google:
        strOauthName = @"Google";
        break;
        case oAuthName_Facebook:
        strOauthName = @"Facebook";
        break;
        case oAuthName_Default:
        strOauthName = @"Default";
        break;
        default:
        strOauthName = @"Default";
        break;
    }
    return strOauthName;
}
@end
