// © Koninklijke Philips N.V., 2018. All rights reserved.

import KIF

func capture(_ name: String, file : String = #file, _ line : Int = #line) {
    KIFEnableAccessibility()
    KIFSystemTestActor(inFile: file, atLine: line, delegate: nil).captureScreenshot(withDescription: name)
}

