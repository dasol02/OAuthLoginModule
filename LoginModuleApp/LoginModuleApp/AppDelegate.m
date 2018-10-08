#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [OAuthManager sharedInstnace];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [GIDSignIn sharedInstance].clientID = @"463686728262-mqjt49pp0e46sf415ui9o7bo8cj9pgn6.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
//    return [[OAuthManager sharedInstnace] oAuthCheckOpenURL:app openURL:url options:options];
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [KOSession handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}



// [START signin_handler]
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if(error){
        
    }else{
        NSString *userId = user.userID;
        NSString *idToken = user.authentication.idToken;
        NSString *accessToken = [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
        NSString *fullName = user.profile.name;
        NSString *email = user.profile.email;
        
        // 추가적인 개인정보 호출
        NSString *targetUrl = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@",[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
        [self getGoogleUserData:targetUrl];
    }
}


- (void)getGoogleUserData:(NSString *)userToken{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"basic_attribution", @"scenario_type",
                         nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:userToken]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,NSError * _Nullable error) {
        
        if(error){
            
        }else{
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data received: %@", responseStr);
        }
      }] resume];
}



@end
