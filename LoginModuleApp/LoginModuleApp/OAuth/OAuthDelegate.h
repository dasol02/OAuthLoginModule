#ifndef OAuthDelegate_h
#define OAuthDelegate_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol OAuthDelegate<NSObject>
@optional
- (void)oAuthDelegateLoginResult:(BOOL)state OAuthName:(int)oAuthName; // 로그인 시도 결과
- (void)oAuthDelegateSuccess:(int)oAuthName;                           // 통신 성공 여부
- (void)oAuthDelegateErorr:(NSError *)error OAuthName:(int)oAuthName;  // 통신 실패 여부
- (void)oAuthDelegateOAuthManagerUserData:(NSString *)userData;        // 사용자 데이터 전송 여부
@end


#endif /* OAuthDelegate_h */
