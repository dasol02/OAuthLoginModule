#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "OAuthBase.h"
typedef NS_ENUM(int,facebook_Error){
    facebookError_Login,
    facebookError_Logout,
    facebookError_UserData,
    facebookError_RefreshToken
};

@interface OAuthFacebook : OAuthBase
@property (strong, nonatomic) FBSDKLoginManager *fbManager;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *userID;

@end
