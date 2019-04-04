#import <Foundation/Foundation.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "OAuthBase.h"

typedef NS_ENUM(int,kakaoError){
    kakaoError_Login,
    kakaoError_Logout,
    kakaoError_Delete,
    kakaoError_UserData,
    kakaoError_GetToken
};

@interface OAuthKakao : OAuthBase
    
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@end

