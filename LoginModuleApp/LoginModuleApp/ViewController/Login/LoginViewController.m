#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)responseOAuthResult:(BOOL)state{
    if(state){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"responseOAuthResult FAIL");
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
    [[OAuthManager sharedInstnace] requestOAuthManagerLogin:(OAUTH_TYPE)OAUTH_TYPE_NAVER handler:^(bool result) {
        [self responseOAuthResult:result];
    }];
}

- (IBAction)actionKakaoLogin:(id)sender {
    [[OAuthManager sharedInstnace] requestOAuthManagerLogin:(OAUTH_TYPE)OAUTH_TYPE_KAKAO handler:^(bool result) {
        [self responseOAuthResult:result];
    }];
}

- (IBAction)actionFacebookLogin:(id)sender {
    [[OAuthManager sharedInstnace] requestOAuthManagerLogin:(OAUTH_TYPE)OAUTH_TYPE_FACEBOOK handler:^(bool result) {
        [self responseOAuthResult:result];
    }];
}

- (IBAction)actionGoogleLogin:(id)sender {
    [[OAuthManager sharedInstnace] requestOAuthManagerLogin:(OAUTH_TYPE)OAUTH_TYPE_GOOGLE handler:^(bool result) {
        [self responseOAuthResult:result];
    }];
}

@end
