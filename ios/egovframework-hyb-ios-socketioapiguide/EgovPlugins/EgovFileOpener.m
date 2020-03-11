//
//  EgovFileOpener.m
//  DEVICEAPI
//
//  Created by sh.jang 2016. 7. 12.
//
//  수정일         수정자         수정내용
//  ----------   ---------    -------------------------------
//  2019.11.13   신용호         다운로드 오류시 예외 처리 수정
//
//

#import "EgovFileOpener.h"


@implementation EgovFileOpener {
    BOOL resultError;
}

- (void)fileDownload:(CDVInvokedUrlCommand *)command {
    
    resultError = NO;
    
    NSString *url = [command.arguments objectAtIndex:0];
    NSMutableDictionary *params = [command.arguments objectAtIndex:1];
    self.callbackID = command.callbackId;
    
    NSLog(@"url : %@", url);
    NSLog(@"options : %@", params);
    
    self.streFileNm = [params objectForKey:@"streFileNm"];
    self.orignlFileNm = [params objectForKey:@"orignlFileNm"];
    self.targetPath = [params objectForKey:@"targetPath"];
    
    NSLog(@"streFileNm : %@", self.streFileNm);
    NSLog(@"orignlFileNm : %@", self.orignlFileNm);
    NSLog(@"targetPath : %@", self.targetPath);
    
    if (self.targetPath==nil || [self.targetPath isKindOfClass:[NSNull class]]) {
        NSLog(@"targetPath is null");
        NSArray *pa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentFilePath = [pa objectAtIndex:0];
        NSLog(@">>> documentFilePath %@",documentFilePath);
        self.targetPath = [documentFilePath stringByAppendingPathComponent:@"/www"];
    } else {
        NSLog(@"targetPath : <%@>",self.targetPath);
    }
    
    NSString *downloadAssetFileUrl;
    if (url==nil || [url isKindOfClass:[NSNull class]]) {

        NSLog(@"ERROR : url param is null");
        NSLog(@"Connection Fail!!!");
        resultError = YES;

        // Cordova 콜백 처리
        [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:1 addMessage:@" (URL)"];
        // 에러처리
    } else {
        downloadAssetFileUrl = [NSString stringWithFormat:@"%@%@", kSERVER_URL, url];
        NSLog(@"downloadAssetFileUrl : %@", downloadAssetFileUrl);
    }
    
    //프로그레스바 생성 및 화면에 보여줌
    [self initDialogView:@"리소스 파일을 다운로드 중입니다."];
    [self dialogView:@"show" progress:0];
    
    [self FileOpenerFileAtUrl:downloadAssetFileUrl];
    
}


- (BOOL) FileOpenerFileAtUrl:(NSString*)updateFileUrl
{
    
    NSLog(@">>> download UPDATEFILE from URL = %@",updateFileUrl);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:updateFileUrl]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        _receivedData = [NSMutableData data];
        
    } else {
        // Inform the user that the connection failed.
        NSLog(@"Connection Fail!!!");
        resultError = YES;

        // Cordova 콜백 처리
        [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:2 addMessage:@" (URL)"];
        
        return NO;
    }
    return YES;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSLog(@">>> suggestedFilename = %@",response.suggestedFilename);
    NSLog(@">>> expectedContentLength = %lld",response.expectedContentLength);
    
    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpURLResponse statusCode];
    switch (statusCode)
    {
        case 404:
            resultError = YES;
            // Cordova 콜백 처리
            [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:3 addMessage:@" URL이 존재하지 않습니다."];
            NSLog(@"=> Server Error  : 404");
            [connection cancel];
            [self dialogView:@"hide" progress:0];
            break;
        case 500:
            resultError = YES;
            // Cordova 콜백 처리
            [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:3 addMessage:@" 서버 내부오류가 발생했습니다."];
            NSLog(@"=> Server Error  : 500");
            [connection cancel];
            [self dialogView:@"hide" progress:0];
            break;
        default:
            break;
    }
    
    if (response.expectedContentLength==0)
        self.expectedContentLength = 1;
    else {
        self.expectedContentLength = response.expectedContentLength;
        self.downloadContentLength = 0;
    }
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData appendData:data];
    self.downloadContentLength += [data length];
    float progress = (self.downloadContentLength*1.0f)/self.expectedContentLength;
    NSLog(@"progress = %f",progress);
    [self dialogView:@"progress" progress:progress];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //[connection release];
    // receivedData is declared as a method instance elsewhere
    //[receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

    resultError = YES;
    // Cordova 콜백 처리
    [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:3 addMessage:[error localizedDescription]];
    [self dialogView:@"hide" progress:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    //NSString *fileInfo= [NSString stringWithFormat:@"Succeeded! Received %lu bytes of data",(unsigned long)[_receivedData length]];
    //[self performSelectorOnMainThread:@selector(log:) withObject:fileInfo waitUntilDone:YES];
    
    NSLog(@"=> download Finish");
    NSString *targetFileLocation = [self.targetPath stringByAppendingString:self.orignlFileNm];
    
    BOOL ret = [_receivedData writeToFile:[targetFileLocation stringByReplacingOccurrencesOfString:@"file://" withString:@""] atomically:YES];
  
    NSLog(@"targetFileLocation : %@", targetFileLocation);
    NSLog(@">>> File Store Result: %@", (ret ? @"YES": @"NO"));
    

    if (ret==YES) { // 성공
        
        // Cordova 콜백 처리
        [self requestOKCommandDelegateWithCallBackId:self.callbackID addMessage:@""];
        
    } else { // 오류
        
        // Cordova 콜백 처리
        [self requestFailCommandDelegateWithCallBackId:self.callbackID errorCode:9 addMessage:@""];
        
    }
    
    [self dialogView:@"hide" progress:0];
    
}

- (void) requestFailCommandDelegateWithCallBackId:(NSString*)callbackID errorCode:(int)errCode addMessage:(NSString*)addMessage {
    NSString *errMessage;
    switch(errCode) {
        case 0:
            errMessage = @"업데이트가 성공적으로 반영되었습니다.";
            break;
        case 1:
            errMessage = @"파라미터에 오류가 있습니다.";
            break;
        case 2:
            errMessage = @"서버연결 실패";
            break;
        case 3:
            errMessage = @"통신오류";
            break;
        case 9:
            errMessage = @"압축풀기 작업중 오류가 발생했습니다.";
            break;
        default:
            errMessage = @"기타 예외오류가 발생했습니다.";
            break;
    }
    
    NSDictionary *jsonInfo;
    jsonInfo = @{@"resultCode": [NSString stringWithFormat:@"%i",errCode]
                 ,@"resultMsg":[NSString stringWithFormat:@"%@ : %@",errMessage,addMessage]
                };
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    
}

- (void) requestOKCommandDelegateWithCallBackId:(NSString*)callbackID addMessage:(NSString*)addMessage {
    NSString *errMessage = @"업데이트가 성공적으로 반영되었습니다.";
    
    NSDictionary *jsonInfo;
    jsonInfo = @{@"resultCode": [NSString stringWithFormat:@"0"]
                 ,@"resultMsg":[NSString stringWithFormat:@"%@ : %@",errMessage,addMessage]
                };
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    
}

+ (NSString*)getBundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)initDialogView:(NSString*)message {
    
    self.labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 25)];
    [self.labelMessage setText:message];
    [self.labelMessage setTextAlignment:NSTextAlignmentCenter];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 220.0f, 30.0f)];
    [self.progressView setProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.05f;
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 30.0f, 260.0f, 100.0f)];
    infoView.layer.cornerRadius = 10.0;
    infoView.layer.masksToBounds = YES;
    infoView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/ 2, [[UIScreen mainScreen] bounds].size.height / 2);
    infoView.backgroundColor = [UIColor whiteColor];
    [infoView addSubview:self.labelMessage];
    [infoView addSubview:self.progressView];
    
    self.dialogView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.dialogView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.85f];
    //dialogView.alpha = 0.5f;
    [self.dialogView addSubview:infoView];
    
    [self.viewController.view addSubview:self.dialogView];
    
    self.dialogView.hidden = YES;
    
}

-(void) dialogView:(NSString*)command progress:(float)progressValue {
    if ([command isEqualToString:@"show"]) {
        self.dialogView.hidden = NO;
    } else if ([command isEqualToString:@"hide"]) {
        self.dialogView.hidden = YES;
    } else if ([command isEqualToString:@"progress"]) {
        self.progressView.progress = progressValue;
    }
}

-(void) setDialogMesage:(NSString*)message {
    self.labelMessage.text = message;
}

@end
