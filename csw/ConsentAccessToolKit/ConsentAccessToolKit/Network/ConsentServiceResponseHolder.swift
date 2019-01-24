public class ConsentServiceResponseHolder {
    var data: Data?
    var response: HTTPURLResponse?
    var error: NSError?
    
    public init (inData: Data?, inResponse: HTTPURLResponse?, inError: NSError?) {
        self.data = inData
        self.response = inResponse
        self.error = inError
    }
}
