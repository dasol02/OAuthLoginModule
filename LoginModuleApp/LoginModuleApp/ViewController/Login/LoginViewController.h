#import <UIKit/UIKit.h>
#import "OAuthManager.h"
@interface LoginViewController : UIViewController<OAuthManagerDelegate>

- (IBAction)actionNaverLogin:(id)sender;
- (IBAction)actionKakaoLogin:(id)sender;
- (IBAction)actionFacebookLogin:(id)sender;
- (IBAction)actionGoogleLogin:(id)sender;

@end

