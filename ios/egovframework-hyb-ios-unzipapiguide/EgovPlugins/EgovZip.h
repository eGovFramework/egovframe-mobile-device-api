//
//  EgovZip.h
//  DEVICEAPI
//
//  Created by shin yongho on 2016. 6. 24..
//
//

#import <Cordova/CDVPlugin.h>
#import "SSZipArchive.h"

@interface EgovZip : CDVPlugin
+ (BOOL) doUnZipFileAtPath:(NSString*)zipFilePath toDestination:(NSString*)destinationPath;

- (void) zip:(CDVInvokedUrlCommand *)command;
- (void) unzip:(CDVInvokedUrlCommand *)command;

@property (nonatomic, retain) NSString* callbackID;

@end
