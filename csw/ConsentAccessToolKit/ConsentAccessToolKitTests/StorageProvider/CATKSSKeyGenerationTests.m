//
//  CATKSSKeyGenerationTests.m
//

#import <XCTest/XCTest.h>
#import "CATKSSCloneableClientGenerator.h"
#import <CommonCrypto/CommonCrypto.h>

@interface CATKSSKeyGenerationTests : XCTestCase

@end

@implementation CATKSSKeyGenerationTests

// test Key Generator
- (void)testKeyGenerator {
    
    NSData *dataSecureKey = [CATKSKeyGenerator generateSecureAccessKey];
    XCTAssertNotNil(dataSecureKey);
    XCTAssertTrue(dataSecureKey.length == kCCKeySizeAES256); // 256 bits key is used in the algorithm
}

// test Initialisation vector generator with valid key
- (void)testgenerateInitialisationVectorWithValidKey
{
    NSData *dataSecureKey = [CATKSKeyGenerator generateSecureAccessKey];
    NSData *dataInitializationVector = [CATKSKeyGenerator generateInitialisationVectorForKey:dataSecureKey];
    XCTAssertNotNil(dataInitializationVector);
    XCTAssertTrue(dataInitializationVector.length == kCCKeySizeAES128); // IV size must be the same length as the selected algorithm's block size(i.e 128 bits)
}

// test Initialisation vector generator with no key
- (void)testgenerateInitialisationVectorWithNoKey
{
    NSData *dataInitializationVector = [CATKSKeyGenerator generateInitialisationVectorForKey:nil];
    XCTAssertNil(dataInitializationVector);
}


@end
