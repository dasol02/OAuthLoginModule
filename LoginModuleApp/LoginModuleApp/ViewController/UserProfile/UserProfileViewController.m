#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textFieldUserData;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[OAuthManager sharedInstnace] requestOAuthManagerGetUserData:^(bool result, NSString *userData) {
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textFieldUserData setText:userData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogout:(id)sender {
    [[OAuthManager sharedInstnace] requestOAuthManagerLogout:^(bool result){
        [self responseLogoutResult:result];
    }];
}

- (IBAction)actionOAuthDelete:(id)sender {
    [[OAuthManager sharedInstnace] requestOAuthManagerRemove:^(bool result) {
        [self responseLogoutResult:result];
    }];
}

- (void)responseLogoutResult:(BOOL)state{
     [self.navigationController popViewControllerAnimated:state];
}
@end
