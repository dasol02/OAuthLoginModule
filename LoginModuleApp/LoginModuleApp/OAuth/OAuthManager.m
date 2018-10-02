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
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerUserData");
#endif
    
    [[IndicatorView sharedInstnace] show];
    switch (oAuthLoginName) {
        case oAuthName_Naver:
             [self.oAuthNaver oAuthNaverUserData];
            break;
            
        case oAuthName_Kakao:
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
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogin");
#endif
    [[IndicatorView sharedInstnace] show];
    switch (loginoAuthName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverLogin];
            break;
            
        case oAuthName_Kakao:
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
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogout");
#endif
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverLogout];
            break;
            
        case oAuthName_Kakao:
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            break;
    }
}


// 인증 해제
- (void)oAuthManagerDelete{
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerDelete");
#endif
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverDelete];
            break;
            
        case oAuthName_Kakao:
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            break;
    }
}


// 토큰 갱신
- (void)oAuthManagerRefreshToken{
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerRefreshToken");
#endif
    switch (oAuthLoginName) {
        case oAuthName_Naver:
            [self.oAuthNaver oAuthNaverRefreshToken];
            break;
            
        case oAuthName_Kakao:
            break;
            
        case oAuthName_Facebook:
            break;
            
        case oAuthName_Google:
            break;
            
        default:
            break;
    }
}

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
    return strOAuthLoginName;
}

# pragma mark -


// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
#if OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER oAuthManagerLoginState");
#endif
    if([self.oAuthNaver getLoginState]){
        oAuthLoginName = oAuthName_Naver;
        return YES;
    }else{
        oAuthLoginName = oAuthName_Default;
        return NO;
    }
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
#if OAuth_LOG_MANAGER
    NSLog(@"\nOAUTH MANAGER oAuthCheckOpenURL");
#endif
    if([[options objectForKey:OAuth_Open_URLSchemeKEY] isEqualToString:OAuth_Open_URLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else{
        return NO;
    }
}

#pragma mark- DELEGATE

- (void)oAuthResponseLoginResult:(BOOL)state oAuthName:(int)oAuthName{
#if OAuth_LOG_MANAGER
     NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLoginResult:)]){
        [self.delegate responseLoginResult:YES];
    }
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseSuccess:(int)oAuthName{
#if OAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

- (void)oAuthResponseErorr:(NSError *)error oAuthName:(int)oAuthName{
#if OAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseErorr %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseOAuthManagerUserData:(NSString *)userData{
#if OAuth_LOG_MANAGER
    NSLog(@"\n oAuthResponseOAuthManagerUserData");
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    [[IndicatorView sharedInstnace]dismiss];
}
@end
