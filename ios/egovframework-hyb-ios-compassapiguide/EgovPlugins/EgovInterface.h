//
//  TestPlugin.h
//  NetworkAPIGuide_iOS
//
//  Created by han chul lee on 12. 6. 29..
//  Copyright (c) 2012년 einslib@naver.com. All rights reserved.
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDVPlugin.h>
#import "EGovComModule.h"

@interface EgovInterface : CDVPlugin<EGovDelegate>
{
    NSString* callbackID;
}
@property (nonatomic, copy) NSString* callbackID;

//- (void)submitAsynchronous:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)submitAsynchronous:(CDVInvokedUrlCommand*)command;
- (void)echo:(CDVInvokedUrlCommand*)command;

- (void)geturl:(CDVInvokedUrlCommand *)command;


@end
