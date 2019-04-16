#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Privite

- (void)responseOAuthResult:(BOOL)state{
    if(state){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"responseOAuthResult FAIL");
    }
}

- (void)trySNSLogin:(OAUTH_TYPE)snsType{
    [[OAuthManager sharedInstnace] requestOAuthManagerLogin:snsType handler:^(bool result) {
        [self responseOAuthResult:result];
    }];
}


# pragma mark - Action

- (IBAction)actionNaverLogin:(id)sender {
    [self trySNSLogin:(OAUTH_TYPE)OAUTH_TYPE_NAVER];
}

- (IBAction)actionKakaoLogin:(id)sender {
    [self trySNSLogin:(OAUTH_TYPE)OAUTH_TYPE_KAKAO];
}

- (IBAction)actionFacebookLogin:(id)sender {
    [self trySNSLogin:(OAUTH_TYPE)OAUTH_TYPE_FACEBOOK];
}

- (IBAction)actionGoogleLogin:(id)sender {
    [self trySNSLogin:(OAUTH_TYPE)OAUTH_TYPE_GOOGLE];
}

@end
