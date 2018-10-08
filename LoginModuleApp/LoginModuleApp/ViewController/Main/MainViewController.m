#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpdateButtonUI]; // 로그인 유저 프로필 화면 갱신
}

- (void)responseAppFirstStart:(BOOL)state{
    [self setUpdateButtonUI]; // 로그인 유저 프로필 화면 갱신
}


#pragma mark -
// 로그인, 유저프로필 버튼 UI변경
- (void)setUpdateButtonUI{
    if([[OAuthManager sharedInstnace] oAuthManagerLoginState] == YES){
        self.buttonUserLogin.hidden = YES;
        self.buttonUserProfile.hidden = NO;
    }else{
        self.buttonUserLogin.hidden = NO;
        self.buttonUserProfile.hidden = YES;
    }
}


#pragma mark -

- (void)pushLoginPage{
    UIStoryboard *getStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *view = [getStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:view animated:YES];
}


- (void)pushUserProfile{
    UIStoryboard *getStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController *view = [getStoryboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark -


// 로그인, 유저 프로필 버튼
- (IBAction)actionRequestUserLogin:(id)sender {
    [self pushLoginPage];
}

- (IBAction)actionUserProfile:(id)sender {
    [self pushUserProfile];
}

@end
