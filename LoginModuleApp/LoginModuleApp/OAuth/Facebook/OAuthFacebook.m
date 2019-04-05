#import "OAuthFacebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface OAuthFacebook()
@property (strong, nonatomic) FBSDKLoginManager *fbManager;
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

#pragma mark - request

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

- (void)requestOAuthGetUserData:(responseUserData)responseUserData{
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"name,email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *strTOKEN_Token = [FBSDKAccessToken currentAccessToken].tokenString;
                 NSString *strTOKEN_UserID = [FBSDKAccessToken currentAccessToken].userID;
                 NSDate *dateTOKEN_refreshDate = [FBSDKAccessToken currentAccessToken].refreshDate;
                 NSString *userName = result[@"name"];
                 NSString *userEmail = result[@"email"];
                 
                 NSString *strUserData = [NSString stringWithFormat:@"\nFacebook\n\nRefreshDate = %@\nUserID = %@\nUserName = %@\nUserEmail = %@\n\nTOKEN = \n%@",[self dateFormat:dateTOKEN_refreshDate],strTOKEN_UserID,userName,userEmail,strTOKEN_Token];
                 responseUserData(YES,strUserData);
             }else{
                 responseUserData(NO,@"");
             }
         }];
    }else{
        responseUserData(NO,@"");
    }
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
