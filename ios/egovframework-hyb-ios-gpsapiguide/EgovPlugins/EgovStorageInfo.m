//
//  EgovDeivceInfo.m
//  DeviceAPIGuide_iOS_V1.9
//
//  Created by junsik seo on 7/31/12.
//

#import "EgovStorageInfo.h"

@implementation EgovStorageInfo

@synthesize callbackID;

//- (void)fileSystemSize:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
- (void)fileSystemSize:(CDVInvokedUrlCommand*)command;
{
    NSLog(@"storageInfo called : ");

    self.callbackID = command.callbackId;
    NSLog(@"callbackID : %@", self.callbackID);
    

    uint64_t totalSystemSpace = 0.0f;
    uint64_t totalSystemFreeSpace = 0.0f;
    NSError *error = nil;  
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];  
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        
        totalSystemSpace = [fileSystemSizeInBytes floatValue];
        totalSystemFreeSpace = [freeFileSystemSizeInBytes floatValue];
        
        NSString *totalSpace = [NSString stringWithFormat:@"%llu", ((totalSystemSpace/1024ll)/1024ll)];
        NSString *freeSpace = [NSString stringWithFormat:@"%llu", ((totalSystemFreeSpace/1024ll)/1024ll)];
        
        NSLog(@"totalSpace : %@", totalSpace);
        NSLog(@"freeSpace : %@", freeSpace);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:totalSpace, @"totalSpace", freeSpace, @"freeSpace", nil];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        
        ////[self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        //[self.commandDelegate evalJs:@"alert('foo')"];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:[[NSString stringWithFormat:@"fail to create filemanager."] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ////[self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        //[self.commandDelegate evalJs:@"alert('foo')"];
    }
}
@end
