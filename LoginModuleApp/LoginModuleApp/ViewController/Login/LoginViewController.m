#import "LoginViewController.h"
#import "UserProfileViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionNaverLogin:(id)sender {
    [[OAuthManager sharedInstnace] requestThirdpartyLogin];
}

- (IBAction)actionKakaoLogin:(id)sender {
}

- (IBAction)actionFacebookLogin:(id)sender {
}

- (IBAction)actionGoogleLogin:(id)sender {
}

@end
