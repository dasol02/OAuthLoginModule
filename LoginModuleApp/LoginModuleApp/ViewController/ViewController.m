#import "ViewController.h"
#import "UserViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
}


-(void)getOAuthManagerLoginState:(BOOL)loginState{
    if(loginState){
        UIStoryboard *getStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserViewController *view = [getStoryboard instantiateViewControllerWithIdentifier:@"UserViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
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
    [[OAuthManager sharedInstnace] oAuthManagerLoginState];
}

- (IBAction)actionFacebookLogin:(id)sender {
}

- (IBAction)actionGoogleLogin:(id)sender {
}
@end
