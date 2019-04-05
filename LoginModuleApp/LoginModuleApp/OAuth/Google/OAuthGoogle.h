#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "OAuthBase.h"

@import GoogleSignIn;

@interface OAuthGoogle : OAuthBase <GIDSignInDelegate,GIDSignInUIDelegate>
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userIDToken;
    
@end

