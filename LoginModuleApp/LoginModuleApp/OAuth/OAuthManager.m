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
    
    return self;
}


// 사용자 데이터 호출
- (void)oAuthManagerUserData{
    NSLog(@"\nOAUTH MANAGER oAuthManagerUserData");
    [self.oAuthNaver oAuthNaverUserData];
}


// 로그인
- (void)oAuthManagerLogin:(int)loginOAuthName {
    NSLog(@"\nOAUTH MANAGER oAuthManagerLogin");
    [[IndicatorView sharedInstnace] show];
    //    if([self.thirdPartyLoginConn state]){ //Naver
    [self.oAuthNaver oAuthNaverLogin];
}


// 로그아웃
- (void)oAuthManagerLogout{
    [self.oAuthNaver oAuthNaverLogout];
}


// 인증 해제
- (void)oAuthManagerDelete{
    NSLog(@"\nOAUTH MANAGER oAuthManagerDelete");
    [[IndicatorView sharedInstnace] show];
    [self.oAuthNaver oAuthNaverDelete];
}


// 토큰 갱신
- (void)oAuthManagerRefreshToken{
    NSLog(@"\nOAUTH MANAGER oAuthManagerRefreshToken");
    [[IndicatorView sharedInstnace] show];
    [self.oAuthNaver oAuthNaverRefreshToken];
}


// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
    NSLog(@"\nOAUTH MANAGER oAuthManagerLoginState");
    NSArray *arrayToken = [self oAUthManagerGetAccessToken];

    if([arrayToken count] <= 1){return NO;}

    if(arrayToken[1] == nil || [arrayToken[1] length] <= 0 || [arrayToken isKindOfClass:[NSNull class]]){return NO;}
    
    return YES;
}


#pragma mark - CLASS METHOD
// 토큰반환
- (NSArray*)oAUthManagerGetAccessToken{
    NSLog(@"\nOAUTH MANAGER oAUthManagerGetAccessToken");
    NSString *oAuthType = nil;
    NSString *accessToken = nil;
    
    if([self.oAuthNaver.thirdPartyLoginConn state]){ // NAVER
        oAuthType = @"NAVER";
        accessToken = self.oAuthNaver.thirdPartyLoginConn.accessToken;
    }
    return [NSArray arrayWithObjects:oAuthType, accessToken, nil];
}


#pragma mark - OAuth OPEN URL SCHEME
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    NSLog(@"\nOAUTH MANAGER oAuthCheckOpenURL");
    if([[options objectForKey:kAuthOpenURLSchemeKEY] isEqualToString:kAuthOpenURLSchemeKEY_NAVER]){
        return [self.oAuthNaver oAuthCheckOpenURL:app openURL:url options:options];
    }else{
        return NO;
    }
}


#pragma mark- DELEGATE

-(void)oAuthDelegateSuccess:(int)oAuthName{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OAuthLoginSuccess" object:nil];
    [[IndicatorView sharedInstnace]dismiss];
    NSLog(@"\n oAuthDelegateSuccess %@",[NSString stringWithFormat:@"%d",oAuthName]);
}

- (void)oAuthDelegateErorr:(NSError *)error OAuthName:(int)oAuthName{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OAuthLoginSuccess" object:nil];
    [[IndicatorView sharedInstnace]dismiss];
    NSLog(@"\n oAuthDelegateErorr %@",[NSString stringWithFormat:@"%d",oAuthName]);
}

-(void)oAuthDelegateOAuthManagerUserData:(NSString *)userData{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
        [self.delegate getOAuthManagerUserData:userData];
    }
    NSLog(@"\n oAuthDelegateOAuthManagerUserData");
}
@end
