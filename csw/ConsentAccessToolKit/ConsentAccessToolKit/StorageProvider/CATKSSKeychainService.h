//
//  CATKSSKeychainService.h
//


#import <Foundation/Foundation.h>

@interface CATKSSKeychainService : NSObject
// method to store the key securely
+ (BOOL)storeValue:(NSData *)value forKey:(NSString *)key andTokenType:(NSString *)tokenType;
// method to fetch the secure key
+ (NSData *)getValueForTokenType:(NSString *)tokenType andKey:(NSString *)key error:(NSError **)error;
// method to delete the secure key
+ (BOOL)deleteValueForKey:(NSString *)key andtokenType: (NSString *)tokenType error: (NSError **) error;
@end
