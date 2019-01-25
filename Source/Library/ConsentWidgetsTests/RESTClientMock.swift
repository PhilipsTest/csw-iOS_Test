import AppInfra

class MockRequestSerializer: AFHTTPRequestSerializer {
    
}

public class RESTClientMock : NSObject, AIRESTClientProtocol {
    public var requestSerializer: AFHTTPRequestSerializer & AFURLRequestSerialization = MockRequestSerializer()

    var status : Bool!
    var internetConnectionChecked : Bool!
    
    public func getNetworkReachabilityStatus() -> AIRESTClientReachabilityStatus {
        return AIRESTClientReachabilityStatus.notReachable
    }
    
    public func isInternetReachable() -> Bool {
        internetConnectionChecked = true
        return status
    }
    
    public func startNotifier() -> Bool {
        return false
    }
    
    public func stopNotifier() {
        
    }
    
    public func clearCacheResponse() {
        
    }
    
    public var baseURL: URL?
    
    public func manager() -> AIRESTClientProtocol {
        return self
    }
    
    public func createInstance(withBaseURL url: URL?) -> AIRESTClientProtocol {
        return self
    }
    
    public func createInstance(withBaseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) -> AIRESTClientProtocol {
        return self
    }
    
    public func createInstance(with configuration: URLSessionConfiguration?) -> AIRESTClientProtocol {
        return self
    }
    
    public func createInstance(withBaseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?, with cachePolicy: AIRESTURLRequestCachePolicy) -> AIRESTClientProtocol {
        return self
    }
    
    public func get(_ URLString: String, parameters: Any?, progress downloadProgress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func get(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, progress downloadProgress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public func head(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func head(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, success: ((URLSessionDataTask) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public func post(_ URLString: String, parameters: Any?, progress uploadProgress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func post(_ URLString: String, parameters: Any?, constructingBodyWith block: ((AFMultipartFormData) -> Void)?, progress uploadProgress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func post(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, progress uploadProgress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public func put(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func put(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public func patch(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func patch(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public func delete(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {
        return nil
    }
    
    public func delete(withServiceID serviceID: String, preference: AIRESTServiceIDPreference, pathComponent: String?, serviceURLCompletion: ((URLSessionDataTask) -> Void)?, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)? = nil) {
        
    }
    
    public var session: URLSession!
    
    public var operationQueue: OperationQueue!
    
    public var responseSerializer: AIRESTClientURLResponseSerialization!
    
    public var securityPolicy: AFSecurityPolicy!
    
    public var reachabilityManager: AFNetworkReachabilityManager!
    
    public var tasks: [URLSessionTask] = []
    
    public var dataTasks: [URLSessionDataTask] = []
    
    public var uploadTasks: [URLSessionUploadTask] = []
    
    public var downloadTasks: [URLSessionDownloadTask] = []
    
    public var completionQueue: DispatchQueue?
    
    public var completionGroup: DispatchGroup?
    
    public var attemptsToRecreateUploadTasksForBackgroundSessions: Bool = false
    
    public func invalidateSessionCancelingTasks(_ cancelPendingTasks: Bool) {
        
    }
    
    public func dataTask(with request: URLRequest, completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionDataTask {
        return URLSessionDataTask()
    }
    
    public func dataTask(with request: URLRequest, uploadProgress uploadProgressBlock: ((Progress) -> Void)?, downloadProgress downloadProgressBlock: ((Progress) -> Void)?, completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionDataTask {
         return URLSessionDataTask()
    }
    
    public func uploadTask(with request: URLRequest, fromFile fileURL: URL, progress uploadProgressBlock: ((Progress) -> Void)?, completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {
         return URLSessionUploadTask()
    }
    
    public func uploadTask(with request: URLRequest, from bodyData: Data?, progress uploadProgressBlock: ((Progress) -> Void)?, completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {
         return URLSessionUploadTask()
    }
    
    public func uploadTask(withStreamedRequest request: URLRequest, progress uploadProgressBlock: ((Progress) -> Void)?, completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {
         return URLSessionUploadTask()
    }
    
    public func downloadTask(with request: URLRequest, progress downloadProgressBlock: ((Progress) -> Void)?, destination: ((URL, URLResponse) -> URL)?, completionHandler: ((URLResponse, URL?, Error?) -> Void)? = nil) -> URLSessionDownloadTask {
         return URLSessionDownloadTask()
    }
    
    public func downloadTask(withResumeData resumeData: Data, progress downloadProgressBlock: ((Progress) -> Void)?, destination: ((URL, URLResponse) -> URL)?, completionHandler: ((URLResponse, URL?, Error?) -> Void)? = nil) -> URLSessionDownloadTask {
        return URLSessionDownloadTask()
    }
    
    public func uploadProgress(for task: URLSessionTask) -> Progress? {
        return nil
    }
    
    public func downloadProgress(for task: URLSessionTask) -> Progress? {
        return nil
    }
    
    public func setSessionDidBecomeInvalidBlock(_ block: ((URLSession, Error) -> Void)?) {
        
    }
    
    public func setSessionDidReceiveAuthenticationChallenge(_ block: ((URLSession, URLAuthenticationChallenge, AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition)?) {
        
    }
    
    public func setTaskNeedNewBodyStreamBlock(_ block: ((URLSession, URLSessionTask) -> InputStream)?) {
        
    }
    
    public func setTaskWillPerformHTTPRedirectionBlock(_ block: ((URLSession, URLSessionTask, URLResponse, URLRequest) -> URLRequest)?) {
        
    }
    
    public func setTaskDidReceiveAuthenticationChallenge(_ block: ((URLSession, URLSessionTask, URLAuthenticationChallenge, AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition)?) {
        
    }
    
    public func setTaskDidSendBodyDataBlock(_ block: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?) {
        
    }
    
    public func setTaskDidComplete(_ block: ((URLSession, URLSessionTask, Error?) -> Void)?) {
        
    }
    
    public func setDataTaskDidReceiveResponseBlock(_ block: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?) {
        
    }
    
    public func setDataTaskDidBecomeDownloadTaskBlock(_ block: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?) {
        
    }
    
    public func setDataTaskDidReceiveDataBlock(_ block: ((URLSession, URLSessionDataTask, Data) -> Void)?) {
        
    }
    
    public func setDataTaskWillCacheResponseBlock(_ block: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse)?) {
        
    }
    
    public func setDidFinishEventsForBackgroundURLSessionBlock(_ block: ((URLSession) -> Void)?) {
        
    }
    
    public func setDownloadTaskDidFinishDownloadingBlock(_ block: ((URLSession, URLSessionDownloadTask, URL) -> URL?)?) {
        
    }
    
    public func setDownloadTaskDidWriteDataBlock(_ block: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?) {
        
    }
    
    public func setDownloadTaskDidResumeBlock(_ block: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?) {
        
    }
    
    public var delegate: AIRESTClientDelegate?
    
    
}
