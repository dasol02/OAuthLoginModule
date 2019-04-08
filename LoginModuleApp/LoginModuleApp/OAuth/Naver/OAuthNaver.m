#import "OAuthNaver.h"
#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>

@interface OAuthNaver()<NaverThirdPartyLoginConnectionDelegate>
@property (strong, nonatomic) NaverThirdPartyLoginConnection *thirdPartyLoginConn;
@property (strong, nonatomic) responseOAuthResult naverOAuthResponseOAuthResult;
@end

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

#pragma mark - SDK Setting
-(void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}


-(void)requestDidOAuth{}

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


- (void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
    [self.thirdPartyLoginConn requestThirdPartyLogin];
    self.naverOAuthResponseOAuthResult = responseOAuthResult;
}

- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [self.thirdPartyLoginConn resetToken];
    
    if([self requestOAuthIsLogin] == NO){
        responseOAuthResult(YES);
    }
    responseOAuthResult(NO);
    
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


- (void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult{
    [self.thirdPartyLoginConn requestDeleteToken];
    self.naverOAuthResponseOAuthResult = responseOAuthResult;
}


- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
     return [self.thirdPartyLoginConn application:app openURL:url options:options];
}

- (void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult{
    // 전급 토근은 있고 &&  유효기간이 지난 경우
    if([self.thirdPartyLoginConn state] && [self.thirdPartyLoginConn isValidAccessTokenExpireTimeNow] == NO){
        [self.thirdPartyLoginConn requestAccessTokenWithRefreshToken];
        responseOAuthResult(YES);
    }else{
        responseOAuthResult(NO);
    }
}

#pragma mark- NAVER OAuth20 deleagate
// 로그인 성공
- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    self.accessToken = self.thirdPartyLoginConn.accessToken;
    self.refreshToken = self.thirdPartyLoginConn.refreshToken;
    self.naverOAuthResponseOAuthResult(YES);
    self.naverOAuthResponseOAuthResult = nil;
}

// 로그인 및 인증해제 실패
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error{
    self.naverOAuthResponseOAuthResult(NO);
    self.naverOAuthResponseOAuthResult = nil;
}

// 인증해제 (성공)
// # 인증해제 실패시 (인증해제 실패시 앱내의 저장된 토큰은 삭제되어 따로 처리 하지 않음.)
- (void)oauth20ConnectionDidFinishDeleteToken{
    self.naverOAuthResponseOAuthResult(YES);
    self.naverOAuthResponseOAuthResult = nil;
}


// 토큰 갱신 (성공)
- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken{
    self.accessToken = self.thirdPartyLoginConn.accessToken;
    self.refreshToken = self.thirdPartyLoginConn.refreshToken;
}


// 인앱 로그인 내부 브라우저 생성
- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request{}
// Getting auth code from NaverApp faile
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFinishAuthorizationWithResult:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType{}
// Getting auth code from NaverApp success
- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailAuthorizationWithRecieveType:(THIRDPARTYLOGIN_RECEIVE_TYPE)recieveType{}


@end
