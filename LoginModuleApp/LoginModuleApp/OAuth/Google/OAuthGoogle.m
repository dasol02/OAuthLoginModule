#import "OAuthGoogle.h"

@implementation OAuthGoogle

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


#pragma mark- request
- (BOOL)requestOAuthIsLogin{
     if([GIDSignIn sharedInstance].currentUser.authentication == nil){
         return NO;
     }else{
         return YES;
     }
}


- (void)requestOAuthGetUserData:(responseUserData)responseUserData{
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
            }else{
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                userGender = [dict objectForKey:@"gender"];
                userGender = [NSString stringWithFormat:@"사용자 성별: %@", userGender];
                NSLog(@"%@",responseStr);
            }
            
            NSString *responseStr = [NSString stringWithFormat:@"\nGoogle\n\n%@\n%@\n%@\n%@\n\n아이디 토큰 : \n%@\n\n악세스 토큰 : \n%@\n\n리플레시 토큰 :\n%@",userID,userEmail,userName,userGender,self.userIDToken,self.accessToken,self.refreshToken];
            
            if(!error){
                responseUserData(YES,responseStr);
            }else{
                responseUserData(NO,@"");
//                 [self googleResponseError:error Type:googleError_UserData];
            }
        }] resume];
    }else{
        responseUserData(NO,@"");
    }
}


- (void)requestOAuthLogin{
    [[GIDSignIn sharedInstance] signIn];
}



- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [[GIDSignIn sharedInstance] signOut];
    if([GIDSignIn sharedInstance].currentUser != nil){
        responseOAuthResult(NO);
    }else{
        responseOAuthResult(YES);
    }
}


- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

#pragma mark- DELEGATE
- (void)googleResponseError:(NSError*)error Type:(int)type{

    
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

        }else{
            self.userIDToken = [GIDSignIn sharedInstance].currentUser.authentication.idToken;
            self.accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
            self.refreshToken = [GIDSignIn sharedInstance].currentUser.authentication.refreshToken;

        }
    
    }else{
        
        if(error){
            
        }else{
            self.userIDToken = [GIDSignIn sharedInstance].currentUser.authentication.idToken;
            self.accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
            self.refreshToken = [GIDSignIn sharedInstance].currentUser.authentication.refreshToken;
    }

    }
}


# pragma mark- Google UI Deledate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}


- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    
}


- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
}

@end



