#import <Foundation/Foundation.h>
#import "OAuthBase.h"

@interface OAuthFacebook : OAuthBase
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *userID;

@end
