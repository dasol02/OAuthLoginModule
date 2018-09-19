#import "IndicatorView.h"

@implementation IndicatorView

+ (IndicatorView *)sharedInstnace{
    static IndicatorView * indicatorView= nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicatorView = [[IndicatorView alloc] init];
    });
    
    return indicatorView;
}

-(instancetype)init{
    self = [super init];
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    countIndicatorView = 0;
    
    return self;
}


- (void)show{
    
    if(countIndicatorView == 0){
        [SVProgressHUD showLoadingImage];
    }
    countIndicatorView += 1;
    
    NSLog(@"\n IndicatorView show = %d",countIndicatorView);
}

- (void)dismiss{
    
    if(countIndicatorView == 1){
        [SVProgressHUD dismiss];
    }
    
    countIndicatorView -= 1;
    NSLog(@"\n IndicatorView dismiss = %d",countIndicatorView);
    
}


@end
