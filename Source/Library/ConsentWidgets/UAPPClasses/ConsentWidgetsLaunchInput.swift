import UAPPFramework
import PlatformInterfaces

@objc public protocol ConsentWidgetCenterPrivacyProtocol: NSObjectProtocol {
    @objc func userClickedOnPrivacyURL()
}

@objcMembers public class ConsentWidgetsLaunchInput: UAPPLaunchInput {
    public var consentDefinitions: [ConsentDefinition]
    public weak var privacyDelegate: ConsentWidgetCenterPrivacyProtocol?
    
    public init(consentDefinitions: [ConsentDefinition], privacyDelegate: ConsentWidgetCenterPrivacyProtocol?) {
        self.consentDefinitions = consentDefinitions
        self.privacyDelegate = privacyDelegate
    }
}

