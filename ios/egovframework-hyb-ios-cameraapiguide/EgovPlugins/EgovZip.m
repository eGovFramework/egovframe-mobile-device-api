//
//  EgovZip.m
//  DEVICEAPI
//
//  Created by shin yongho on 2016. 6. 24..
//
//

#import "EgovZip.h"

@implementation EgovZip

/*
 * return 1 = SUCCESS
 * return 0 = FAIL
 */
+ (BOOL) doUnZipFileAtPath:(NSString*)zipFilePath toDestination:(NSString*)destinationPath {
    
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentDir = [paths objectAtIndex:0];
    //NSLog(@">>> %@", documentDir);
    
    //NSString *myZipDir = [documentDir stringByAppendingString:@"/test3.zip"];
    //NSString *myTarDir = [documentDir stringByAppendingString:@"/www"];
    //NSLog(@">>> myZipDir = %@", myZipDir);
    //NSLog(@">>> myTarDir = %@", myTarDir);
    
    BOOL ret = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:destinationPath];
    //NSLog(@"unzip result = %hhd",ret);
    NSLog(@"unzip result =: %@", (ret ? @"YES": @"NO"));
    return ret;
    
}

- (void) unzip:(CDVInvokedUrlCommand *)command {
    
    NSURL *sourcePath = [NSURL URLWithString:[command.arguments objectAtIndex:0]];
    NSURL *targetDir = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    self.callbackID = command.callbackId;
    
    NSLog(@"sourcePath : %@", sourcePath.path);
    NSLog(@"targetDir : %@", targetDir.path);
    
    BOOL ret = [SSZipArchive unzipFileAtPath:sourcePath.path toDestination:targetDir.path];
    NSLog(@"zip result =: %@", (ret ? @"YES": @"NO"));
    
    if (ret==YES) { // 성공
        // Cordova 콜백 처리
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:nil];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        
    } else { // 오류
        // Cordova 콜백 처리
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:nil];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
    }
    
}

- (void) zip:(CDVInvokedUrlCommand *)command {
    
    NSURL *sourcePath = [NSURL URLWithString:[command.arguments objectAtIndex:0]];
    NSURL *targetDir = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    self.callbackID = command.callbackId;
    
    NSLog(@"sourcePath : %@", sourcePath.path);
    NSLog(@"targetDir : %@", targetDir.path);
    
    BOOL ret = [SSZipArchive createZipFileAtPath:targetDir.path withContentsOfDirectory:sourcePath.path];
    NSLog(@"Unzip result =: %@", (ret ? @"YES": @"NO"));
    //NSLog(@"Unzip result = %hhd",ret);
    //return ret;
    
    if (ret==YES) { // 성공
        // Cordova 콜백 처리
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:nil];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
        
    } else { // 오류
        // Cordova 콜백 처리
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:nil];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
    }
    
}
@end
