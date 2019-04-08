#import <Foundation/Foundation.h>
#import "OAuthBase.h"

@interface OAuthNaver : OAuthBase
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@end

