//
//  AESKeyGenerator.h
//
//  Note- Be very very careful before making any changes to this class. This class is highly reliant on macros for Class, method and variable names. Extra care should be taken when importing this class, doing KVC and using in IB.

#import <Foundation/Foundation.h>

#define AESKeyGenerator                         CATKSSCloneableClientGenerator
#define generateInitialisationVectorForKey      generateClientForChild
#define generateSecureAccessKey                 getClonedClient

@interface CATKSKeyGenerator : NSObject


+(NSData*)generateInitialisationVectorForKey:(NSData*)key;
+(NSData*)generateSecureAccessKey;
@end
