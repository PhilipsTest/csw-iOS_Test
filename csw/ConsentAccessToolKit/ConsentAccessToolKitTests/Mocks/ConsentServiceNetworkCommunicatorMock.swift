import Foundation
import ConsentAccessToolKit

@testable import ConsentAccessToolKit

class ConsentServiceNetworkCommunicatorMock: ConsentServiceNetworkCommunicator {

    var executedRequest: URLRequest?
    var responseToReturn: ConsentServiceResponseHolder?
    var counter = 0
    var requestCount = 0
    
    override init(with catkInputs: CATKInputs) {
        super.init(with: catkInputs)
    }
    
    override func connectToServerWithRequest(_ request: URLRequest, completionHandler handler: ServerCompletionHandler?) {
        self.executedRequest = request
        requestCount += 1
        handler!(responseToReturn!)
    }
    
}
