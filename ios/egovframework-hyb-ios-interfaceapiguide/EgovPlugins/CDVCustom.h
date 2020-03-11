//
//  CDVCustom.h
//  Device API eGovframework
//
//  Created by comghost on 2015. 3. 20..
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVCustom : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)getMessage:(CDVInvokedUrlCommand *)command;
- (void)runJavasScriptFuncion:(CDVInvokedUrlCommand *)command;

@end
