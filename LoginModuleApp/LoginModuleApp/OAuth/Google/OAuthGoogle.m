#import "OAuthGoogle.h"
#import "OAuthManager.h"
#import <GoogleSignIn/GoogleSignIn.h>


@import GoogleSignIn;

@interface OAuthGoogle()<GIDSignInDelegate,GIDSignInUIDelegate>
@property (strong, nonatomic) responseOAuthResult googleOAuthResponseOAuthResult;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userIDToken;
@end

@implementation OAuthGoogle

- (instancetype)init{
    self = [super init];
    [GIDSignIn sharedInstance].clientID = [self getClientInfo:@"GOOGLE_CLIENT_ID"];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    return self;
}

#pragma mark - SDK Setting
-(void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}

-(void)requestDidOAuth{}


#pragma mark- Request
- (BOOL)requestOAuthIsLogin{
     if([GIDSignIn sharedInstance].currentUser.authentication == nil){
         return NO;
     }else{
         return YES;
     }
}

- (void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
    self.googleOAuthResponseOAuthResult = responseOAuthResult;
    [[GIDSignIn sharedInstance] signIn];
}


- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [self requestGoogleRemove] ? responseOAuthResult(YES) : responseOAuthResult(NO);
}

- (void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult{
    [self requestGoogleRemove] ? responseOAuthResult(YES) : responseOAuthResult(NO);
}

- (void)requestOAuthGetToken:(responseToken)responseToken{
    self.requestOAuthIsLogin ? responseToken(YES, self.accessToken) : responseToken(NO, @"");
}

- (void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult{
    responseOAuthResult(YES);
}

- (void)requestOAuthGetUserData:(responseUserData)responseUserData{
   
    
    if([GIDSignIn sharedInstance].currentUser != nil){
        
        NSString *targetUrl = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@",[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: @"basic_attribution", @"scenario_type", nil];
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [request setHTTPBody:postData];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                                       NSURLResponse * _Nullable response,NSError * _Nullable error) {
            struct OAuthUserInfo userInfo;
        
            if(error){ userInfo.userName = @""; responseUserData(NO,userInfo); return; }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            userInfo.userName = [[[[GIDSignIn sharedInstance] currentUser] profile] name];
            userInfo.userID = [[[GIDSignIn sharedInstance] currentUser] userID];
            userInfo.userEmail = [[[[GIDSignIn sharedInstance] currentUser] profile] email];
            userInfo.userGender = [dict objectForKey:@"gender"];
            userInfo.userAccessToken = self.accessToken;
            userInfo.userRefreshToken = self.refreshToken;
        
            responseUserData(YES,userInfo);
            
        }] resume];
    }else{
        struct OAuthUserInfo userInfo;
        userInfo.userName = @"";
        responseUserData(NO,userInfo);
    }
}

- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


#pragma mark - Privite
- (BOOL)requestGoogleRemove{
    [[GIDSignIn sharedInstance] signOut];
    if([GIDSignIn sharedInstance].currentUser == nil){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Google Deledate
/**
 * Login
 */
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if(error){
        self.googleOAuthResponseOAuthResult(NO);
    }else{
        self.userIDToken = [GIDSignIn sharedInstance].currentUser.authentication.idToken;
        self.accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
        self.refreshToken = [GIDSignIn sharedInstance].currentUser.authentication.refreshToken;
        self.googleOAuthResponseOAuthResult(YES);
    }
    self.googleOAuthResponseOAuthResult = nil;
}



/**
 * Safari WebView Login
 * iOS 9 이하 버전의 Native App 미설치의 경우
 **/
# pragma mark- Google UI Deledate
// Google optional API
// iOS 9 이상 호출
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// iOS 9 이하 호출
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topViewController.presentedViewController){
        topViewController = topViewController.presentedViewController;
    }
    [topViewController presentViewController:viewController animated:YES completion:nil];
}

// iOS 9 이하 호출
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
        [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end



