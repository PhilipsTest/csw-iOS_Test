import Foundation
import AppInfra

public typealias ServerCompletionHandler = (_ serverResponseObject: ConsentServiceResponseHolder) -> Void

public protocol ConsentServiceServerCommunicationProtocol {
    func connectToServerWithRequest(_ request: URLRequest, completionHandler handler: ServerCompletionHandler?)
}

open class ConsentServiceNetworkCommunicator :NSObject, ConsentServiceServerCommunicationProtocol {
    private var catkInputs: CATKInputs!
    
    public init(with catkInputs: CATKInputs) {
        self.catkInputs = catkInputs
    }
    
    open func connectToServerWithRequest(_ request: URLRequest, completionHandler handler: ServerCompletionHandler?) {
        let sessionConfiguration = URLSessionConfiguration.default;
        sessionConfiguration.urlCache = nil;
        let restClientWithSessionConfiguration = self.catkInputs.restClient.createInstance(with:sessionConfiguration)
        restClientWithSessionConfiguration.responseSerializer = AIRESTClientHTTPResponseSerializer()
        let dataTask = restClientWithSessionConfiguration.dataTask(with: request as URLRequest) { (response, dataObject , error) in
            let consentResponseHolder = ConsentServiceResponseHolder(inData: dataObject as? Data, inResponse: response as? HTTPURLResponse, inError: error as NSError?)
            handler?(consentResponseHolder)
        }
        dataTask.resume()
    }
}
