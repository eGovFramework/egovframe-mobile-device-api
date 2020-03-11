//
//  EGovComModule.m
//  NetworkAPIGuide_iOS
//
//  Created by han chul lee on 12. 6. 29..
//  Copyright (c) 2012년 einslib@naver.com. All rights reserved.
//

#import "EGovComModule.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"

@interface EGovComModule()
{
    Reachability* internetReach;
    Reachability* wifiReach;
    NSInteger m_timeOutSeconds;
}
@property(nonatomic, assign) id<EGovDelegate> m_delegate;
@property(nonatomic, copy) NSString *m_url;
@property(nonatomic, retain) NSMutableDictionary *m_fileDictionary;
@property(nonatomic, retain) NSMutableDictionary *m_postDictionary;
@end

@implementation EGovComModule

@synthesize m_delegate;
@synthesize m_url;
@synthesize m_fileDictionary, m_postDictionary;

#pragma mark - class cycle
- (id)initWithURL:(NSString*)url delegate:(id)delegate
{
    self = [super init];
    if (self) 
	{
        self.m_url = url;
        self.m_delegate = delegate;
        m_timeOutSeconds = 10;
        
        m_fileDictionary = [NSMutableDictionary new];
        m_postDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void) dealloc
{
    self.m_fileDictionary = nil;
    self.m_postDictionary = nil;
    self.m_url = nil;
	[super dealloc];
}

#pragma mark - user method
- (BOOL)setURL:(NSString*)url
{
    if (!self) {
        return NO;
    }
    self.m_url = url;
    return YES;
}

- (BOOL)setTimeOutSeconds:(NSInteger)times
{
    if (!self) {
        return NO;
    }
    m_timeOutSeconds = times;
    return YES;
}

- (BOOL)addFile:(NSString*)file key:(NSString*)key
{
    if (!self) {
        return NO;
    }
    NSMutableArray *array = [m_fileDictionary objectForKey:key];
    if (!array) {
        array = [NSMutableArray arrayWithObject:file];
    } else {
        [array addObject:file];
    }
    [m_fileDictionary setObject:array forKey:key];
    return YES;
}

- (BOOL)addPost:(NSString*)post key:(NSString*)key
{
    if (!self) {
        return NO;
    }
    NSMutableArray *array = [m_postDictionary objectForKey:key];
    if (!array) {
        array = [NSMutableArray arrayWithObject:post];
    } else {
        [array addObject:post];
    }
    [m_postDictionary setObject:array forKey:key];
    return YES;
}

- (void)startAsynchronous
{
    if (!m_url || [m_url isEqualToString:@""]) {
        if ([self.m_delegate respondsToSelector:@selector(onNetworkFailed:)]) 
            [self.m_delegate onNetworkFailed:nil];
        return;
    }
    //TODO 설정값들 체크할 것!!!!
    NSString *Encodingurl = [m_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *_url = [NSURL URLWithString:Encodingurl];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:_url];
	[ASIFormDataRequest setDefaultCache:[ASIDownloadCache sharedCache]];
	[request addRequestHeader:@"User-Agent" value:@"eGovFrame"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml;charset=utf-8;"];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setTimeOutSeconds:m_timeOutSeconds];
    NSArray *array = [m_fileDictionary allKeys];
    for (NSString *keyName in array) {
        NSArray *arr = [m_fileDictionary objectForKey:keyName];
        for (NSString *filePath in arr) {
            [request setFile:filePath forKey:keyName];
        }
    }
    array = [m_postDictionary allKeys];
    for (NSString *keyName in array) {
        NSArray *arr = [m_postDictionary objectForKey:keyName];
        for (NSString *postValue in arr) {
            [request setPostValue:postValue forKey:keyName];
        }
    }
    if ([self.m_delegate respondsToSelector:@selector(onNetworkStarted)]) 
        [self.m_delegate onNetworkStarted];
    [request setCompletionBlock:^{
        //        NSData *responseData = [request responseData];// Use when fetching binary data
        if ([self.m_delegate respondsToSelector:@selector(onNetworkFinished:responseString:responseStatusCode:)]) 
            [self.m_delegate onNetworkFinished:request.responseData responseString:request.responseString responseStatusCode:request.responseStatusCode];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error : %@", error);
        if ([self.m_delegate respondsToSelector:@selector(onNetworkFailed:)]) 
            [self.m_delegate onNetworkFailed:request.error];
    }];
    [request startAsynchronous];
}

@end
