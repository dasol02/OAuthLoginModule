#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OAuth/OAuthManager.h"


#import <GoogleSignIn/GoogleSignIn.h>
@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

