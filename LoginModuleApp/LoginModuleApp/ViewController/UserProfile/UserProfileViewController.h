#import <UIKit/UIKit.h>
#import "OAuthManager.h"

@interface UserProfileViewController : UIViewController<OAuthManagerDelegate>

- (IBAction)actionLogout:(id)sender;
- (IBAction)actionOAuthDelete:(id)sender;

@end
