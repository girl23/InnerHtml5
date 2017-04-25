//
//  ViewController.m
//  test
//
//  Created by wdwk on 2016/12/30.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView*schoolAdWebView;
@property(nonatomic,strong)NSString*videoJson;
@property(nonatomic, assign)BOOL isCanOrientation;
//屏幕旋转
@property(nonatomic,assign)UIInterfaceOrientation currentOrientation;
@end

@implementation ViewController
@synthesize schoolAdWebView,videoJson;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //判断屏幕当前方向；
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            _currentOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            _currentOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            _currentOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            _currentOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            break;
    }
    //html5需要的参数
    videoJson=[NSString stringWithFormat:@"{\'Video\':\'%@\',\'Poster\':\'%@\',\'Title\':\'%@\'}",@"https://wksctest.blob.core.chinacloudapi.cn/shop/store/video/9bf0960f8a6ce9ba664c9cc3b0db8d65.3gp",@"https://wksctest.blob.core.chinacloudapi.cn/shop/store/2016/10/14/05297725625881064.jpg",@"test"];
    schoolAdWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width,300)];
    schoolAdWebView.scrollView.bounces=NO;
    schoolAdWebView.scrollView.showsHorizontalScrollIndicator=NO;
    schoolAdWebView.scrollView.showsVerticalScrollIndicator=NO;
    schoolAdWebView.scrollView.scrollEnabled=NO;
    schoolAdWebView.delegate=self;
//    schoolAdWebView.allowsInlineMediaPlayback = YES;//允许内嵌音频；
    schoolAdWebView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:schoolAdWebView];
     [self makeInit];
}
#pragma mark - 通知中心检测到屏幕旋转
-(void)orientationChanged:(NSNotification *)notification{
    
    [self updateOrientation];
}
- (void)updateOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            [self toOrientation:UIInterfaceOrientationPortrait];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self toOrientation:UIInterfaceOrientationPortrait];
            break;
        default:
            break;
    }
}
#pragma mark - 全屏旋转处理
- (void)toOrientation:(UIInterfaceOrientation)orientation {
   
    if (_currentOrientation == orientation) {
        return;
    }
    _currentOrientation = orientation;
  
    [[UIApplication sharedApplication] setStatusBarOrientation:_currentOrientation animated:YES];
    
    self.schoolAdWebView.transform = [self getOrientation:orientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
       
    }
    
    
}
//根据状态条旋转的方向来旋转
-(CGAffineTransform)getOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait) {
        [self toPortraitUpdate];
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        [self toLandscapeUpdate];
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        [self toLandscapeUpdate];
        return CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self toPortraitUpdate];
        return CGAffineTransformMakeRotation(M_PI);
    }
    return CGAffineTransformIdentity;
}

-(void)toLandscapeUpdate{
 
    //处理状态条
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(void)toPortraitUpdate{
  
    //处理状态条
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}



-(void)makeInit {
    
    NSString *docuPath = [self getDocumentsPath];
    NSString *htmlPath = [docuPath stringByAppendingPathComponent:@"VideoHtml"];
    NSString *filename=@"video.html";
    
    NSString *filePath = [htmlPath stringByAppendingPathComponent:filename];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [schoolAdWebView loadRequest:request];
    
}
-(NSString *)getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js=[NSString stringWithFormat:@"initVideo(%@)", videoJson];
    [webView stringByEvaluatingJavaScriptFromString:js];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}



@end
