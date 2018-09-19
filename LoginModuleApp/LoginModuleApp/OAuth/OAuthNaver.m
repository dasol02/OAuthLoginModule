#import "OAuthNaver.h"

@implementation OAuthNaver

+ (OAuthNaver *)sharedInstnace{
    static OAuthNaver *oAuthNaver = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthNaver = [[OAuthNaver alloc] init];
    });
    
    return oAuthNaver;
}

-(instancetype)init{
    self = [super init];
    
    self.thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
    self.thirdPartyLoginConn.delegate = self;
    [self setOAuthNaverSetting];
    
    return self;
}

#pragma mark - OAuth First Setting
- (void)setOAuthNaverSetting{
    [self.thirdPartyLoginConn setIsNaverAppOauthEnable:YES];
    [self.thirdPartyLoginConn setServiceUrlScheme:kServiceAppUrlScheme];
    [self.thirdPartyLoginConn setConsumerKey:kConsumerKey];
    [self.thirdPartyLoginConn setConsumerSecret:kConsumerSecret];
    [self.thirdPartyLoginConn setAppName:kServiceAppName];
}

#pragma mark - REQUEST OAuth
- (BOOL)getLoginState{
    
    NSString * accessToken;
    
    if([self.thirdPartyLoginConn state]){
        accessToken = self.thirdPartyLoginConn.accessToken;
    }
    
    if(accessToken == nil || accessToken.length <= 0 || [accessToken isKindOfClass:[NSNull class]]){
        return NO;
    }
    
    return YES;
}

- (void)oAuthNaverUserData{
     [self getNaverUserData];
}

- (void)oAuthNaverLogin{
     [self.thirdPartyLoginConn requestThirdPartyLogin];
    
}

- (void)oAuthNaverLogout{
     [self.thirdPartyLoginConn resetToken];
    
}

- (void)oAuthNaverDelete{
     [self.thirdPartyLoginConn requestDeleteToken];
    
}

- (void)oAuthNaverRefreshToken{
    // 전급 토근은 있고 &&  유효기간이 지난 경우
    if([self.thirdPartyLoginConn state] && [self.thirdPartyLoginConn isValidAccessTokenExpireTimeNow] == NO){
        [self.thirdPartyLoginConn requestAccessTokenWithRefreshToken];
        NSLog(@"\nOAUTH NAVER oAuthNaverRefreshToken SUCCES");
    }else{
        NSLog(@"\nOAUTH NAVER oAuthNaverRefreshToken FAIL");
    }
}

- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    return [self.thirdPartyLoginConn application:app openURL:url options:options];
}



#pragma mark- REQUEST USER PROFILE

// 유저 데이터 요청
- (void)getNaverUserData{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"basic_attribution", @"scenario_type",
                         nil];
    
    NSString *urlString = @"https://openapi.naver.com/v1/nid/me"; // 사용자 프로필 호출 API URL
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", self.thirdPartyLoginConn.accessToken];
    NSError *error;
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    [urlRequest setURL:[NSURL URLWithString:urlString]];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthDelegateOAuthManagerUserData:)]){
              [self.delegate oAuthDelegateOAuthManagerUserData:responseStr];
          }
          NSLog(@"Data received: %@", responseStr);
      }] resume];
}



#pragma mark- NAVER OAuth20 deleagate
// 로그인 성공
- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    NSString *result = [NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", self.thirdPartyLoginConn.accessToken, self.thirdPartyLoginConn.accessTokenExpireDate, self.thirdPartyLoginConn.refreshToken];
    NSLog(@"\nOAuth Login === NAVER \n%@",result);
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthDelegateLoginResult:OAuthName:)]){
        [self.delegate oAuthDelegateLoginResult:YES OAuthName:kAuthLoginName_NAVER];
    }
    
}

// 로그인 실패
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error{
    NSLog(@"\nOAuth Login === NAVER \n%@",error);
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthDelegateLoginResult:OAuthName:)]){
        [self.delegate oAuthDelegateLoginResult:NO OAuthName:kAuthLoginName_NAVER];
    }
}

// 인증해제
- (void)oauth20ConnectionDidFinishDeleteToken{
    NSLog(@"\nOAuth Login === NAVER \n%@",@"네이버 토큰 인증해제 완료");
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthDelegateSuccess:)]){
        [self.delegate oAuthDelegateSuccess:kAuthLoginName_NAVER];
    }
}

// 토큰 갱신
- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken{
    NSString *result = [NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthDelegateSuccess:)]){
        [self.delegate oAuthDelegateSuccess:kAuthLoginName_NAVER];
    }
    NSLog(@"\nOAuth Login === NAVER \n%@",result);
}

// 인앱 로그인 // 실행여부 미확인
- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request{
    //    NLoginThirdPartyOAuth20InAppBrowserViewController *inappAuthBrowser = [[NLoginThirdPartyOAuth20InAppBrowserViewController alloc]initWithRequest:request];
    //    [self.navigationController pushViewController:inappAuthBrowser animated:YES];
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFinishAuthorizationWithResult:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType
{
    NSLog(@"Getting auth code from NaverApp success!");
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailAuthorizationWithRecieveType:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType
{
     NSLog(@"Getting auth code from NaverApp faile!");
}


@end
