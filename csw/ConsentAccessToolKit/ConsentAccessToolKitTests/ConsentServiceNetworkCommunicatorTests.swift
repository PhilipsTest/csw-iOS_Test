import XCTest
import ConsentAccessToolKit

class ConsentServiceNetworkCommunicatorTests: XCTestCase {

    var result: Any!
    var serailizationResult: Data!
    var networkCommunicator : ConsentServiceNetworkCommunicator!

    override func setUp() {
        super.setUp()
        networkCommunicator = ConsentServiceNetworkCommunicator()
    }
    
    func testDeserializeData() throws {
        try whenDeserializingJsonData()
        thenJsonIsParsed()
    }
    
    func testSerializeData() throws {
        try whenSerializingData()
        thenJsonStringIsReturned()
    }

    func whenDeserializingJsonData() throws {
        self.result = try networkCommunicator.deserializeData(getDataObjFromString())
    }
    
    func whenSerializingData() throws {
        let data = [
            "resourceType": "Consent",
            "language": "af-ZA",
            "status": "active",
            "subject": "jhkjhU",
            "policyRule": "urn:com.philips.consent:moment/IN/0/OneBackendProp/OneBackend"
            ] as [String : Any]
        self.serailizationResult = try networkCommunicator.serializeData(data)
    }

    func thenJsonIsParsed(){
        XCTAssertTrue(result is Array<Dictionary<String, String>>)
        let jsonArray : Array = self.result as! Array<Dictionary<String, String>>
        let jsonObject1: Dictionary = jsonArray[0]
        XCTAssertEqual("2017-10-23T09:03:33.000Z", jsonObject1["dateTime"])
        XCTAssertEqual("17f7ce85-403c-4824-a17f-3b551f325ce0", jsonObject1["subject"])

        let jsonObject2: Dictionary = jsonArray[1]
        XCTAssertEqual("2017-12-20T09:03:33.000Z", jsonObject2["dateTime"])
        XCTAssertEqual("de-DE", jsonObject2["language"])
    }
    
    func thenJsonStringIsReturned() {
        let expected = "{\"language\":\"af-ZA\",\"status\":\"active\",\"resourceType\":\"Consent\",\"policyRule\":\"urn:com.philips.consent:moment\\/IN\\/0\\/OneBackendProp\\/OneBackend\",\"subject\":\"jhkjhU\"}"
        XCTAssertEqual(expected, String(data: self.serailizationResult, encoding: .utf8))
    }
    
    private func getDataObjFromString() -> Data {
        let stringData = "[{\"dateTime\":\"2017-10-23T09:03:33.000Z\",\"language\":\"af-ZA\",\"policyRule\":\"urn:com.philips.consent:abhishek/IN/0/OneBackendProp/OneBackend\",\"resourceType\":\"Consent\",\"status\":\"active\",\"subject\":\"17f7ce85-403c-4824-a17f-3b551f325ce0\"}, {\"dateTime\":\"2017-12-20T09:03:33.000Z\",\"language\":\"de-DE\"}]"
        return stringData.data(using: .utf8)!
    }
}
