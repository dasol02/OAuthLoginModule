#import <Foundation/Foundation.h>
#import "OAuthBase.h"

@interface OAuthKakao : OAuthBase
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@end

