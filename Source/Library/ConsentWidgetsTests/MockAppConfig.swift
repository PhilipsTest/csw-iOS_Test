import UAPPFramework

public class MockAppConfig : NSObject, AIAppConfigurationProtocol {
    public func getPropertyForKey(_ key: String!, group: String!) throws -> Any {
        return "blah"
    }
    
    public func setPropertyForKey(_ key: String!, group: String!, value: Any!) throws {
        
    }
    
    public func getDefaultProperty(forKey key: String!, group: String!) throws -> Any {
        return "doh!"
    }
    
    public func refreshCloudConfig(_ completionHandler: ((AIACRefreshResult, Error?) -> Void)!) {
        
    }
    
    public func resetConfig() throws {
        
    }
}
