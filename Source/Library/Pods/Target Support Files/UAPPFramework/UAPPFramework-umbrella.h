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

#import "UAPPDependencies.h"
#import "UAPPFramework.h"
#import "UAPPLaunchInput.h"
#import "UAPPProtocol.h"
#import "UAPPSettings.h"

FOUNDATION_EXPORT double UAPPFrameworkVersionNumber;
FOUNDATION_EXPORT const unsigned char UAPPFrameworkVersionString[];

