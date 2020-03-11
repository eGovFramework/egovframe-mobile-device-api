//
//  EgovDeivceInfo.h
//  DeviceAPIGuide_iOS_V1.9
//
//  Created by junsik seo on 7/31/12.
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDVPlugin.h>

@interface EgovStorageInfo : CDVPlugin
{
    NSString* callbackID;
}
@property (nonatomic, copy) NSString* callbackID;

@end
