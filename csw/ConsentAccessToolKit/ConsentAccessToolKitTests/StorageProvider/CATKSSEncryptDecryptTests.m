//
//  CATKSSEncryptDecryptTests.m
//

#import <XCTest/XCTest.h>
#import "NSData+CATKSSStatementParser.h"
#import "CATKSSKeychainService.h"
#import "CATKSSUtility.h"
#import <CommonCrypto/CommonCrypto.h>
#import "CATKSSCloneableClientGenerator.h"

#define KEYCHAIN_ACCESS_KEY        @"KEYCHAIN-STORAGE-KEY"
#define KEYCHAIN_TOKEN_TYPE        @"keychain_storage_token_type"

@interface CATKSSEncryptDecryptTests : XCTestCase

@end

@implementation CATKSSEncryptDecryptTests

// test Encryption with data and key
- (void)testEncryptionWithValidKey {
    
    NSString *strData = @"test Data to be encrypted";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secureAccessKey= [CATKSKeyGenerator generateSecureAccessKey];
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey] error:nil];
    
   XCTAssertNotEqualObjects(data, encryptedData);
}

// test Encryption with No data and a key
- (void)testEncryptionWithNoData {
    
    NSData *data = nil;
    NSData *secureAccessKey= [CATKSKeyGenerator generateSecureAccessKey];

    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey] error:nil];

    
    XCTAssertNil(encryptedData);
}

// test Encryption with data and No key
- (void)testEncryptionWithNoKey {
    
    NSString *strData = @"test Data to be encrypted";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secureAccessKey= nil;
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey]error:nil];
    
    XCTAssertNil(encryptedData);
}
// test Encryption with data and No key
- (void)testEncryptionWithNoDataNoKey {
    
    NSData *data = nil;
    NSData *secureAccessKey= nil;
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey]error:nil];
    XCTAssertNil(encryptedData);
}

// test Decryption with a valid key
- (void)testDecryptionWithValidKey {
    
    NSString *strData = @"test Data to be encrypted";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secureAccessKey= [CATKSKeyGenerator generateSecureAccessKey];
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey]error:nil];
    NSData *decryptedData = [encryptedData AES256DecryptWithKey:secureAccessKey error:nil];
    XCTAssertEqualObjects(data, decryptedData);
}

// test Decryption with an invalid key
- (void)testDecryptionWithInValidKey {
    
    NSString *strData = @"test Data to be encrypted";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secureAccessKey= [CATKSKeyGenerator generateSecureAccessKey];
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[CATKSKeyGenerator generateInitialisationVectorForKey:secureAccessKey]error:nil];
    
    NSString *strInvalidKey = @"Some invalid Key";
    NSData *dataInvalidKey = [strInvalidKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [encryptedData AES256DecryptWithKey:dataInvalidKey error:nil];
    XCTAssertNotEqualObjects(data, decryptedData);
}



@end
