#import <Foundation/Foundation.h>
#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import "OAuthBase.h"

@interface OAuthNaver : OAuthBase<NaverThirdPartyLoginConnectionDelegate>
@property (strong, nonatomic) NaverThirdPartyLoginConnection *thirdPartyLoginConn;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@end

