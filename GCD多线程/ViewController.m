//
//  ViewController.m
//  GCD多线程
//
//  Created by dllo on 15/3/10.
//  Copyright (c) 2015年 赵雪松. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [self.aImageView release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 网络请求两种
    // AFNetWorking
    // ASIHttpRequest
    self.aImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_aImageView];
    [_aImageView release];
    [self createFirstGCD];
    

}
- (void) createFirstGCD{
    // 异步执行---------并发的线程队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://marry.qiniudn.com/FjJJC2w1aQbaTunm9Dq3Kkgg9C2U"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        // 显示当前线程
        NSLog(@"%@", [NSThread currentThread]);
        // 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.aImageView setImage:image];
        });
    });
    // 创建一个同步的线程队列(串行队列)
//    dispatch_queue_t serial = dispatch_queue_create(@"oo", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(serial, ^{
//        NSLog(@"*****%@", [NSThread currentThread]);
//    });
}

// 创建一个group  并发执行
- (void) createGCD{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        });
        // dispatch_group_notify函数用来指定一个额外的block，该block将在group中所有任务完成后执行
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
        });
        dispatch_release(group);
    });
    
    
}





/*
{
 GCD的另一个用处是可以让程序在后台较长久的运行。
 
 在没有使用GCD时，当app被按home键退出后，app仅有最多5秒钟的时候做一些保存或清理资源的工作。但是在使用GCD后，app最多有10分钟的时间在后台长久运行。这个时间可以用来做清理本地缓存，发送统计数据等工作。
 让程序在后台长久运行的示例代码如下：
 // AppDelegate.h文件
 @property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
 
 // AppDelegate.m文件
 - (void)applicationDidEnterBackground:(UIApplication *)application
 {
 [self beingBackgroundUpdateTask];
 // 在这里加上你需要长久运行的代码
 [self endBackgroundUpdateTask];
 }
 - (void)beingBackgroundUpdateTask
 {
 self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
 [self endBackgroundUpdateTask];
 }];
 }
 - (void)endBackgroundUpdateTask
 {
 [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
 self.backgroundUpdateTask = UIBackgroundTaskInvalid;
 }
*/














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
