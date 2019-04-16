#import "OAuthFacebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface OAuthFacebook()
@property (strong, nonatomic) FBSDKLoginManager *fbManager;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *userID;
@end


@implementation OAuthFacebook

- (instancetype)init{
    self = [super init];
    
    self.fbManager = [[FBSDKLoginManager alloc]init];
    
    if ([FBSDKAccessToken currentAccessToken]){
        self.accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
        self.userID = [FBSDKAccessToken currentAccessToken].userID;
    }
    
    return self;
}

#pragma mark - SDK Setting
-(void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)requestDidOAuth{
    [FBSDKAppEvents activateApp];
}

#pragma mark - Request

- (BOOL)requestOAuthIsLogin{
    if ([FBSDKAccessToken currentAccessToken]){
         return YES;
    }else{
         return NO;
    }
}

-(void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
    if (![FBSDKAccessToken currentAccessToken]){
        [self.fbManager logInWithReadPermissions:@[@"email"]
                              fromViewController:nil
                                         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                             if(error || [result isCancelled]){
                                                 responseOAuthResult(NO);
                                             }else{
                                                 self.accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                                 self.userID = [FBSDKAccessToken currentAccessToken].userID;
                                                 responseOAuthResult(YES);
                                             }
                                         }];
    }else{
        responseOAuthResult(NO);
    }
}

- (void)requestOAuthLogout:(responseOAuthResult)responseOAuthResult{
    [self requestFacebookRemove] ? responseOAuthResult(YES) : responseOAuthResult(NO);
}

- (void)requestOAuthRemove:(responseOAuthResult)responseOAuthResult{
     [self requestFacebookRemove] ? responseOAuthResult(YES) : responseOAuthResult(NO);
}

- (void)requestOAuthGetToken:(responseToken)responseToken{
    self.requestOAuthIsLogin ? responseToken(YES, self.accessToken) : responseToken(NO, @"");
}


- (void)requsetOAuthRefreshToken:(responseOAuthResult)responseOAuthResult{
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKAccessTokenChangeNewKey
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:
     ^(NSNotification *notification) {
         if (notification.userInfo[FBSDKAccessTokenChangeNewKey]) {
             responseOAuthResult(YES);
         }else{
             responseOAuthResult(NO);
         }
     }];
}

- (void)requestOAuthGetUserData:(responseUserData)responseUserData{
     struct OAuthUserInfo userInfo;
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"name,email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            struct OAuthUserInfo userInfo;
             
             if (!error) {
                 userInfo.userName = result[@"name"];
                 userInfo.userID = [FBSDKAccessToken currentAccessToken].userID;
                 userInfo.userEmail = result[@"email"];
                 userInfo.userAccessToken = self.accessToken;
                 userInfo.userTokenRefreshDate = [NSString stringWithFormat:@"%@",[FBSDKAccessToken currentAccessToken].refreshDate];
                 responseUserData(YES,userInfo);
             }else{
                 userInfo.userName = @"";
                 responseUserData(NO,userInfo);
             }
         }];
    }else{
        userInfo.userName = @"";
        responseUserData(NO,userInfo);
    }
}

- (BOOL)requestOAuthNativeOpenURL:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


#pragma mark - privite
- (BOOL)requestFacebookRemove{
    [self.fbManager logOut];
    if ([self requestOAuthIsLogin] == YES){
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)dateFormat:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end
