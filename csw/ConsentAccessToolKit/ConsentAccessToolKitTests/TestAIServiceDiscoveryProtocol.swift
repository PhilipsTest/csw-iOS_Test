import Foundation
import AppInfra

public class TestAIServiceDiscoveryProtocol : NSObject, AIServiceDiscoveryProtocol {
    
    var failedserviceDiscovery: Bool = false
    var getServiceUrlInvokedCount: Int = 0
    var getServiceUrlInvokedServiceId: String?
    var getHomeCountry_returns: String?
    var serviceDiscoveryReturnsEmptyURL: Bool = false
    
    public func getHomeCountry(_ completionHandler: ((String?, String?, Error?) -> Swift.Void)!) {
        
    }
    
    public func getHomeCountry() -> String! {
        return getHomeCountry_returns
    }
    
    public func setHomeCountry(_ countryCode: String!) {
        
    }
    
    
    public func getServiceUrl(withLanguagePreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
        
    }
    
    public func getServiceUrl(withLanguagePreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!, replacement: [AnyHashable : Any]!) {
        
    }
    
    public func getServiceUrl(withCountryPreference serviceId: String!, withCompletionHandler completionHandler:  ((String?, Error?) -> Swift.Void)!) {
        getServiceUrlInvokedCount += 1
        getServiceUrlInvokedServiceId = serviceId
        if (failedserviceDiscovery) {
            completionHandler(nil, TestError())
        }else if(serviceDiscoveryReturnsEmptyURL){
            completionHandler(nil, nil)
        }else {
            completionHandler("www.test.com", nil)
        }
    }
    
    public func getServiceUrl(withCountryPreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!, replacement: [AnyHashable : Any]!) {
    }
    
    public func getServicesWithLanguagePreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Swift.Void)!) {
        
    }
    
    public func getServicesWithLanguagePreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Swift.Void)!, replacement: [AnyHashable : Any]!)  {
        
    }
    
    public func getServicesWithCountryPreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Swift.Void)!) {
        
    }
    
    public func getServicesWithCountryPreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Swift.Void)!, replacement: [AnyHashable : Any]!) {
        
    }
    
    public func getServiceLocale(withLanguagePreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
        
    }
    
    
    public func getServiceLocale(withCountryPreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
        
    }
    
    public func refresh(_ completionHandler: ((Error?) -> Swift.Void)!) {
        
    }
    
    public func applyURLParameters(_ URLString: String!, parameters map: [AnyHashable : Any]!) -> String! {
        return ""
    }
}

class TestError : Error {
    
}

