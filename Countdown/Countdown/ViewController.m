//
//  ViewController.m
//  Countdown
//
//  Created by LiDinggui on 2018/3/16.
//  Copyright © 2018年 DAQSoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (IBAction)getVerificationCodeButtonClicked:(UIButton *)sender
{
    __block NSInteger second = 60;
    //全局队列    默认优先级
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global_queue);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0)
            {
                sender.userInteractionEnabled = NO;
                [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [sender setTitle:[NSString stringWithFormat:@"%lds后重新获取验证码",second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                sender.userInteractionEnabled = YES;
                [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}


@end
