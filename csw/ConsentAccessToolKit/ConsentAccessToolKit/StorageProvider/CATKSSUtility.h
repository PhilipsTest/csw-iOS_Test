//
//  CATKSSUtility.h
//

#import <Foundation/Foundation.h>

#define kErrorDomainCATKSecureStorage         @"com.philips.platform.catk.SecureStorage"
#define kErrorDomainCATKDataParsing           @"com.philips.platform.catk.DataParsing"
#define kErrorDescriptionEmptyKey           @"Key provided is nil"
#define kErrorDescriptionAccessKey          @"Access Key failure"
#define kErrorDescriptionInvalidParam       @"NullData"
#define kErrorDescriptionEmptyData          @"No data found for the key provided"
#define kErrorDescriptionUnarchive          @"Unarchiving decrypted data failed"
#define kErrorDescriptionDecryptionFailure  @"Data decryption failed"
#define kErrorDescriptionEncryptionFailure  @"Data Encryption failed"
#define kErrorDescriptionArchive            @"Archiving data failed"
#define kErrorDescriptionEmptyDataParsing   @"No data is passed for parsing"
#define kErrorDescriptionDataParsing        @"Parsing data failed"

@interface CATKSSUtility : NSObject

// method to get the service name
+ (NSString *)serviceNameForTokenName:(NSString *)tokenName;

@end
