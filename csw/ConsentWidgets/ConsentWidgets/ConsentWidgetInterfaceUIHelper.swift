//  Copyright © 2017 Philips. All rights reserved.

import UIKit

class ConsentWidgetInterfaceUIHelper: NSObject {

     func bundle() -> Bundle {
        return Bundle(for: ConsentWidgetInterfaceUIHelper.classForCoder())
    }

     func storyBoard() -> UIStoryboard  {
        return UIStoryboard.init(name: "ConsentWidgets", bundle:self.bundle())
    }

    class func instantiateUserInterface() -> UIViewController {
        let helper = ConsentWidgetInterfaceUIHelper()
        let viewController = helper.getRootViewController()
        return viewController
    }

    func getRootViewController() -> BaseViewController {
        return self.storyBoard().instantiateViewController(withIdentifier: ViewControllerStoryBoardIds.ConsentWidgetsViewControllerStoryBoardId) as! BaseViewController
    }
    
    class func getHelpTextViewController() -> HelpTextViewController? {
        let helper = ConsentWidgetInterfaceUIHelper()
        return helper.storyBoard().instantiateViewController(withIdentifier: ViewControllerStoryBoardIds.HelpTextViewControllerStoryBoardId) as? HelpTextViewController
    }
 }
