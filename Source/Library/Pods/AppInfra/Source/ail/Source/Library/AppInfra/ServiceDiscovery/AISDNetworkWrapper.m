//
//  AISDNetworkWrapper.m
//  AppInfra
//
//  Created by leslie on 23/01/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AISDNetworkWrapper.h"
#import "AISDManager.h"
#import "AIInternalTaggingUtility.h"
#import "AIInternalLogger.h"
#define kpayload @"payload"
#define kErroMsg @"message"
#define kNErroMsg @"error_message"

#define kNetworkWrapper @"AISDNetwork"
@interface AISDNetworkWrapper()

@property(nonatomic, weak)id<AIAppInfraProtocol> aiAppInfra;

@end

@implementation AISDNetworkWrapper

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        
        self.aiAppInfra = appInfra;
    }
    return self;
}

-(void)serviceDiscoveryDataWithURL:(NSString *)URLString completionHandler: (void (^)( NSDictionary*  responseObject, NSError *  error))completionHandler
{
    if([self.aiAppInfra.RESTClient isInternetReachable])
    {
        
        [AIInternalLogger log:AILogLevelDebug eventId:kNetworkWrapper message:URLString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        [AIInternalLogger log:AILogLevelDebug eventId:kNetworkWrapper message:@"SD data download started"];
        
        NSURLSessionDataTask *task = [self.aiAppInfra.RESTClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if(response){
                [AIInternalLogger log:AILogLevelDebug eventId:kNetworkWrapper message:[NSString stringWithFormat:@"%@",response]];

            }
            
            if(responseObject)
            {
                NSDictionary * responseDict = (NSDictionary *)responseObject;
                NSDictionary *dictPayload = responseDict[kpayload];
                if(![dictPayload isKindOfClass:[NSNull class]] && dictPayload.count>0)
                {
                    [AIInternalTaggingUtility tagSuccess:kNetworkWrapper infoMessageFormat:@"%@ - %d",kAilTagDownloadCompleted,((NSHTTPURLResponse*)response).statusCode];
                    completionHandler(responseDict,error);
                }
                else
                {
                    NSString *message = @"Invalid response from server";
                    if (responseDict && [responseDict[kErroMsg] isKindOfClass:[NSString class]] ) {
                        message = responseDict[kErroMsg];
                    }
                    else if (responseDict && [responseDict[kNErroMsg] isKindOfClass:[NSString class]] ) {
                        message = responseDict[kNErroMsg];
                    }
                    NSError * customError = [AISDManager getSDError:AISDServerError];
                    [AIInternalTaggingUtility tagError:customError errorCategory:kNetworkWrapper errorMessageFormat:kAilTagDownloadError];

                    [AIInternalLogger log:AILogLevelError eventId:kNetworkWrapper message:[NSString stringWithFormat:@"%@",customError.localizedDescription]];
                    completionHandler(nil ,customError);
                }
            }
            else
            {
                [AIInternalTaggingUtility tagError:error errorCategory:kNetworkWrapper errorMessageFormat:kAilTagDownloadError];
                completionHandler(nil ,error);
            }
        }];
        [task resume];
    }
    else
    {
        NSError *error = [AISDManager getSDError:AISDNoNetworkError];
        [AIInternalTaggingUtility tagError:error errorCategory:kNetworkWrapper errorMessageFormat:kAilTagNotReachable];
        completionHandler(nil,error);
    }
    
    
    
}

@end
