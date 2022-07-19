//
//  CBU2TextTests.swift
//  CBU2TextTests
//
//  Created by f0go on 19/07/2022.
//

import XCTest

@testable import CBU2Text

class CBU2TextTests: XCTestCase {
    
    func testOCR() {
        let ocr = OCR()
        guard let image = UIImage(named: "testCBU")?.cgImage else {
            XCTAssert(false)
            return
        }
        ocr.img2cbu(cgImage: image) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func processImage() {
        let mainViewModel = MainViewModel()
        guard let image = UIImage(named: "testCBU")?.cgImage else {
            XCTAssert(false)
            return
        }
        mainViewModel.processImage(image: image) { cbu, showRateApp in
            XCTAssertNotNil(cbu)
        }
    }
}
