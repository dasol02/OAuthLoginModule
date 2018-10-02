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
    
    self.oAuthNaver = [[OAuthNaver sharedInstnace]init];
    self.oAuthNaver.delegate = self;
    [self.oAuthNaver oAuthNaverRefreshToken]; //토큰 갱신
    
    return self;
}


// 사용자 데이터 호출
- (void)oAuthManagerUserData{
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerUserData");
#endif
    switch (oAuthLoginName) {
        case kOAuth_NAVER:
             [self.oAuthNaver oAuthNaverUserData];
            break;
            
        case kOAuth_KAKAO:
            break;
            
        case kOAuth_FACEBOOK:
            break;
            
        case kOAuth_GOOGLE:
            break;
            
        default:
            break;
    }
}


// 로그인
- (void)oAuthManagerLogin:(int)loginOAuthName {
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogin");
#endif
    [[IndicatorView sharedInstnace] show];
    switch (loginOAuthName) {
        case kOAuth_NAVER:
            [self.oAuthNaver oAuthNaverLogin];
            break;
            
        case kOAuth_KAKAO:
            break;
            
        case kOAuth_FACEBOOK:
            break;
            
        case kOAuth_GOOGLE:
            break;
            
        default:
            [[IndicatorView sharedInstnace]dismiss];
            break;
    }
}


// 로그아웃
- (void)oAuthManagerLogout{
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogout");
#endif
    switch (oAuthLoginName) {
        case kOAuth_NAVER:
            [self.oAuthNaver oAuthNaverLogout];
            break;
            
        case kOAuth_KAKAO:
            break;
            
        case kOAuth_FACEBOOK:
            break;
            
        case kOAuth_GOOGLE:
            break;
            
        default:
            break;
    }
}


// 인증 해제
- (void)oAuthManagerDelete{
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerDelete");
#endif
    switch (oAuthLoginName) {
        case kOAuth_NAVER:
            [self.oAuthNaver oAuthNaverDelete];
            break;
            
        case kOAuth_KAKAO:
            break;
            
        case kOAuth_FACEBOOK:
            break;
            
        case kOAuth_GOOGLE:
            break;
            
        default:
            break;
    }
}


// 토큰 갱신
- (void)oAuthManagerRefreshToken{
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerRefreshToken");
#endif
    switch (oAuthLoginName) {
        case kOAuth_NAVER:
            [self.oAuthNaver oAuthNaverRefreshToken];
            break;
            
        case kOAuth_KAKAO:
            break;
            
        case kOAuth_FACEBOOK:
            break;
            
        case kOAuth_GOOGLE:
            break;
            
        default:
            break;
    }
}

- (int)oAuthgetLoginName{
    return oAuthLoginName;
}

# pragma mark -


// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
#if kOAuth_LOG_MANAGER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLoginState");
#endif
    if([self.oAuthNaver getLoginState]){
        oAuthLoginName = kOAuth_NAVER;
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
#if kOAuth_LOG_MANAGER
    NSLog(@"\nOAUTH MANAGER oAuthCheckOpenURL");
#endif
    if([[options objectForKey:kOAuthOpenURLSchemeKEY] isEqualToString:kOAuthOpenURLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else{
        return NO;
    }
}

#pragma mark- DELEGATE

- (void)oAuthResponseLoginResult:(BOOL)state OAuthName:(int)oAuthName{
#if kOAuth_LOG_MANAGER
     NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    
    [[IndicatorView sharedInstnace]dismiss];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLoginResult:)]){
        [self.delegate responseLoginResult:YES];
    }
}

-(void)oAuthResponseSuccess:(int)oAuthName{
#if kOAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

- (void)oAuthResponseErorr:(NSError *)error OAuthName:(int)oAuthName{
#if kOAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseErorr %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseOAuthManagerUserData:(NSString *)userData{
#if kOAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseOAuthManagerUserData");
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    [[IndicatorView sharedInstnace]dismiss];
}
@end
