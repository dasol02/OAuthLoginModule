#import "IndicatorView.h"

@implementation IndicatorView

+ (IndicatorView *)sharedInstnace{
    static IndicatorView * indicatorView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicatorView = [[IndicatorView alloc] init];
    });
    
    return indicatorView;
}

-(instancetype)init{
    self = [super init];
    
    dispatch_block_t block = ^{
        [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
        self->countIndicatorView = 0;
    };
    
    [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block);
   
    return self;
}


- (void)show{
    
    dispatch_block_t block = ^{
        if(self->countIndicatorView == 0){
            [SVProgressHUD showLoadingImage];
        }
        self->countIndicatorView += 1;
#ifdef INDICATION_COUNT_LOG_SHOW
        NSLog(@"\n IndicatorView dismiss = %d",self->countIndicatorView);
#endif
    };
    
    [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block);
    
}

- (void)dismiss{
    
    dispatch_block_t block = ^{
        if(self->countIndicatorView <= 0){
            return;
        }
        
        if(self->countIndicatorView == 1){
            [SVProgressHUD dismiss];
        }
        
        self->countIndicatorView -= 1;
#ifdef INDICATION_COUNT_LOG_SHOW
        NSLog(@"\n IndicatorView dismiss = %d",self->countIndicatorView);
#endif
    };
    
   [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block);
}


@end
