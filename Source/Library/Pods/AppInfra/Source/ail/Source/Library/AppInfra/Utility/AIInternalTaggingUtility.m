//
//  AIInternalTaggingUtility.m
//  AppInfra
//
//  Created by Hashim MH on 07/02/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIInternalTaggingUtility.h"
#import "AppInfra.h"

@implementation AIInternalTaggingUtility
static id<AIAppTaggingProtocol> sharedTagging = nil;

+ (void)setSharedTagging:(id<AIAppTaggingProtocol>)tagInstance {
    @synchronized(self) {
        sharedTagging = tagInstance;
    }
}


+ (void)resetSharedTagging {
    @synchronized(self) {
        sharedTagging = nil;
    }
}


+ (void)tagError:(NSError *)error
   errorCategory:(NSString *)errorCategory
    errorMessage:(NSString *)errorMessage {
    
    NSMutableString *errorDetails = [[NSMutableString alloc]init];
    [errorDetails appendString:@"AIL"];
    [errorDetails appendFormat:@":%@",errorCategory?errorCategory:@"NA"];
    if (error){
        [errorDetails appendFormat:@":%@",errorMessage];
        [errorDetails appendFormat:@":%ld",(long)error.code];
        NSAssert(sharedTagging, @"Appinfra tagging not initialized");
        dispatch_async(dispatch_get_main_queue(), ^{
            [sharedTagging trackActionWithInfo:kAilSendData params:@{kAilTechnicalError:errorDetails}];
        });
    }
}


+ (void)tagError:(NSError *)error
   errorCategory:(NSString *)errorCategory
errorMessageFormat:(NSString *)format, ... {
    if (format) {
        va_list args;
        va_start(args, format);
        NSString *contents = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        [AIInternalTaggingUtility tagError:error
                             errorCategory:errorCategory
                              errorMessage:contents ];
    } else {
        [AIInternalTaggingUtility tagError:error
                             errorCategory:errorCategory
                              errorMessage:@"NA" ];
    }
}


+ (void)tagError:(NSError *)error
   errorCategory:(NSString *)errorCategory
errorMessageFormat:(NSString *)format
            args:(va_list)args {
    if (format) {
        NSString *contents = [[NSString alloc] initWithFormat:format arguments:args];
        [AIInternalTaggingUtility tagError:error
                             errorCategory:errorCategory
                              errorMessage:contents];
    } else {
        NSString *contents = contents = [[NSString alloc] initWithFormat:format arguments:args];
        [AIInternalTaggingUtility tagError:error
                             errorCategory:errorCategory
                              errorMessage:@"NA"];
    }
}


+(void)tagSuccess:(NSString *)infoCategory
      infoMessage:(NSString *)message {
    NSAssert(sharedTagging, @"Appinfra tagging not initialized");
    NSMutableString *infoDetails = [[NSMutableString alloc]init];
    [infoDetails appendString:infoCategory?infoCategory:@"NA"];
    [infoDetails appendString:@":"];
    [infoDetails appendString:message?message:@"NA"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [sharedTagging trackActionWithInfo:kAilSendData params:@{kAilSuccessMessage:infoDetails}];
    });
}


+ (void)tagSuccess:(NSString *)infoCategory
 infoMessageFormat:(NSString *)format, ... {
    if (format){
        va_list args;
        va_start(args, format);
        NSString *contents = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        [AIInternalTaggingUtility tagSuccess:infoCategory  infoMessage:contents ];
    }
    else{
        [AIInternalTaggingUtility tagSuccess:infoCategory infoMessage:@"NA"];
    }
}

@end
