//
//  secUtility.m
//  App Infra
//
//  Created by Abhinav Jha on 5/5/15.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "CATKSSUtility.h"

#define CATKSSCaptureKeychainIdentifier @"capture_tokens_CATK"


@implementation CATKSSUtility

// method to get the service name
+ (NSString *)serviceNameForTokenName:(NSString *)tokenName
{
    return [NSString stringWithFormat:@"%@.%@.%@.", CATKSSCaptureKeychainIdentifier, tokenName,
            appBundleIdentifier()];
}

// method to fetch the bundle name
static NSString*appBundleIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle bundleForClass:[CATKSSUtility class]] infoDictionary];
    NSString *identifier = [infoPlist objectForKey:@"CFBundleIdentifier"];
    return identifier;
}


@end

