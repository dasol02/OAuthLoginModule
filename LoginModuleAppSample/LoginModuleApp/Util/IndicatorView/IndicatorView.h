#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface IndicatorView : NSObject{
    int countIndicatorView;
}

+ (IndicatorView *)sharedInstnace;

- (void)show;
- (void)dismiss;

@end

