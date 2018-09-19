#import "LoginViewController.h"
#import "UserProfileViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveOAuthLoginSuccessNotification:)
     name:@"OAuthLoginSuccess"
     object:nil];
}

- (void) receiveOAuthLoginSuccessNotification:(NSNotification *) notification {
    
    if([notification.name isEqualToString:@"OAuthLoginSuccess"]){
        [UIView animateWithDuration:1 animations:^{
                 [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionNaverLogin:(id)sender {
    [[OAuthManager sharedInstnace] oAuthManagerLogin:kAuthLoginName_NAVER];
}

- (IBAction)actionKakaoLogin:(id)sender {
}

- (IBAction)actionFacebookLogin:(id)sender {
}

- (IBAction)actionGoogleLogin:(id)sender {
}

@end
