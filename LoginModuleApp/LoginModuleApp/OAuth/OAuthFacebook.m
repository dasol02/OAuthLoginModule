#import "OAuthFacebook.h"

@implementation OAuthFacebook

+ (OAuthFacebook *)sharedInstnace{
    static OAuthFacebook *oAuthFacebook = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oAuthFacebook = [[OAuthFacebook alloc] init];
    });
    
    return oAuthFacebook;
}


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


- (BOOL)getLoginState{
    if ([FBSDKAccessToken currentAccessToken]){
         return YES;
    }else{
         return NO;
    }
}


- (void)oAuthFacebookUserData{
    
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
                 
#if defined(OAuth_LOG_FACEBOOK)
                 NSLog(@"\nOAuth Facebook oAuthFacebookUserData SUCCES");
                 NSLog(@"\n\n==========Facebook  LOGIN SUCCESS==========\n%@\n====================\n\n", strUserData);
#endif
                 if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseOAuthManagerUserData:)]){
                     [self.delegate oAuthResponseOAuthManagerUserData:strUserData];
                 }
             }else{
                 [self facebookResponseError:error Type:facebookError_UserData];
             }
         }];
    }else{
         [self facebookResponseError:nil Type:facebookError_UserData];
    }
}

- (void)oAuthFacebookLogin{
    if (![FBSDKAccessToken currentAccessToken]){
        NSLog(@"\nFACE BOOK TRY LOGIN SUCCESS");
        [self.fbManager logInWithReadPermissions:@[@"email"]
                       fromViewController:nil
                                  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                      if(error){
                                        [self facebookResponseError:error Type:facebookError_Login];
                                      }else if([result isCancelled]){
                                        [self facebookResponseError:error Type:facebookError_Login];
                                      }else{
                                          // User Data
                                          self.accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                          self.userID = [FBSDKAccessToken currentAccessToken].userID;
                                          if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLoginResult:OAuthName:)]){
                                              [self.delegate oAuthResponseLoginResult:YES OAuthName:oAuthName_Facebook];
                                          }
#if defined(OAuth_LOG_FACEBOOK)
                                          NSLog(@"\nOAuth Facebook oAuthFacebookLogin SUCCES");
#endif
                                      }
                                  }];
    }else{
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLoginResult:OAuthName:)]){
            [self.delegate oAuthResponseLoginResult:NO OAuthName:oAuthName_Facebook];
        }
    }
}

- (void)oAuthFacebookLogout{
    [self.fbManager logOut];
    if ([FBSDKAccessToken currentAccessToken]){
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
            [self.delegate oAuthResponseLogoutResult:YES OAuthName:oAuthName_Facebook];
        }
#if defined(OAuth_LOG_FACEBOOK)
        NSLog(@"\nOAuth Facebook oAuthFacebookLogout SUCCES");
#endif
    
    }else{
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseLogoutResult:OAuthName:)]){
            [self.delegate oAuthResponseLogoutResult:NO OAuthName:oAuthName_Facebook];
        }
    }
}

- (void)oAuthFacebookRefreshToken{
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKAccessTokenChangeNewKey
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:
     ^(NSNotification *notification) {
         if (notification.userInfo[FBSDKAccessTokenChangeNewKey]) {
#if defined(OAuth_LOG_FACEBOOK)
             NSLog(@"\nOAuth Facebook RefreshToken SUCCES");
#endif
             if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseSuccess:)]){
                 [self.delegate oAuthResponseSuccess:oAuthName_Facebook];
             }
         }else{
             [self facebookResponseError:nil Type:facebookError_RefreshToken];
         }
     }];
}



#pragma mark- DELEGATE
- (void)facebookResponseError:(NSError*)error Type:(int)type{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(oAuthResponseErorr:OAuthName:)]){
        [self.delegate oAuthResponseErorr:error OAuthName:oAuthName_Facebook];
    }
    
#if defined(OAuth_LOG_FACEBOOK)
    NSString *strType;
    switch (type) {
        case facebookError_Login:
            strType = @"LOGIN";
            break;
        case facebookError_Logout:
            strType = @"Logout";
            break;
        case facebookError_UserData:
            strType = @"UserData";
            break;
        case facebookError_RefreshToken:
            strType = @"RefreshToken";
            break;
        default:
            strType = @"Default";
            break;
    }
    NSLog(@"\nOAuth Facebook Response Error %@",strType);
#endif
}


@end
