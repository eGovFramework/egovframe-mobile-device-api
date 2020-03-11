//
//  TestPlugin.m
//  NetworkAPIGuide_iOS
//
//  Created by han chul lee on 12. 6. 29..
//  Copyright (c) 2012년 einslib@naver.com. All rights reserved.
//

#import "EgovInterface.h"

@interface EgovInterface()
{
}
@property(nonatomic, retain) NSString *m_arguments;
@property(nonatomic, retain) NSMutableDictionary *m_params;
@end

@implementation EgovInterface

@synthesize callbackID;
@synthesize m_arguments, m_params;

#pragma mark - plugin method

- (void)echo:(CDVInvokedUrlCommand*)command
{
    NSString *message = [command.arguments objectAtIndex:0];
    [[[UIAlertView alloc] initWithTitle:@"iOS검색" message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil] show];
}

//- (void)submitAsynchronous:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
- (void)submitAsynchronous:(CDVInvokedUrlCommand*)command;
{
    NSString *arguments = [command.arguments objectAtIndex:1];
    NSMutableDictionary *params = [command.arguments objectAtIndex:0];
    self.callbackID = command.callbackId;
    
    self.m_arguments = arguments;
    self.m_params = params;
    NSLog(@"arguments : %@", arguments);
    NSLog(@"options : %@", params);

    //NSString *subUrl = @"";
    //if (arguments.count > 0) {
    //    subUrl = [arguments objectAtIndex:1];
    //}
    
    EGovComModule *m_module = [[EGovComModule alloc] initWithURL:[NSString stringWithFormat:@"%@%@", kSERVER_URL, arguments] delegate:self];
    
    //NSArray *array = [options allKeys];
    for (NSString *str in params) {
        NSString *value = [params objectForKey:str];
        [m_module addPost:value key:str];
    }
    
    [m_module startAsynchronous];
}

- (void)geturl:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:kSERVER_URL];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

#pragma mark - EGovModuleDelegate
- (void)onNetworkStarted
{
    NSLog(@"network started");
}

- (void)onNetworkFailed:(NSError*)error
{
    NSLog(@"network failed");
    NSLog(@"error : %@", error);
    //self.callbackID = m_arguments; //[m_arguments pop];
    
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"StringReceived:"];
    
    [stringToReturn appendString:[NSString stringWithFormat:@"%@", error.description]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:[stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //[self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
    //[self.commandDelegate evalJs: [pluginResult toSuccessCallbackString:callbackId]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
    
    //[self.commandDelegate evalJs:@"alert('foo')"];
}

- (void)onNetworkFinished:(NSData*)responseData responseString:(NSString*)responseString responseStatusCode:(NSInteger)responseStatusCode
{
    NSLog(@"network finished!");
    NSLog(@"network finished! reseponse : %@", responseString);
    NSLog(@"responseStatusCode : %d", responseStatusCode);
    
    //self.callbackID = m_arguments; //[m_arguments pop];
    NSLog(@"callbackID : %@", self.callbackID);
    
    if (responseStatusCode == kSERVER_OK) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        
        ////[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
        
        //[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
        //[self.commandDelegate evalJs: [pluginResult toSuccessCallbackString:self.callbackID]];
        //[self.commandDelegate evalJs:@"alert('foo')"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:[[NSString stringWithFormat:@"%d", responseStatusCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ////[self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        
        //[self.commandDelegate evalJs:@"alert('foo')"];
    }
}

@end
