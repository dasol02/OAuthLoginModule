#import "OAuthGoogle.h"

@implementation OAuthGoogle

+ (OAuthGoogle *)sharedInstnace{
    static OAuthGoogle *oAuthGoogle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthGoogle = [[OAuthGoogle alloc] init];
    });
    
    return oAuthGoogle;
}


- (instancetype)init{
    self = [super init];
    
    appFirstState = YES; // 최초 실행여부
    [GIDSignIn sharedInstance].clientID = OAuth_Google_ClientID;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
   
    return self;
}

- (void)signInSilently{
    [[GIDSignIn sharedInstance] signInSilently]; // 이전 로그인 여부 확
}


- (BOOL)getLoginState{
     if([GIDSignIn sharedInstance].currentUser.authentication == nil){
         return NO;
     }else{
         return YES;
     }
}


- (void)oAuthGoogleUserData{
    if([GIDSignIn sharedInstance].currentUser != nil){
        
        
        NSString *targetUrl = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@",[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"basic_attribution", @"scenario_type",
                             nil];
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [request setHTTPBody:postData];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                                       NSURLResponse * _Nullable response,NSError * _Nullable error) {
            
            NSString *userID = [NSString stringWithFormat:@"사용자 아이디: %@",[[[GIDSignIn sharedInstance] currentUser] userID]];
            NSString *userEmail = [NSString stringWithFormat:@"사용자 이메일: %@",[[[[GIDSignIn sharedInstance] currentUser] profile] email]];
            NSString *userName = [NSString stringWithFormat:@"사용자 이름: %@", [[[[GIDSignIn sharedInstance] currentUser] profile] name]];
            NSString *userGender = @"";
            
            
            if(error){
#if defined(OAuth_LOG_GOOGLE)
                NSLog(@"\nOAuth GOOGLE oAuthvGOOGLEUserData ERROR");
#endif
            }else{
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
#if defined(OAuth_LOG_GOOGLE)
                NSLog(@"Data received: %@", responseStr);
#endif
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                userGender = [dict objectForKey:@"gender"];
                userGender = [NSString stringWithFormat:@"사용자 성별: %@", userGender];
            }
            
            NSString *responseStr = [NSString stringWithFormat:@"\nGoogle\n\n%@\n%@\n%@\n%@\n\n아이디 토큰 : \n%@\n\n악세스 토큰 : \n%@\n\n리플레시 토큰 :\n%@",userID,userEmail,userName,userGender,self.userIDToken,self.accessToken,self.refreshToken];
#if defined(OAuth_LOG_GOOGLE)
            NSLog(@"\nOAuth GOOGLE oAuthvGOOGLEUserData SUCCES");
            NSLog(@"\n\n==========GOOGLE  LOGIN SUCCESS==========\n%@\n====================\n\n", responseStr);
#endif
            if(!error){
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseOAuthManagerUserData:)]){
                    [self.delegate oAuthResponseOAuthManagerUserData:responseStr];
                }
            }else{
                 [self googleResponseError:error Type:googleError_UserData];
            }
        }] resume];
    }else{
        [self googleResponseError:nil Type:googleError_UserData];
    }
}


- (void)oAuthGoogleLogin{
    [[GIDSignIn sharedInstance] signIn];
}



- (void)oAuthGoogleLogout{
    [[GIDSignIn sharedInstance] signOut];
    if([GIDSignIn sharedInstance].currentUser != nil){
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
            [self.delegate oAuthResponseLogoutResult:YES OAuthName:oAuthName_Google];
        }
#if defined(OAuth_LOG_GOOGLE)
        NSLog(@"\nOAuth Google oAuthGoogleLogout SUCCES");
#endif
    }else{
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
            [self.delegate oAuthResponseLogoutResult:NO OAuthName:oAuthName_Google];
        }
    }
}



#pragma mark- DELEGATE
- (void)googleResponseError:(NSError*)error Type:(int)type{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseErorr:OAuthName:)]){
        [self.delegate oAuthResponseErorr:error OAuthName:oAuthName_Google];
    }
    
#if defined(OAuth_LOG_GOOGLE)
    NSString *strType;
    switch (type) {
        case googleError_Login:
            strType = @"LOGIN";
            break;
        case googleError_Logout:
            strType = @"Logout";
            break;
        case googleError_UserData:
            strType = @"UserData";
            break;
        default:
            strType = @"Default";
            break;
    }
    NSLog(@"\nOAuth GOOGLE Response Error %@",strType);
#endif
}

- (BOOL)oAuthCheckOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


# pragma mark- Google Deledate
/**
 * Login
 */
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    // 앱 최초 실행 여부
    if(appFirstState){
        
        appFirstState = NO;
        if(error){
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseGoogleAppFirstStart:)]){
                [self.delegate responseGoogleAppFirstStart:NO];
            }
        }else{
            self.userIDToken = [GIDSignIn sharedInstance].currentUser.authentication.idToken;
            self.accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
            self.refreshToken = [GIDSignIn sharedInstance].currentUser.authentication.refreshToken;
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseGoogleAppFirstStart:)]){
                [self.delegate responseGoogleAppFirstStart:YES];
            }
        }
    
    }else{
        
        if(error){
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLoginResult:OAuthName:)]){
                [self.delegate oAuthResponseLoginResult:NO OAuthName:googleError_Login];
            }
            
        }else{
            self.userIDToken = [GIDSignIn sharedInstance].currentUser.authentication.idToken;
            self.accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
            self.refreshToken = [GIDSignIn sharedInstance].currentUser.authentication.refreshToken;
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLoginResult:OAuthName:)]){
                [self.delegate oAuthResponseLoginResult:YES OAuthName:googleError_Login];
            }
    }
#if defined(OAuth_LOG_GOOGLE)
        NSLog(@"\nOAuth Google oAuthGoogleLogin SUCCES");
#endif
    }
}


# pragma mark- Google UI Deledate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
}

@end



