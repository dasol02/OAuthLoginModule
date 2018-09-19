#import <UIKit/UIKit.h>
#import "OAuthManager.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonUserLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonUserProfile;


- (IBAction)actionRequestUserLogin:(id)sender;
- (IBAction)actionUserProfile:(id)sender;

@end
