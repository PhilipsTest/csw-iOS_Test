import Foundation
@testable import ConsentAccessToolKit

enum CATKSecureStorageMockOutputType: Int {
    case postSuccess
    case postError
    case fetchMockError
}

public class CATKSecureStorageMock: NSObject {
    var removeValueKey : String?
    var mockSecureStorageOutputType: CATKSecureStorageMockOutputType = .postSuccess
    var consentData: [String:NSCoding] = [:]
    
    func flushAllConsentData() {
        consentData.removeAll()
    }
}

extension CATKSecureStorageMock: CATKStorageProviderProtocol {
    
    public func removeValue(forKey key: String) {
        self.removeValueKey = key
    }
    
    public func loadData(_ data: NSCoding) throws -> Data { return Data() }
    
    public func parseData(_ data: Data) throws -> Any { return false }
    
    public func deviceHasPasscode() -> Bool { return false }
    
    public func getDeviceCapability() -> String { return "" }
    
    public func fetchValue(forKey key: String) throws -> Any {
        switch mockSecureStorageOutputType {
        case .fetchMockError:
            return true
        default:
            if let storedConsentValue = consentData[key] {
                return storedConsentValue
            } else {
                throw NSError(domain: "TestAppStorageFetch", code: 1111)
            }
        }
    }
    
    public func storeValue(forKey key: String, value object: NSCoding) throws {
        switch mockSecureStorageOutputType {
        case .postSuccess:
            consentData[key] = object
        case .postError:
            throw NSError(domain: "TestAppStorage", code: 2222)
        default:
            break
        }
    }
}
