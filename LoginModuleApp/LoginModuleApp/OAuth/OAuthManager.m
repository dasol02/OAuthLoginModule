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
    self.thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
    self.thirdPartyLoginConn.delegate = self;
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


#pragma mark - OAuth openURL Cehck
- (BOOL)oAuthCheckOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    if([[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.nhncorp.NaverSearch"]){
        return [[NaverThirdPartyLoginConnection getSharedInstance] application:app openURL:url options:options];
    }else{
        return NO;
    }
}



// 로그인 여부 확인
- (BOOL)oAuthManagerLoginState{
    NSArray *arrayToken = [self oAUthManagerGetAccessToken];

    if([arrayToken count] <= 1){
        return NO;
    }

    if(arrayToken[1] == nil || [arrayToken[1] length] <= 0 || [arrayToken isKindOfClass:[NSNull class]]){
        return NO;
    }
    
    return YES;
}


#pragma mark- Naver OAuth
// 사용자 데이터 호출
- (void)oAuthManagerUserData{
    [self getNaverUserData];
}


// 토큰 갱신
- (void)oAuthManagerRefreshToken{
    if([self.thirdPartyLoginConn state] && [self.thirdPartyLoginConn isValidAccessTokenExpireTimeNow] == NO){ //Naver
         [self.thirdPartyLoginConn requestAccessTokenWithRefreshToken];
    }
}


// 인증 해제
- (void)oAuthManagerDelete{
    if([self.thirdPartyLoginConn state] ){ //Naver
        [self.thirdPartyLoginConn requestDeleteToken];
    }
}


// 로그아웃
- (void)oAuthManagerLogout{
    if([self.thirdPartyLoginConn state]){ //Naver
        [[IndicatorView sharedInstnace] show];
        [self.thirdPartyLoginConn resetToken];
    }
}


// 토큰반환
- (NSArray*)oAUthManagerGetAccessToken{
    NSString *oAuthType = nil;
    NSString *accessToken = nil;
    
    if([self.thirdPartyLoginConn state]){ // NAVER
        oAuthType = @"NAVER";
        accessToken = self.thirdPartyLoginConn.accessToken;
    }

    return [NSArray arrayWithObjects:oAuthType, accessToken, nil];
}

#pragma mark- NAVER
// 로그인 실행
- (void) requestThirdpartyLogin {
    [[IndicatorView sharedInstnace] show];
    [self.thirdPartyLoginConn requestThirdPartyLogin];
}

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
          if(self.delegate != nil && [self.delegate respondsToSelector:@selector(getOAuthManagerUserData:)]){
              [self.delegate getOAuthManagerUserData:responseStr];
          }
          NSLog(@"Data received: %@", responseStr);
      }] resume];
}



#pragma mark- NAVER OAuth20 deleagate
// 로그인 성공
- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    NSString *result = [NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", self.thirdPartyLoginConn.accessToken, self.thirdPartyLoginConn.accessTokenExpireDate, self.thirdPartyLoginConn.refreshToken];
    
    /**
     로그인 성공 및 실패 여부 노티 알림 (로딩 화면 생성)
     **/
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OAuthLoginSuccess" object:nil];
    [[IndicatorView sharedInstnace]dismiss];
    NSLog(@"\nOAuth Login === NAVER \n%@",result);
}

// 로그인 실패
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error{
    NSLog(@"\nOAuth Login === NAVER \n%@",error);
    [[IndicatorView sharedInstnace]dismiss];
}

// 인앱 로그인 // 실행여부 미확인
- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request{
//    NLoginThirdPartyOAuth20InAppBrowserViewController *inappAuthBrowser = [[NLoginThirdPartyOAuth20InAppBrowserViewController alloc]initWithRequest:request];
//    [self.navigationController pushViewController:inappAuthBrowser animated:YES];
}

// 토큰 갱신
- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken{
    NSString *result = [NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ];
    NSLog(@"\nOAuth Login === NAVER \n%@",result);
}

// 인증해제
- (void)oauth20ConnectionDidFinishDeleteToken{
    NSLog(@"\nOAuth Login === NAVER \n%@",@"네이버 토큰 인증해제 완료");
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFinishAuthorizationWithResult:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType
{
    NSLog(@"Getting auth code from NaverApp success!");
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailAuthorizationWithRecieveType:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType
{
    NSLog(@"NaverApp login fail handler");
}

@end
