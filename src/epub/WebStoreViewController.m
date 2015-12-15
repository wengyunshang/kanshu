//
//  WebStoreViewController.m
//  PandaBook
//
//  Created by weng xiangxun on 15/5/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WebStoreViewController.h"
@interface WebStoreViewController ()
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation WebStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)initWebView{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height-50-64)];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        
    }
}


-(void)loadUrl:(NSString*)urlarg{
    [self initWebView];
    [self lowWebview];
    
    NSString*sUrl = urlarg;
    for(int i=0; i< [urlarg length];i++){
        int a = [urlarg characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            sUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlarg, nil, nil, kCFStringEncodingUTF8);
    }
    NSURL* url = [NSURL URLWithString:sUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
}

-(void)loadHighUrl:(NSString*)urlarg{
    [self initWebView];
    [self highWebview];
    NSString*sUrl = urlarg;
    for(int i=0; i< [urlarg length];i++){
        int a = [urlarg characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            sUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlarg, nil, nil, kCFStringEncodingUTF8);
    }
    NSURL* url = [NSURL URLWithString:sUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //    [WXXLOADVIEW showself];
}
-(void)lowWebview{
    self.webView.frame = CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height-64-50);
}
-(void)highWebview{
    self.webView.frame = CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height-64);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[WxxPopView sharedInstance]showPopText:@"网络不给力"];
    
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"shows('你好');"];
    
    //    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

-(void)CallbackstringByEvaluatingJavaScriptFromString:(NSString*)callback{
    [self.webView stringByEvaluatingJavaScriptFromString:callback];
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
//    NSString *url = request.URL;
    // if (url是自定义的JavaScript通信协议) {
    //
    // do something
    //
    // 返回 NO 以阻止 `URL` 的加载或者跳转
    return YES;
    // }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
