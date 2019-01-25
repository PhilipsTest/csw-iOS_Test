#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AppInfra.h"
#import "AIAppInfra.h"
#import "AILoggingProtocol.h"
#import "AIAppTaggingProtocol.h"
#import "AIAppInfraProtocol.h"
#import "AIAppIdentityProtocol.h"
#import "AIServiceDiscoveryProtocol.h"
#import "AIAppInfraBuilder.h"
#import "AITimeProtocol.h"
#import "AIStorageProviderProtocol.h"
#import "AIInternationalizationProtocol.h"
#import "AIAppConfigurationProtocol.h"
#import "AISDService.h"
#import "AIRESTClientProtocol.h"
#import "AIRESTClientURLResponseSerialization.h"
#import "AIABTestProtocol.h"
#import "AIAPISigningProtocol.h"
#import "AIClonableClient.h"
#import "AIComponentVersionInfoProtocol.h"
#import "AILanguagePackProtocol.h"
#import "AIAppUpdateProtocol.h"
#import "AICloudApiSigner.h"

FOUNDATION_EXPORT double AppInfraVersionNumber;
FOUNDATION_EXPORT const unsigned char AppInfraVersionString[];

