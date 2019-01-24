//
//  CATKFakeSelectorClass.swift
//  ConsentAccessToolKitTests
//
//  Created by Abhishek Chatterjee on 10/10/17.
//  Copyright © 2017 Abhishek Chatterjee. All rights reserved.
//

import XCTest

@objc(CATKFakeSelectorClass)

class CATKFakeSelectorClass: NSObject {
    
    func fakeAppConfigurationFromFile() -> [String:AnyObject]?  {
        let applicationConfig: String = "{\"USERREGISTRATION\":{\"JANRAINCONFIGURATION.REGISTRATIONCLIENTID.DEVELOPMENT\":{\"CN\":\"QHQ9JVKX35Q8DUEF2FH6WWZCEUJJS9GS\",\"DEFAULT\":\"8KAXDRPVKWYR7PNP987AMU4AQB4WMNTE\"},\"JANRAINCONFIGURATION.REGISTRATIONCLIENTID.TESTING\":{\"CN\":\"G8R8RBK4N5688XPSXQEWMNWUQJB5UGAG\",\"DEFAULT\":\"G52BFMA28YJBD24HYJCSWUDWEDCMQY7C\"},\"JANRAINCONFIGURATION.REGISTRATIONCLIENTID.EVALUATION\":{\"CN\":\"4RDPM7AFU7BNY6XNACW32ETMT7HTFRAA\",\"DEFAULT\":\"F2STYKCYGM7ENBWFW2U9FBG6H6SYB8YD\"},\"JANRAINCONFIGURATION.REGISTRATIONCLIENTID.STAGING\":{\"CN\":\"4RDPM7AFU7BNY6XNACW32ETMT7HTFRAA\",\"DEFAULT\":\"F2STYKCYGM7ENBWFW2U9FBG6H6SYB8YD\"},\"JANRAINCONFIGURATION.REGISTRATIONCLIENTID.PRODUCTION\":{\"CN\":\"BRHYP23JH8JRUTMGHJTHT68YV4MVQVHU\",\"DEFAULT\":\"9Z23K3Q8BHQYFWX78ARU6BZ8ZKSGA54U\"},\"PILCONFIGURATION.CAMPAIGNID\":\"CL20150501_PC_TB_COPPA\",\"FLOW.TERMSANDCONDITIONSACCEPTANCEREQUIRED\":\"1\",\"FLOW.MINIMUMAGELIMIT\":{\"NL\":12,\"GB\":14,\"DEFAULT\":16},\"SIGNINPROVIDERS\":{\"CN\":[\"WECHAT\"],\"DEFAULT\":[\"FACEBOOK\",\"GOOGLEPLUS\"]},\"WECHATAPPID\":\"WXBDF2AB8822F6022F\",\"WECHATAPPSECRET\":\"DF749E21C43C65A042DF6F3F4EBE18F1\",\"GOOGLEPLUSCLIENTID\":\"346000571262-R3N50OUCOENOMGGRFJVHDPFVM95KDL5Q.APPS.GOOGLEUSERCONTENT.COM\",\"GOOGLEPLUSREDIRECTURI\":\"COM.GOOGLEUSERCONTENT.APPS.346000571262-R3N50OUCOENOMGGRFJVHDPFVM95KDL5Q:/OAUTHREDIRECT\",\"SUPPORTEDHOMECOUNTRIES\":[\"RW\",\"BG\",\"CZ\",\"DK\",\"AT\",\"CH\",\"DE\",\"GR\",\"AU\",\"CA\",\"GB\",\"HK\",\"ID\",\"IE\",\"IN\",\"MY\",\"NZ\",\"PH\",\"PK\",\"SA\",\"SG\",\"US\",\"ZA\",\"AR\",\"CL\",\"CO\",\"ES\",\"MX\",\"PE\",\"EE\",\"FI\",\"BE\",\"FR\",\"HR\",\"HU\",\"IT\",\"JP\",\"KR\",\"LT\",\"LV\",\"NL\",\"NO\",\"PL\",\"BR\",\"PT\",\"RO\",\"RU\",\"UA\",\"SI\",\"SK\",\"SE\",\"TH\",\"TR\",\"VN\",\"CN\",\"TW\",\"LU\",\"MO\"],\"FALLBACKHOMECOUNTRY\":\"US\"},\"APPINFRA\":{\"APPIDENTITY.MICROSITEID\":\"77000\",\"APPIDENTITY.SECTOR\":\"B2C\",\"APPIDENTITY.APPSTATE\":\"STAGING\",\"APPIDENTITY.SERVICEDISCOVERYENVIRONMENT\":\"PRODUCTION\",\"ABTEST.PRECACHE\":[\"RECEIVEMARKETINGOPTIN\"],\"SERVICEDISCOVERY.PLATFORMMICROSITEID\":\"70000\",\"SERVICEDISCOVERY.PLATFORMENVIRONMENT\":\"PRODUCTION\",\"SERVICEDISCOVERY.COUNTRYMAPPING\":{\"LU\":\"BE\",\"MO\":\"HK\"},\"LOGGING.RELEASECONFIG\":{\"FILENAME\":\"APPINFRALOG\",\"NUMBEROFFILES\":5,\"FILESIZEINBYTES\":50000,\"LOGLEVEL\":\"WARN\",\"FILELOGENABLED\":true,\"CONSOLELOGENABLED\":true,\"COMPONENTLEVELLOGENABLED\":true,\"COMPONENTIDS\":[\"USR\"]},\"LOGGING.DEBUGCONFIG\":{\"FILENAME\":\"APPINFRALOG\",\"NUMBEROFFILES\":5,\"FILESIZEINBYTES\":50000,\"LOGLEVEL\":\"DEBUG\",\"FILELOGENABLED\":true,\"CONSOLELOGENABLED\":true,\"COMPONENTLEVELLOGENABLED\":true,\"COMPONENTIDS\":[\"USR\"]}}}"


        if let data = applicationConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    func fakeLoggingConfigDictionary() -> [String:AnyObject]? {

        let logConfig = "{\"AI_LOGLEVEL\":\"DDLogLevelAll\",\"MAX_NUMBER_OF_LOG_FILE\":5,\"MAX_FILE_SIZE\":50000,\"FILE_LOG_ENABLED\":1,\"CONSOLE_LOG_ENABLED\":1,\"COMPONENT_LEVEL_LOG_ENABLED\":1,\"LIST_COMPONENTID\":[\"Registration\",\"DemoProductRegistrationClient\"]}"

        if let data = logConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    func fakeAppVersion() -> String {
        return "1.0.0"
    }
}
