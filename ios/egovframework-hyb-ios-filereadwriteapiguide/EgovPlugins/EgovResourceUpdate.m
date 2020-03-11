//
//  EgovResUpdate.m
//  DEVICEAPI
//
//  Created by shin yongho on 2016. 6. 24..
//
//

#import "EgovResourceUpdate.h"

@implementation EgovResourceUpdate

- (void)getAppId:(CDVInvokedUrlCommand *)command {
    
    NSString *appId = [EgovResourceUpdate getBundleID];
    
    NSDictionary *jsonInfo;
    jsonInfo = @{@"appId": appId};
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAppVersion:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSDictionary *jsonInfo;
    jsonInfo = @{@"appVersion": appVersion, @"buildVersion": buildVersion};
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getResourceVersion:(CDVInvokedUrlCommand *)command {
    
    NSString *resVersion = [EgovResourceUpdate loadFromUserDefaults:@"resVersion"];
    if (resVersion==nil || [resVersion isKindOfClass:[NSNull class]]) {
        resVersion = @"1.0.1";
        self.resVersion = resVersion;
        [EgovResourceUpdate saveToUserDefaults:self.resVersion forKey:@"resVersion"];
        
    }
    
    NSString *resDistDt = [EgovResourceUpdate loadFromUserDefaults:@"resDistDt"];
    NSString *resInstallDt = [EgovResourceUpdate loadFromUserDefaults:@"resInstallDt"];
    
    NSDictionary *jsonInfo;
    //jsonInfo = @{@"resVersion": resVersion};
    
    jsonInfo = @{@"resVersion": [NSString stringWithFormat:@"%@",resVersion]
                 ,@"resDistDt": [NSString stringWithFormat:@"%@",resDistDt]
                 ,@"resInstallDt": [NSString stringWithFormat:@"%@",resInstallDt]
                 };
    
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)update:(CDVInvokedUrlCommand *)command {
    
    NSString *url = [command.arguments objectAtIndex:1];
    NSMutableDictionary *params = [command.arguments objectAtIndex:0];
    self.callbackID = command.callbackId;
    
    NSLog(@"url : %@", url);
    NSLog(@"options : %@", params);
    
    NSString *streFileNm = [params objectForKey:@"streFileNm"];
    NSString *orignlFileNm = [params objectForKey:@"orignlFileNm"];
    NSString *targetPath = [params objectForKey:@"targetPath"];
    
    self.resLastestVersion = [params objectForKey:@"resLastestVersion"];
    self.resVersionUpdDt = [params objectForKey:@"resVersionUpdDt"];
    self.resVersion = [params objectForKey:@"resVersion"];
    
    NSLog(@"streFileNm : %@", streFileNm);
    NSLog(@"orignlFileNm : %@", orignlFileNm);
    NSLog(@"targetPath : %@", targetPath);
    NSLog(@"resLastestVersion : %@", self.resLastestVersion);
    NSLog(@"resVersionUpdDt : %@", self.resVersionUpdDt);
    
    NSString *downloadAssetFileUrl;
    
    NSArray *pa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFilePath = [pa objectAtIndex:0];
    
    NSLog(@">>> documentFilePath %@",documentFilePath);
    
    //NSString *downloadLocalPath = [documentFilePath stringByAppendingPathComponent:@"test.zip"];
    NSString *downloadLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:orignlFileNm];
    
    if (targetPath==nil || [targetPath isKindOfClass:[NSNull class]]) {
        NSLog(@"targetPath is null");
        targetPath = [documentFilePath stringByAppendingPathComponent:@"/www"];
    } else {
        NSLog(@"targetPath OK <%@>",targetPath);
    }
    
    if (url==nil || [url isKindOfClass:[NSNull class]]) {
        //downloadAssetFileUrl = @"http://192.168.100.120:8080/Template-DeviceAPI-Total_Web/upd/ResourceUpdatefileDownload.do?streFileNm=AAA&orignlFileNm=BBB";
        NSLog(@"ERROR : url param is null");
        NSLog(@"Connection Fail!!!");
        
        // Cordova 콜백 처리
        [self requestCommandDelegateWithCallBackId:self.callbackID errorCode:1 addMessage:@" (URL)"];
        
        // 에러처리
    } else {
        downloadAssetFileUrl = [NSString stringWithFormat:@"%@%@", kSERVER_URL, url];
        NSLog(@"downloadAssetFileUrl : %@", downloadAssetFileUrl);
    }
    
    
    //프로그레스바 생성 및 화면에 보여줌
    [self initDialogView:@"리소스 파일을 다운로드 중입니다."];
    [self dialogView:@"show" progress:0];
    /*
     self.progressAlert = [[UIAlertView alloc] initWithTitle:@"Please wait..."
     message:@"리소스 파일을 다운로드 중입니다."
     delegate:self cancelButtonTitle:nil
     otherButtonTitles:nil];
     self.progressAlert.tag = 12;
     self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
     [self.progressAlert addSubview:self.progressView];
     [self.progressView setProgressViewStyle:UIProgressViewStyleBar];
     [self.progressAlert show];
     //self.progressView.progress = .5f;
     */
    
    
    [self UpdateZipAssetFileAtUrl:downloadAssetFileUrl downloadLocalPath:downloadLocalPath toUnzipPath:targetPath];
    
}


- (BOOL) UpdateZipAssetFileAtUrl:(NSString*)updateFileUrl downloadLocalPath:(NSString*)downloadLocalPath toUnzipPath:(NSString*)unzipPath
{
    self.fileDownloadLocalPath = downloadLocalPath;
    self.fileUnzipPath = unzipPath;
    
    NSLog(@">>> download UPDATEFILE from URL = %@",updateFileUrl);
    /*NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.100.120:8080/Template-DeviceAPI-Total_Web/upd/ResourceUpdatefileDownload.do?orignlFileNm=UPDATE_IMAGE_20160626.zip&streFileNm=FILE_201606301111.zip"]
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:60.0];
     */
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
        
        // Cordova 콜백 처리
        [self requestCommandDelegateWithCallBackId:self.callbackID errorCode:2 addMessage:@" (URL)"];
        
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
    
    // Cordova 콜백 처리
    [self requestCommandDelegateWithCallBackId:self.callbackID errorCode:3 addMessage:[error localizedDescription]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    //NSString *fileInfo= [NSString stringWithFormat:@"Succeeded! Received %lu bytes of data",(unsigned long)[_receivedData length]];
    //[self performSelectorOnMainThread:@selector(log:) withObject:fileInfo waitUntilDone:YES];
    
    
    NSLog(@"download Finish");
    [_receivedData writeToFile:self.fileDownloadLocalPath atomically:YES];
    
    BOOL ret = [EgovZip doUnZipFileAtPath:self.fileDownloadLocalPath toDestination:self.fileUnzipPath];
    NSLog(@">>> unzip ret %hhd",ret);
    
    if (ret==YES) { // 성공
        
        
        
        //[EgovResourceUpdate saveToUserDefaults:self.resVersion forKey:@"resVersion"];
        [EgovResourceUpdate saveToUserDefaults:self.resLastestVersion forKey:@"resVersion"];
        NSLog(@"save resLastestVersion >>> %@",self.resLastestVersion);
        
        [EgovResourceUpdate saveToUserDefaults:self.resVersionUpdDt forKey:@"resDistDt"];
        NSLog(@"save resVersionUpdDt >>> %@",self.resVersionUpdDt);
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@">>> resInstallDt : %@",[dateFormatter stringFromDate:[NSDate date]]);
        
        [EgovResourceUpdate saveToUserDefaults:[dateFormatter stringFromDate:[NSDate date]] forKey:@"resInstallDt"];
        
        // Cordova 콜백 처리
        [self requestCommandDelegateWithCallBackId:self.callbackID errorCode:0 addMessage:@""];
        
    } else { // 압축풀기 오류
        
        // Cordova 콜백 처리
        [self requestCommandDelegateWithCallBackId:self.callbackID errorCode:9 addMessage:@""];
        
    }
    
    //self.progressAlert.message = @"OK";
    //[self.progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self dialogView:@"hide" progress:0];
    
    // release the connection, and the data object
    //[connection release];
    //[_receivedData release];
}

- (void) requestCommandDelegateWithCallBackId:(NSString*)callbackID errorCode:(int)errCode addMessage:(NSString*)addMessage {
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
            errMessage = @"통신오류 : ";
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
                 ,@"resultMsg":[NSString stringWithFormat:@"%@%@",errMessage,addMessage]
                 ,@"resVersion":[NSString stringWithFormat:@"%@",[EgovResourceUpdate loadFromUserDefaults:@"resVersion"]]
                 ,@"resDistDt":[NSString stringWithFormat:@"%@",[EgovResourceUpdate loadFromUserDefaults:@"resDistDt"]]
                 ,@"resInstallDt":[NSString stringWithFormat:@"%@",[EgovResourceUpdate loadFromUserDefaults:@"resInstallDt"]]
                 };
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    
}

+ (NSString*)getBundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+(id) loadFromUserDefaults:(id)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id returnVals =nil;
    if (userDefaults && key) {
        returnVals = [userDefaults objectForKey:key];
    }
    return returnVals;
}

+(BOOL) saveToUserDefaults:(id)object forKey:(id)key {
    BOOL returnVal = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    @synchronized(userDefaults) {
        if (userDefaults && key && object) {
            [userDefaults setObject:object forKey:key];
        } else {
            [userDefaults removeObjectForKey:key];
        }
        returnVal = [userDefaults synchronize];
    }
    return returnVal;
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
