#import "UserViewController.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textFieldUserData;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OAuthManager sharedInstnace].delegate = self;
    [[OAuthManager sharedInstnace] oAuthManagerUserData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getOAuthManagerUserData:(NSString *)userData{
    dispatch_sync(dispatch_get_main_queue(), ^{
            [self.textFieldUserData setText:userData];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
