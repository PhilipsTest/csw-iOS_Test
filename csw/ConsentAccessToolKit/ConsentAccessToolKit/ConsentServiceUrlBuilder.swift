class ConsentServiceUrlBuilder {
    fileprivate var mutableRequest: URLRequest!
    
    init(baseURL : String) {
        guard let urlToUse = URL(string: baseURL) else {
            self.mutableRequest = URLRequest(url: URL(string: "Empty")!)
            return
        }
        self.mutableRequest = URLRequest(url: urlToUse)
    }
    
    func appendPathComponent(_ inPath: String?) -> Self {
        if let stringPassed = inPath {
            if let requestURL = self.mutableRequest.url {
                var urlString = String(describing: requestURL)
                urlString = urlString + "/" + stringPassed
                self.mutableRequest = URLRequest(url: URL(string: urlString)!)
            }
        }
        
        return self
    }
    
    func setHTTPHeaders(_ inHeaders: Dictionary<String, String>) -> Self {
        for (key,value) in inHeaders {
            self.mutableRequest.setValue(value, forHTTPHeaderField: key)
        }
        return self
    }
    
    func setHTTPMethod(_ inMethod: String) -> Self {
        self.mutableRequest.httpMethod = inMethod
        return self
    }
    
    func setBody(_ inData: Data) -> Self {
        self.mutableRequest.httpBody = inData
        return self
    }
    
    func getURLRequest() -> URLRequest {
        self.mutableRequest.timeoutInterval = 20
        return self.mutableRequest
    }
    
}
