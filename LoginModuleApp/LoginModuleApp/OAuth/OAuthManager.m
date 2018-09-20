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
    NSLog(@"\nOAUTH MANAGER oAuthManagerUserData");
    
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
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogin");
    
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
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogout");
    
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
    NSLog(@"\nOAUTH MANAGER oAuthManagerDelete");
    
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
    NSLog(@"\nOAUTH MANAGER oAuthManagerRefreshToken");
    
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
    NSLog(@"\nOAUTH MANAGER oAuthManagerLoginState");
    
    if([self.oAuthNaver getLoginState]){
        oAuthLoginName = kOAuth_NAVER;
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    NSLog(@"\nOAUTH MANAGER oAuthCheckOpenURL");
    if([[options objectForKey:kAuthOpenURLSchemeKEY] isEqualToString:kOAuthOpenURLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else{
        return NO;
    }
}

#pragma mark- DELEGATE

- (void)oAuthResponseLoginResult:(BOOL)state OAuthName:(int)oAuthName{
    [[IndicatorView sharedInstnace]dismiss];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLoginResult:)]){
        [self.delegate responseLoginResult:YES];
    }
    NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
}

-(void)oAuthResponseSuccess:(int)oAuthName{
    NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
}

- (void)oAuthResponseErorr:(NSError *)error OAuthName:(int)oAuthName{
    NSLog(@"\n oAuthResponseErorr %@",[NSString stringWithFormat:@"%d",oAuthName]);
}

-(void)oAuthResponseOAuthManagerUserData:(NSString *)userData{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    NSLog(@"\n oAuthResponseOAuthManagerUserData");
}
@end
