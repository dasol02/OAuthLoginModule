#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textFieldUserData;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [[OAuthManager sharedInstnace] requestOAuthManagerGetUserData:^(bool result, OAuthUserInfo userInfo) {
        if (result) {
            
            NSMutableString *userInfoText = [self getUserInfoText:userInfo];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textFieldUserData setText:userInfoText];
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


- (NSMutableString *)getUserInfoText:(OAuthUserInfo)userInfo {
    NSMutableArray *userInfoArray = [[NSMutableArray alloc]init];
    NSMutableString *userInfoText = [[NSMutableString alloc]init];
    
    if (userInfo.userName) { [userInfoArray addObject:[NSString stringWithFormat:@"이름 : %@", userInfo.userName]]; }
    if (userInfo.userID) { [userInfoArray addObject:[NSString stringWithFormat:@"아이디 : %@", userInfo.userID]]; }
    if (userInfo.userGender) { [userInfoArray addObject:[NSString stringWithFormat:@"성별 : %@", userInfo.userGender]]; }
    if (userInfo.userEmail) { [userInfoArray addObject:[NSString stringWithFormat:@"이메일 : %@",userInfo.userEmail]]; }
    if (userInfo.userNickName) { [userInfoArray addObject:[NSString stringWithFormat:@"닉네임 : %@",userInfo.userNickName]]; }
    if (userInfo.userAgeRang) { [userInfoArray addObject:[NSString stringWithFormat:@"연령 : %@",userInfo.userAgeRang]]; }
    if (userInfo.userBirthday) { [userInfoArray addObject:[NSString stringWithFormat:@"생일 : %@",userInfo.userBirthday]]; }
    if (userInfo.userProfileImage) { [userInfoArray addObject:[NSString stringWithFormat:@"프로필 이미지 주소 : %@",userInfo.userProfileImage]]; }
    if (userInfo.userProfileImage) { [userInfoArray addObject:[NSString stringWithFormat:@"프로필 이미지 주소 : %@",userInfo.userProfileImage]]; }
    if (userInfo.userAccessToken) { [userInfoArray addObject:[NSString stringWithFormat:@"AccessToken : %@",userInfo.userAccessToken]]; }
    if (userInfo.userRefreshToken) { [userInfoArray addObject:[NSString stringWithFormat:@"RefreshToken : %@",userInfo.userRefreshToken]]; }
    if (userInfo.userTokenRefreshDate) { [userInfoArray addObject:[NSString stringWithFormat:@"토큰 만료일 : %@", userInfo.userTokenRefreshDate]]; }
    
    for( NSString *infoText in userInfoArray ) {
        [userInfoText appendString:[NSString stringWithFormat:@"%@\n",infoText]];
    }
    
    return userInfoText;
}
@end
