# SNS OAuth Login Manager Developer Guide 

OAuth Manager은 Android, iOS의 OS에서 SNS OAuth Login 개발을 

각 연동사 별로 구현없이 하나의 Manager를 이용하여 연동할 수 있게 개발되었다.

개발 가이드는 아래 방법에 따라 진행 한다.
```ruby
# Andorid Api 9 이상
# iOS 9.0 이상
```

### 지원 가능 SNS OAuth Login
* Naver
* Kakao
* Facebook
* Google

<img src="https://github.com/dasol02/BixbyDeveloperGuideIMG/blob/master/OAuthManager_Sample.gif?raw=true" width="300" height="550"><img src="https://github.com/dasol02/BixbyDeveloperGuideIMG/blob/master/OAuthManager_sample_android.gif?raw=true" width="300" height="550">


# OAuth Manager API

## 로그인
로그인 진행할 클래스에서 아래의 내용을 각 OS에 추가하여 구현한다.

**Android**
```ruby
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthBaseClass;
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthManager;
import static com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthBaseClass.OAuthType.*;
```
```ruby
@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    OAuthManager.getsInstance().responseOnActivityResult(requestCode,resultCode,data);
}
```
```ruby
OAuthManager.getsInstance().requestSNSLogin(OAuth_NAVER, this, new OAuthManager.OAuthLoginInterface() {
    @Override
    public void responseLoginResult(Boolean result, String token, String error) {
        if(result){
        	// TODO : Login Success
        }else{
           // TODO : Login Fail
        }
    }
});

```

**iOS**
```
#import "OAuthManager.h"
```
```ruby
[[OAuthManager sharedInstnace] requestOAuthManagerLogin:(OAUTH_TYPE)OAUTH_TYPE_NAVER handler:^(bool result) {
	// TODO : Login Result
	if (result) {
		// TODO : Login Success
	} else{
		// TODO : Login Fail
	}
}];
```

## 사용자 정보 조회

사용자 정보조회를 진행할 클래스에서 아래의 내용을 각 OS에 추가하여 구현한다.

**사용자 제공 정보**

아래 내용은 각 연동사에서 제공하는 사용자 기본제공 정보이며 이외의 사용자정보는 추가 요청하여야 한다.

```
Naver  : 이름, 이메일, 성별, 생년월일, 연령대, 별명, 프로필사진
Kakao : 이름, 이메일, 성별,  생년월일, 연령대, 전화번호
Facebook : 이름, 이메일(휴대전화로 가입시 이메일 정보 공백)
Google : 이름, 이메일

```

**Android**
```ruby
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthBaseClass;
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthManager;
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthUserInfo;
```
```ruby
OAuthManager.getsInstance().requestUserFrofileInfo(this, new OAuthManager.OAuthUserFrofileInterface() {
    @Override
    public void responseUserFrofileInfoResult(Boolean result, final OAuthUserInfo oAuthUserInfo, String error) {
        // TODO : OAuth Request Userinfo Success
        // Response Userinfo
        if(result){
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    // UI Updagte
                }
            });
        }
    }
});
```
**OAuthUserinfo**
```ruby
public class OAuthUserInfo {
    private String userName;
    private String userID;
    private String userGender;
    private String userEmail;
    private String userNickName;
    private String userAgeRang;
    private String userBirthday;
    private String userProfileImage;
    private String userAccessToken;
    private String userRefreshToken;
    private String userTokenRefreshDate;
	.....
}
```

**iOS**
```
#import "OAuthManager.h"
```
```ruby

[[OAuthManager sharedInstnace] requestOAuthManagerGetUserData:^(bool result, OAuthUserInfo userInfo) {
    if (result) {
       // TODO : OAuth Request Userinfo Success
       // Response Userinfo
	    dispatch_async(dispatch_get_main_queue(), ^{
	      // UI Updagte
	    });
    }
}];
```

**OAuthUserinfo**
```ruby
typedef struct OAuthUserInfo {
    NSString *userName;
    NSString *userID;
    NSString *userGender;
    NSString *userEmail;
    NSString *userNickName;
    NSString *userAgeRang;
    NSString *userBirthday;
    NSString *userProfileImage;
    NSString *userAccessToken;
    NSString *userRefreshToken;
    NSString *userTokenRefreshDate;
} OAuthUserInfo;
```

## 로그아웃

로그아웃을 진행할 클래스에서 아래의 내용을 각 OS에 추가하여 구현한다.

**Android**
```ruby
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthBaseClass;
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthManager;
```

```ruby
OAuthManager.getsInstance().requestSNSLogOut(this, new OAuthManager.OAuthLogoutInterface() {
    @Override
    public void responseLogoutResult(Boolean result) {
        if(result){
           // TODO : Logout Success
        }else{
           // TODO : Logout Fail
        }
    }
});
```

**iOS**
```
#import "OAuthManager.h"
```
```ruby
[[OAuthManager sharedInstnace] requestOAuthManagerLogout:^(bool result){
   if (result) {
		// TODO : Logout Success
	} else{
		// TODO : Logout Fail
	}
}];
```

## 연동해제

연동해제를 진행할 클래스에서 아래의 내용을 각 OS에 추가하여 구현한다.
```
페이스북의 경우 연동해제는 제공되지 않으며, 사용자가 직접 페이스북에서 연동을 해제하여야 한다.
```


**Android**
```ruby
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthBaseClass;
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthManager;
```
```ruby
OAuthManager.getsInstance().requestSNSDelete(this, new OAuthManager.OAuthRemoveInterface() {
    @Override
    public void responseRemoveResult(Boolean result, String error) {
        if(result){
			// TODO : Remove Success
        }else{
			// TODO : Remove Fail
        }
    }
});

```

**iOS**
```
#import "OAuthManager.h"
```
```ruby

[[OAuthManager sharedInstnace] requestOAuthManagerRemove:^(bool result) {
	if(result){
		// TODO : Remove Success
	}else{
		// TODO : Remove Fail
	}
}];
```



# OAuth Manager 환경 설정
OAuthManager 사용을 위한 기본설정 내용이며, 각 SNS OAuth 연동사에 대한 연동설정은 다음 단락의 내용을 참고

## Android
[OAuthManager Android Download Github](https://github.com/dasol02/OAuthLoginModuleAndroid) import Your Project

![](https://raw.githubusercontent.com/dasol02/BixbyDeveloperGuideIMG/master/Android%20OAuth.png)

**Application**
```ruby
import com.oauthloginmoduleandroid.gaea.oauthloginmoduleandroid.OAuthLogin.OAuthManager;
```
```ruby
 @Override
    public void onCreate() {
        super.onCreate();
        OAuthManager.getsInstance().requestStartApp();
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        OAuthManager.getsInstance().requestDidApp();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        OAuthManager.getsInstance().requestDidApp();
    }
```

**strings.xml**
```XML
<resources>
    <string name="naver_client_id">Your App Naver Client Key</string>
    <string name="naver_client_secret">Your App Naver Client Secret</string>
    <string name="naver_client_name">Your App Naver Client Name</string>
    <string name="kakao_app_key">Your Kakao App Key</string>
    <string name="facebook_app_id">Your Facebook App ID</string>
    <string name="fb_login_protocol_scheme">Your Facebook Login Scheme</string>
    <string name="server_client_id">Your App Google Client ID</string>
</resources>
```

## iOS

[OAuthManager iOS Download Github](https://github.com/dasol02/OAuthLoginModuleiOS) import Your Project

![](https://raw.githubusercontent.com/dasol02/BixbyDeveloperGuideIMG/master/iOS%20OAuth.png)

**AppDelegate.m**
```
#import "OAuth/OAuthManager.h"
```
```ruby
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[OAuthManager sharedInstnace] requestStartOAuthManager:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[OAuthManager sharedInstnace] requestOAuthManagerNativeOpenURL:app openURL:url options:options];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[OAuthManager sharedInstnace] requestDidOAuthManager];
}
```

**info.plist**
```xml
    <key>NAVER_SERVICE_APP_URL_SCHEME</key>
    	<string>Your Naver App Scheme</string>
    <key>NAVER_CONSUMER_KEY</key>
   		 <string>Your Naver App Key</string>
    <key>NAVER_CONSUMER_SECRET</key>
    	<string>Your Naver App Secret</string>
    <key>NAVER_SERVICE_APP_NAME</key>
    	<string>Your App Name</string>
    <key>GOOGLE_CLIENT_ID</key>
   	 	<string>Your App Google Client ID </string>
	<key>FacebookAppID</key>
		<string>Your Facebook App ID</string>
	<key>FacebookDisplayName</key>
		<string>Your Facebok Display Name</string>
	<key>KAKAO_APP_KEY</key>
		<string>Your Kakao App key</string>
```

# SNS 환경설정


## 각 연동사 SNS OAuth Login 설정 가이드

* Naver ([Android Guide](https://developers.naver.com/docs/login/android/), [iOS Guide](https://developers.naver.com/docs/login/ios/))
* Kakao ([Android Guide](https://developers.kakao.com/docs/android/user-management#%EB%A1%9C%EA%B7%B8%EC%9D%B8), [iOS Guide](https://developers.kakao.com/docs/ios/user-management#%EB%A1%9C%EA%B7%B8%EC%9D%B8))
* Facebook ([Android Guide](https://developers.facebook.com/docs/facebook-login/android), [iOS Guide](https://developers.facebook.com/docs/facebook-login/ios))
* Google ([Android Guide](https://developers.google.com/identity/sign-in/android/start), [iOS Guide](https://developers.google.com/identity/sign-in/ios/start-integrating))


## SNS Applicsation Service 등록
### Naver
[네이버 가이드](https://developers.naver.com/docs/login/register/)에 따라 사용하고자 하는 앱서비스를 [Naver Developer Application](https://developers.naver.com/apps/#/register)페이지에 등록 한다.

### Kakao
[카카오 가이드](https://developers.kakao.com/docs/android/getting-started#앱-생성)에 따라 사용하고자 하는 앱서비스를 [Kakao Developers 앱 만들기](https://developers.kakao.com/apps/new)페이지에 등록 한다.

### Facebook
[페이스북 앱 등록 및 구성](https://developers.facebook.com/docs/facebook-login/ios)에 따라 사용하고자 하는 앱서비스를 등록한다.

[앱 등록 페이지](https://developers.facebook.com/?advanced_app_create=true)(내앱 - 새 앱 추가)

### Google
구글 API 콘솔 프로젝트 등록 및 구성([Android](https://developers.google.com/identity/sign-in/android/start-integrating), [iOS](https://developers.google.com/identity/sign-in/ios/start-integrating))에 따라 사용하고자 하는 앱서비스를 등록한다.



## SDK 설정

### Android
**build.gradle 설정 (App)**
```ruby
android {
    ...
    // Naver ProGuard Exception Setting
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

...
dependencies {
    // Kakao
    implementation group: 'com.kakao.sdk', name: 'usermgmt', version: '1.13.0'
    // Naver
    implementation 'com.naver.nid:naveridlogin-android-sdk:4.2.5'
    // Facebook
    implementation 'com.facebook.android:facebook-login:[4,5)'
    // Google
    implementation 'com.google.android.gms:play-services-auth:15.0.1'
}
```

**build.gradle 설정 (Project)**
```ruby
buildscript {
    repositories {
        // Google
		google()
        // Facebook
        jcenter()
    }
    ...
    // Kakao
    subprojects {
        repositories {
            mavenCentral()
            maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }
        }
    }
}

allprojects {
    repositories {
        // Google
		google()
        // Facebook
        jcenter()
    }
}
```

**AndroidManifest.xml 설정**
```XML
<uses-permission android:name="android.permission.INTERNET" />
```
```python
<application
    // kakao
    <meta-data
        android:name="com.kakao.sdk.AppKey"
        android:value="@string/kakao_app_key"/>

    // Facebook
    <meta-data
        android:name="com.facebook.sdk.ApplicationId"
        android:value="@string/facebook_app_id"/>
    <activity
        android:name="com.facebook.FacebookActivity"
        android:configChanges= "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
        android:label="@string/app_name" />
    <activity
        android:name="com.facebook.CustomTabActivity"
        android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="@string/fb_login_protocol_scheme" />
        </intent-filter>
    </activity>
</application>
```


### iOS 

**프로젝트내에 프레임워크 직접 추가**

* [SNS OAuth Framework 다운로드](https://github.com/dasol02/OAuthLoginModuleiOS/tree/master/Frameworks) 이후 프로젝트내에 추가

**Cocoapods 사용시**

* Pod를 설치하기 전에 시스템에 CocoaPods 젬을 설치 (이렇게 하면 프로젝트의 루트 디렉터리에 Podfile이라는 파일이 생성됩니다.)
```
$ sudo gem install cocoapods 
$ pod init
```
* Podfile가 생성이 안되었을 경우
```
$ touch -e Podfile
```
* 아래 연동사 SDK 정보를 Podfile에 추가한다.
``` ruby
pod 'naveridlogin-sdk-ios'
pod 'GoogleSignIn'	
pod 'FBSDKLoginKit'	
pod 'KakaoOpenSDK'
```
* 프로젝트 루트 디렉터리의 다음 명령을 실행합니다.
```
$ pod install
```

**info.plist 설정**

구글 클라이언트 아이디의 경우 아래 내용으로 변경하여 추가한다.

    구글 제공 스키마: 463686728262-mqjt49pp0e46sf415ui9o7bo8cj9pgn6.apps.googleusercontent.com
    변경된 스키마 : com.googleusercontent.apps.463686728262-mqjt49pp0e46sf415ui9o7bo8cj9pgn6

```XML
	<key>CFBundleURLTypes</key>
	<array>

        // Naver
		<dict>
			<key>CFBundleTypeRole</key>
			     <string>Editor</string>
			<key>CFBundleURLName</key>
			     <string>com.nhncorp.oauthLogin</string>
			<key>CFBundleURLSchemes</key>
    			 <array>
    				 <string>Naver URL Scheme</string>
    			 </array>
		</dict>

        // Kakao
		<dict>
			<key>CFBundleTypeRole</key>
			     <string>Editor</string>
			<key>CFBundleURLSchemes</key>
    			 <array>
    				 <string>Kakao URL Scheme</string>
    			 </array>
		</dict>

        // Facebook
		<dict>
			<key>CFBundleURLSchemes</key>
    			 <array>
    				 <string>Facebook URL Scheme</string>
    			 </array>
		</dict>

        // Google
		<dict>
			<key>CFBundleTypeRole</key>
			     <string>Editor</string>
			<key>CFBundleURLSchemes</key>
    			 <array>
    				 <string>Google URL Scheme</string>
    			 </array>
		</dict>
	</array>
```

```XML
<key>LSApplicationQueriesSchemes</key>
<array>
    // Naver
	<string>naversearchapp</string>
	<string>naversearchthirdlogin</string>

    // Kakao
	<string>kakao0123456789abcdefghijklmn</string>
	<string>kakaokompassauth</string>
	<string>storykompassauth</string>
	<string>kakaolink</string>
	<string>kakaotalk-5.9.7</string>
	<string>kakaostory-2.9.0</string>
	<string>storylink</string>

    // Facebook
	<string>fbapi</string>
	<string>fb-messenger-api</string>
	<string>fbauth2</string>
	<string>fbshareextension</string>
</array>
```
```XML
	// Naver
    <key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
    		<dict>
    			<key>naver.com</key>
        			<dict>
        				<key>NSExceptionAllowsInsecureHTTPLoads</key>
        				    <true/>
        				<key>NSExceptionRequiresForwardSecrecy</key>
        				    <false/>
        				<key>NSIncludesSubdomains</key>
        				    <true/>
        			</dict>
    			<key>naver.net</key>
        			<dict>
        				<key>NSExceptionAllowsInsecureHTTPLoads</key>
        				    <true/>
        				<key>NSExceptionRequiresForwardSecrecy</key>
        				    <false/>
        				<key>NSIncludesSubdomains</key>
        				    <true/>
        			</dict>
    		</dict>
	</dict>
```
**Project Linked Frameworks and Libraries 설정**

```py
Naver
- NaverThirdPartyLogin.framework

Kakao
- KakaoOpenSDK.framework

Google
- GoogleSignIn.bundle
- GoogleSignIn.framework
- GoogleSignInDependencies.framework
- LocalAuthentication.framework
- SafariServices.framework
- SystemConfiguration.framework

Facebook
- FBSDKCoreKit.framework
- FBSDKLoginKit.framework
- Bolts.framework

```
![](https://github.com/dasol02/BixbyDeveloperGuideIMG/blob/master/OAuth_iOS_LinkedFramework.png?raw=true)
**Project Embedded Binarles 설정**
![](https://github.com/dasol02/BixbyDeveloperGuideIMG/blob/master/OAuth_iOS_Embedded%20Binarles.png?raw=true)
**Project info URL Types 설정**
![](https://github.com/dasol02/BixbyDeveloperGuideIMG/blob/master/OAuth_iOS_URL_Types.png?raw=true)


**Project  Build Settings 설정**

Linking - Other Linker Flags에 -all_load, -ObjC를 추가한다.


# SNS Login App Key 설정

## Android

**Naver**
```
네이버 자체 클라이언트 아이디 및 시크릿 아이디로 등록
```
**Kakao**
```
debug, release Key 등록 필수
```
**Facebook **
```
debug, release Key 등록 필수
```
**Google**
```
자체 클라이언트 ID로 등록
```
## iOS

iOS App 번들 ID 등록 

```
- Naver
- Kakao
- Facebook
- Google
```

# SNS Login App 검수
## Naver

**필수 항목 확인 3.1.3**

네이버 개발자센터에 애플리케이션 등록이 완료되면 개발자센터의 'Application-내 애플리케이션' 메뉴에서 등록된 

애플리케이션에 대한 확인이 가능합니다.네아로의 올바른 적용을 위해서 필수적으로 확인이 필요한 사항은 다음과 같습니다.
```
1. 애플리케이션 이름은 명확하고 간결하게 작성이 되어야합니다
2. 애플리케이션 이름은 네아로 연동 시 사용자에게 보여지는 항목이므로 
   "의미를 알수 없는 문자" 또는 "서비스와 관련없는 이름"은 사용하지 말아야 합니다.
3. 로고이미지는 규격을 준수하며 서비스를 대표할수 있는 이미지로 설정하여야합니다.
   로고이미지는 네아로 연동 시 사용자에게 보여지는 항목으로 서비스를 대표할수 있는 아이콘 또는 이미지여야합니다.
4. 추가 정보 입력을 위하여 사용 API에 "네아로(네이버 아이디로 로그인)"를 반드시 선택하여야합니다.
   로그인 오픈API 서비스 환경은 반드시 1개 이상의 서비스 환경을 선택하여야합니다.
5. 웹 서비스 환경에서는 서비스의 대표 URL(홈페이지 URL)이 정확하게 입력이 되어야합니다.
6. 애플리케이션 환경에서는 애플리케이션의 기본 설정 정보 중 AppScheme 과 package name을 반드시 확인하여 정확하게 입력이 되어야합니다.
```
**사전 검수 요청 3.1.4**

개발이 완료되어 실제 서비스에 적용하고자 한다면 애플리케이션 검수 요청을 등록해야 합니다. 

검수가 완료되어 승인이 될 경우에만 로그인 가능한 아이디의 제한 없이 네이버 아이디로 로그인을 정상적으로 이용할 수 있습니다. 

검수 요청 전, 3.1.3의 필수 항목과 [네아로 적용 가이드](https://developers.naver.com/products/login/userguide/)에서 명시하는 내용을 준수하는지 확인해야 합니다. 

특히 적용 가이드에서 명시하는 '별도의 비밀번호'를 받지 않도록 하여야 하며 이를 준수하지 않을 경우 승인이 거부될 수 있습니다. 

[네아로 특약 참조](https://developers.naver.com/products/terms/)
```
# 검수 요청 등록 방법
   1. 3.1.3의 필수항목과 네아로 적용 가이드를 준수하고 있는지 확인합니다.
   2. 검수 요청 버튼 클릭 후 보여지는 화면에서, 애플리케이션에서 "네아로" 기능을 어떻게 사용하는지 적용 상태 정보를 입력합니다. 
```

## Kakao
카카오 정책 및 약관 [운영정책](https://developers.kakao.com/policies/usage)
```
카카오 소셜 로그인 운영정책 준수 추가 검수 사항 없음
```

## Facebook
**페이스북 필수 정책 및 검수 가이드**

* [플랫폼 정책](https://developers.facebook.com/policy/?locale=ko_KR)을 준수하여 개발

* [로그인 플로 테스트](https://developers.facebook.com/docs/facebook-login/testing-your-login-flow?locale=ko_KR)를 준수하여 개발

**검수가 필요한 권한**
```
* 두 가지 기본 권한인 public_profile, email 권한 요청에 대해서는 검수가 필요하지 않습니다.
* 사용자가 앱에 로그인할 때 다른 권한을 요청하는 경우에는 검수가 필요합니다.
```

**검수를 위해 제출하지 않을 경우**
```
앱에서 Facebook 로그인을 사용하고 사용자의 Facebook 프로필에 있는 추가 요소에 액세스하려면 검수를 위해 앱을 제출해야 합니다. 
앱이 승인되지 않거나 검수를 위해 제출하지 않은 경우 사용자가 앱에서 Facebook 로그인을 사용할 수 없습니다.
```

## Google
[Google API 서비스 약관](https://developers.google.com/terms/?hl=ko)
```
구글 소셜 로그인 운영정책 준수 추가 검수 사항 없음
```










