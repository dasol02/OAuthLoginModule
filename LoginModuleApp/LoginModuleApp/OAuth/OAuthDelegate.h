#ifndef OAuthDelegate_h
#define OAuthDelegate_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol OAuthDelegate<NSObject>
@optional
- (void)oAuthResponseLoginResult:(BOOL)state OAuthName:(int)oAuthName; // 로그인 시도 결과
- (void)oAuthResponseSuccess:(int)oAuthName;                           // 통신 성공 여부
- (void)oAuthResponseErorr:(NSError *)error OAuthName:(int)oAuthName;  // 통신 실패 여부
- (void)oAuthResponseOAuthManagerUserData:(NSString *)userData;        // 사용자 데이터 전송 여부
@end

#endif /* OAuthDelegate_h */
