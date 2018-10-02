#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

//#define INDICATION_COUNT_LOG_SHOW // 인디케이터 생성 및 제거 카운트 로그 노출 여부

@interface IndicatorView : NSObject{
    int countIndicatorView;
}

+ (IndicatorView *)sharedInstnace;

- (void)show;
- (void)dismiss;

@end

