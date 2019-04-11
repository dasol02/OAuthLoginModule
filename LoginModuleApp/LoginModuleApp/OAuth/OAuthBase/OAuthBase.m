#import "OAuthBase.h"

@implementation OAuthBase

- (NSString *)getClientInfo:(NSString *)OAuthDataKey{
    if (OAuthDataKey.length <= 0) { return nil ;}
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:OAuthDataKey];
}

@end
