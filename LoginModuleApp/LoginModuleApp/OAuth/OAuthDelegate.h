#ifndef OAuthDelegate_h
#define OAuthDelegate_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol OAuthDelegate<NSObject>
@optional
- (void)oAuthDelegateLoginResult:(BOOL)state OAuthName:(int)oAuthName;
- (void)oAuthDelegateSuccess:(int)oAuthName;
- (void)oAuthDelegateErorr:(NSError *)error OAuthName:(int)oAuthName;
- (void)oAuthDelegateOAuthManagerUserData:(NSString *)userData;
@end


#endif /* OAuthDelegate_h */
