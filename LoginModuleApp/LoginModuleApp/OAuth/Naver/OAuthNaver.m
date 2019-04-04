#import "OAuthNaver.h"

@implementation OAuthNaver

-(instancetype)init{
    self = [super init];
    
    self.thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
    self.thirdPartyLoginConn.delegate = self;
    [self setOAuthNaverSetting];
    self.accessToken = self.thirdPartyLoginConn.accessToken;
    self.refreshToken = self.thirdPartyLoginConn.refreshToken;
    
    return self;
}


#pragma mark - OAuth NAVER First Setting
- (void)setOAuthNaverSetting{
    [self.thirdPartyLoginConn setIsNaverAppOauthEnable:YES];
    [self.thirdPartyLoginConn setServiceUrlScheme:OAuth_Naver_ServiceAppUrlScheme];
    [self.thirdPartyLoginConn setConsumerKey:OAuth_Naver_ConsumerKey];
    [self.thirdPartyLoginConn setConsumerSecret:OAuth_Naver_ConsumerSecret];
    [self.thirdPartyLoginConn setAppName:OAuth_Naver_ServiceAppName];
}

#pragma mark - REQUEST OAuth
- (BOOL)requestOAuthIsLogin{
    
    NSString * accessToken;
    
    if([self.thirdPartyLoginConn state]){
        accessToken = self.thirdPartyLoginConn.accessToken;
    }

    if(accessToken == nil || accessToken.length <= 0 || [accessToken isKindOfClass:[NSNull class]]){
        return NO;
    }

    return YES;
}

- (void)requestOAuthGetUserData:(responseUserData)responseUserData{
    
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
          
          if(!error){
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
              NSDictionary *userData = [dict objectForKey:@"response"];
              
              NSString *userAge = [userData objectForKey:@"name"];
              NSString *userBirthday = [userData objectForKey:@"birthday"];
              NSString *userEmail = [userData objectForKey:@"email"];
              NSString *userGender = [userData objectForKey:@"gender"];
              NSString *userID = [userData objectForKey:@"id"];
              NSString *userName = [userData objectForKey:@"name"];
              
              NSString *responseStr = [NSString stringWithFormat:@"\nNaver\n\n연령대 : %@\n생일 : %@\n이메일 : %@\n성별 : %@\n아이디 : %@\n이름 : %@\n\n토큰 : %@\n\n리플레시토큰 : %@",userAge,userBirthday,userEmail,userGender,userID,userName,self.accessToken,self.refreshToken];
              
              responseUserData(YES,responseStr);
          }else{
              responseUserData(NO,@"");
          }
          
      }] resume];
}

- (void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
//     [self.thirdPartyLoginConn requestThirdPartyLogin];
    responseOAuthResult((BOOL*)YES);
}

- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [self.thirdPartyLoginConn resetToken];
    
    // 임시 추후 동기로 변경
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(logOutResult) userInfo:nil repeats:NO];
    
    responseOAuthResult(YES);
}

- (void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult{
    [self.thirdPartyLoginConn requestDeleteToken];
    
    // 임시 추후 동기로 변경
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(logOutResult) userInfo:nil repeats:NO];
}


- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
     return [self.thirdPartyLoginConn application:app openURL:url options:options];
}


# pragma mark - Privite
    
- (void)logOutResult{
    
    BOOL state = NO;
    
    if([self requestOAuthIsLogin]){
        state = YES;
    }
    
}
    
- (void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult{
    // 전급 토근은 있고 &&  유효기간이 지난 경우
    if([self.thirdPartyLoginConn state] && [self.thirdPartyLoginConn isValidAccessTokenExpireTimeNow] == NO){
        [self.thirdPartyLoginConn requestAccessTokenWithRefreshToken];

    }else{

    }
}

#pragma mark- NAVER OAuth20 deleagate
// 로그인 성공
- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {

    
    self.accessToken = self.thirdPartyLoginConn.accessToken;
    self.refreshToken = self.thirdPartyLoginConn.refreshToken;
    
}

// 로그인 실패
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error{

}

// 인증해제
- (void)oauth20ConnectionDidFinishDeleteToken{

}

// 토큰 갱신
- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken{
    self.accessToken = self.thirdPartyLoginConn.accessToken;
    self.refreshToken = self.thirdPartyLoginConn.refreshToken;


}

// 인앱 로그인 // 실행여부 미확인
- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request{


}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFinishAuthorizationWithResult:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType{

}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailAuthorizationWithRecieveType:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType{

}


@end
