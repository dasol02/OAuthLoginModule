#ifndef OAuthDelegate_h
#define OAuthDelegate_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(int,oAuthName){
    oAuthName_Default,
    oAuthName_Naver,
    oAuthName_Kakao,
    oAuthName_Facebook,
    oAuthName_Google
};

@protocol OAuthDelegate<NSObject>
@optional
- (void)oAuthResponseLoginResult:(BOOL)state OAuthName:(int)oAuthName; // 로그인 시도 결과
- (void)oAuthResponseLogoutResult:(BOOL)state OAuthName:(int)oAuthName; // 로그아웃 결과
- (void)oAuthResponseSuccess:(int)oAuthName;                           // 통신 성공 여부
- (void)oAuthResponseErorr:(NSError *)error OAuthName:(int)oAuthName;  // 통신 실패 여부
- (void)oAuthResponseOAuthManagerUserData:(NSString *)userData;        // 사용자 데이터 전송 여부
- (void)responseGoogleAppFirstStart:(BOOL)state; // 사용자 로그인 정보 확인
@end

#endif /* OAuthDelegate_h */
