#import "OAuthFacebook.h"

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


- (NSString *)dateFormat:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

#pragma makr- SDK Setting
-(void)requestStartOAuth:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)requestDidOAuth{
//    [FBSDKAppEvents activateApp];
}

#pragma mark - request


- (BOOL)requestOAuthIsLogin{
    if ([FBSDKAccessToken currentAccessToken]){
         return YES;
    }else{
         return NO;
    }
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
//                 [self facebookResponseError:error Type:facebookError_UserData];
                 responseUserData(NO,@"");
             }
         }];
    }else{
//         [self facebookResponseError:nil Type:facebookError_UserData];
        responseUserData(NO,@"");
    }
}

-(void)requestOAuthLogin:(responseOAuthResult)responseOAuthResult{
    if (![FBSDKAccessToken currentAccessToken]){
        NSLog(@"\nFACE BOOK TRY LOGIN SUCCESS");
        [self.fbManager logInWithReadPermissions:@[@"email"]
                              fromViewController:nil
                                         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                             if(error){
//                                                 [self facebookResponseError:error Type:facebookError_Login];
                                                 responseOAuthResult(NO);
                                             }else if([result isCancelled]){
//                                                 [self facebookResponseError:error Type:facebookError_Login];
                                                 responseOAuthResult(NO);
                                             }else{
                                                 // User Data
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
    [self.fbManager logOut];
    if ([FBSDKAccessToken currentAccessToken]){
        responseOAuthResult(NO);
    }else{
        responseOAuthResult(YES);
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
//             [self facebookResponseError:nil Type:facebookError_RefreshToken];
             responseOAuthResult(NO);
         }
     }];
}



#pragma mark- DELEGATE
- (void)facebookResponseError:(NSError*)error Type:(int)type{

}


@end
