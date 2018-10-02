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


#pragma mark - REQUEST
- (void)oAuthManagerUserData{
#ifdef OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER request UserData");
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
#ifdef OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER request Login");
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
#ifdef OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER request Logout");
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
#ifdef OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER request Delete");
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
#ifdef OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER
    NSLog(@"\nOAUTH MANAGER request RefreshToken");
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
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
    NSLog(@"\nOAUTH MANAGER LoginName == %@",strOAuthLoginName);
#endif
    return strOAuthLoginName;
}

// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
    if([self.oAuthNaver getLoginState]){
        oAuthLoginName = oAuthName_Naver;
        [self getOAuthgetLoginName];
        return YES;
    }else{
        oAuthLoginName = oAuthName_Default;
        [self getOAuthgetLoginName];
        return NO;
    }
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
    NSLog(@"\nOAUTH MANAGER request OpenURL");
#endif
    if([[options objectForKey:OAuth_Open_URLSchemeKEY] isEqualToString:OAuth_Open_URLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else{
        return NO;
    }
}

#pragma mark- DELEGATE

- (void)oAuthResponseLoginResult:(BOOL)state oAuthName:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
     NSLog(@"\nOAUTH MANAGER Response Success %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseLoginResult:)]){
        [self.delegate responseLoginResult:YES];
    }
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseSuccess:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
    NSLog(@"\nOAUTH MANAGER Response Success %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

- (void)oAuthResponseErorr:(NSError *)error oAuthName:(int)oAuthName{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
    NSLog(@"\nOAUTH MANAGER Response Erorr %@",[NSString stringWithFormat:@"%d",oAuthName]);
#endif
    [[IndicatorView sharedInstnace]dismiss];
}

-(void)oAuthResponseOAuthManagerUserData:(NSString *)userData{
#if defined(OAuth_LOG_MANAGER) || defined(OAuth_LOG_MANAGER_DEVELOPER_DEVELOPER)
    NSLog(@"\nOAUTH MANAGER Response OAuthManagerUserData");
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    [[IndicatorView sharedInstnace]dismiss];
}
@end
