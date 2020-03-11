//
//  CDVCustom.m
//  Device API eGovframework
//
//  Created by comghost on 2015. 3. 20..
//  Modified by 신용호 on 2016. 5. 9.
//
//

#import "CDVCustom.h"

@implementation CDVCustom

- (void)echo:(CDVInvokedUrlCommand*)command
{
    NSString *message = [command.arguments objectAtIndex:0];
    [[[UIAlertView alloc] initWithTitle:@"iOS eGovframe" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

- (void)getMessage:(CDVInvokedUrlCommand *)command
{
    
    [self.commandDelegate runInBackground:^{
        
        NSDictionary *jsonInfo = @{@"name": @"iOS native에서 생성된 메세지"};
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: jsonInfo];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

- (void)runJavasScriptFuncion:(CDVInvokedUrlCommand *)command
{
    NSDictionary *jsonInfo = @{@"name": @"iOS native에서 자바스크립트 함수 호출"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:&error];
    CDVPluginResult *pluginResult = nil;
    
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *javaScriptString = [NSString stringWithFormat:@"print_message(%@)", jsonString];
        
        // Cordova 6.x에서 stringByEvaluatingJavaScriptFromString 삭제 됨
        //[self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        [self.commandDelegate evalJs:javaScriptString];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}


@end
