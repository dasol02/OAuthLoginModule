#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
}

- (void)responseLoginResult:(BOOL)state{
    if(state){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"ResponseLoginResult FAIL");
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
    [[OAuthManager sharedInstnace] oAuthManagerLogin:oAuthName_Naver];
}

- (IBAction)actionKakaoLogin:(id)sender {
    
}

- (IBAction)actionFacebookLogin:(id)sender {
}

- (IBAction)actionGoogleLogin:(id)sender {
}

@end
