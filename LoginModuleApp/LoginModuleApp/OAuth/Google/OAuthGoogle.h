#import <Foundation/Foundation.h>
#import "OAuthBase.h"

@import GoogleSignIn;

@interface OAuthGoogle : OAuthBase
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userIDToken;
    
@end

