#import <UIKit/UIKit.h>
#import "OAuthManager.h"
#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "IndicatorView.h"

@interface MainViewController : UIViewController<OAuthManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonUserLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonUserProfile;

- (IBAction)actionRequestUserLogin:(id)sender;
- (IBAction)actionUserProfile:(id)sender;

@end
