// © Koninklijke Philips N.V., 2018. All rights reserved.

import Quick
import Nimble
import Foundation
import QuartzCore
import XCTest
@testable import ConsentWidgets

public class LabelTester: Tester {

    public init() {}

    public func test(language: String, against base: String, in controller: UIViewController) {
        let loader = ViewLoader()
        
        describe("load language \(language)") {
            beforeEach {
                LanguageLoader.load(language: language)
            }
            
            describe("show \(String(describing: type(of: controller)))") {
                beforeEach {
                    loader.show(controller: controller)
                }
                
                describe("test labels") {
                    var views: [UIView]!
                    var labels: [UILabel]!

                    beforeEach {
                        views = controller.view.getViewTree()
                        labels = views.flatMap { $0 as? UILabel }
                    }

                    it("is not resized") {
                        let truncatedLabels = labels.filter { (label) -> Bool in
                            return label.isTruncated()
                        }

                        for label in truncatedLabels {
                            label.addBorder()
                        }

                        if truncatedLabels.count > 0 {
                            capture("\(String(describing: type(of: self.getTopViewController(controller)))) - \(language) - labels truncated")
                            fail("Some labels are truncated")
                        }
                    }

                    it("is shown on the screen") {
                        let labelsThatDontFitOnScreen = labels.filter { (label) -> Bool in
                            return !label.hasScrollViewAncestor()
                            }.filter { (label) -> Bool in
                                let convertedFrame = label.convert(label.bounds, to: controller.view)
                                let totalHeight = convertedFrame.size.height + convertedFrame.origin.y
                                let fitsOnScreen = totalHeight < controller.view.frame.size.height
                                return !fitsOnScreen
                        }

                        for label in labelsThatDontFitOnScreen {
                            label.addBorder()
                        }

                        if labelsThatDontFitOnScreen.count > 0 {
                            capture("\(String(describing:  type(of: self.getTopViewController(controller)))) - \(language) - labels out of screen")
                            fail("Some labels are out of screen")
                        }
                    }
                }
            }
        }
    }
    
    private func getTopViewController(_ controller: UIViewController) -> UIViewController {
        var viewController = controller
        if let navigationController = controller as? UINavigationController,
            let topViewController = navigationController.topViewController {
            viewController = topViewController
        }
        return viewController
    }
}
