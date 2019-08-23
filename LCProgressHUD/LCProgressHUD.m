//
//  Created by 刘超 on 15/4/14.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LCProgressHUD.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

@implementation LCProgressHUD

+ (instancetype)sharedHUD {
    static LCProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(LCProgressHUDStatus)status text:(NSString *)text {

    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    [hud showAnimated:YES];
    [hud setShowNow:YES];
    hud.label.text = text;
    hud.detailsLabel.text = @"";
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];

    NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"LCProgressHUD" ofType:@"bundle"];

    switch (status) {

        case LCProgressHUDStatusSuccess: {

            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"hud_success@2x.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hideAnimated:YES afterDelay:1.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;

        case LCProgressHUDStatusError: {

            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"hud_error@2x.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hideAnimated:YES afterDelay:1.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;

        case LCProgressHUDStatusWaitting: {

            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;

        case LCProgressHUDStatusInfo: {

            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"hud_info@2x.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hideAnimated:YES afterDelay:1.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;

        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    if (NSThread.currentThread.isMainThread) {
        LCProgressHUD *hud = [LCProgressHUD sharedHUD];
        [hud showAnimated:YES];
        [hud setShowNow:YES];
        hud.label.text = text;
        hud.detailsLabel.text = @"";
        [hud setMinSize:CGSizeZero];
        [hud setMode:MBProgressHUDModeText];
        [hud setRemoveFromSuperViewOnHide:YES];
        hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        //    [hud hide:YES afterDelay:1.0f];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showMessage:text];
        });
    }

}

+ (void)showInfoMsg:(NSString *)text {
    if (NSThread.currentThread.isMainThread) {
        [self showStatus:LCProgressHUDStatusInfo text:text];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showInfoMsg:text];
        });
    }
    
}

+ (void)showFailure:(NSString *)text {
    if (NSThread.currentThread.isMainThread) {
        [self showStatus:LCProgressHUDStatusError text:text];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showFailure:text];
        });
    }
    
}

+ (void)showSuccess:(NSString *)text {

    if (NSThread.currentThread.isMainThread) {
        [self showStatus:LCProgressHUDStatusSuccess text:text];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showSuccess:text];
        });
    }
    
}

+ (void)showLoading:(NSString *)text {
    if (NSThread.currentThread.isMainThread) {
        [self showStatus:LCProgressHUDStatusWaitting text:text];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showLoading:text];
        });
    }
    
}

+ (void)hide {
    if (NSThread.currentThread.isMainThread) {
        [[LCProgressHUD sharedHUD] setShowNow:NO];
        [[LCProgressHUD sharedHUD] hideAnimated:YES];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
        });
    }
}

+ (void)showDetail:(NSString *)text{
    
    if (NSThread.currentThread.isMainThread) {
        LCProgressHUD *hud = [LCProgressHUD sharedHUD];
        [hud showAnimated:YES];
        [hud setShowNow:YES];
        hud.label.text = text;
        hud.detailsLabel.text = @"";
        [hud setMinSize:CGSizeZero];
        [hud setMode:MBProgressHUDModeText];
        [hud setRemoveFromSuperViewOnHide:YES];
        hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        //    [hud hide:YES afterDelay:1.0f];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showDetail:text];
        });
    }
    

}


@end
