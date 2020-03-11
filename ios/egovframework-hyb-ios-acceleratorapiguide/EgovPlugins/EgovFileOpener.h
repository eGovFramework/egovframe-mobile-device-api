//
//  EgovFileOpener.h
//  DEVICEAPI
//
//  Created by sh.jang on 2016. 7. 12.
//
//
#import <Cordova/CDVPlugin.h>
#import "EGovComModule.h"

@interface EgovFileOpener : CDVPlugin
+ (NSString*)getBundleID;

- (void)fileDownload:(CDVInvokedUrlCommand *)command;

@property (nonatomic, retain) NSString* callbackID;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *streFileNm;
@property (nonatomic, retain) NSString *orignlFileNm;
@property (nonatomic, retain) NSString *targetPath;

@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIAlertView *progressAlert;
@property (nonatomic, retain) UIView *dialogView;
@property (nonatomic, retain) UILabel *labelMessage;

@property (nonatomic) long expectedContentLength;
@property (nonatomic) long downloadContentLength;

@end
