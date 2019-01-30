//
//  AISSLPinManager.h
//  AppInfra
//
//  Created by Anthony G on 24/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"

@interface AILSSLPublicKeyManager : NSObject

@property (nonatomic, weak) id<AIAppInfraProtocol> appInfra;

+ (instancetype)sharedSSLPublicKeyManager;

-(void)setPublicPinsInfo:(id<NSCoding>)pinsInfo forHostName:(NSString*)hostName
                   error:(NSError *_Nullable*_Nullable)error;

-(NSDictionary *)publicPinsInfoForHostName:(NSString*)hostName error:( NSError **)error;

- (void)logWithEventId:(NSString *)eventId message:(NSString *)message hostName:(NSString *)hostName;

+(NSArray *)extractPublicKeysFromText:(NSString *)publicKeyPinInfoStr;

+(NSString *)extractMaxAgeFromText:(NSString *)publicKeyPinInfoStr ;
@end
