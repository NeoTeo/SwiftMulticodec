//
//  SwiftMulticodecTests.swift
//  SwiftMulticodecTests
//
//  Created by Teo Sartori on 08/05/2018.
//

import XCTest
@testable
import SwiftMulticodec

class SwiftMulticodecTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVerifyPrefixAll() {
        
        let bytes = Array("an example string".utf8)
        do {
            for (prefixName, prefixInt) in codecs {
                let prefixedBytes = try addPrefix(multiCodec: prefixName, bytes: bytes)
                
                print("checking \(prefixName) with value \(prefixInt)")
                XCTAssert(try getCodec(bytes: prefixedBytes) == prefixName)
                XCTAssert(try removePrefix(bytes: prefixedBytes) == bytes)
                XCTAssert(try extractPrefix(bytes: prefixedBytes) == prefixInt)
            }
        } catch {
            XCTFail("testVerifyPrefixAll failed with \(error)")
        }
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
