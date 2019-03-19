//
//  VisitorTests.swift
//  ParselyTrackerTests
//
//  Created by Chris Wisecarver on 11/5/18.
//  Copyright © 2018 Parse.ly. All rights reserved.
//

import XCTest
@testable import ParselyTracker
import Foundation


class VisitorTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    let visitors: VisitorManager = VisitorManager()

    func testGetVisitorInfo() {
        let visitor = visitors.getVisitorInfo()
        XCTAssertFalse(visitor.isEmpty, "The first call to VisitorManager.getVisitorInfo should return a non-empty object")
        // FIXME: Visitor should have a way to expire visitors, at least for testing. Otherwise the first
        // visitor created in the tests persists.
        // let thirtyDaysFromNow = Date.init(timeIntervalSinceNow: (60 * 60 * 24 * 365  / 12) * 13)
        // XCTAssertEqual(visitor["expires"] as? Date, thirtyDaysFromNow, "Should expire thirty days from now.")
        let subsequentVisitor = visitors.getVisitorInfo()
        XCTAssertEqual(visitor["id"] as! String, subsequentVisitor["id"] as! String,
                       "Sequential calls to VisitorManager.getVisitorInfo within the default expiry should return objects " +
                       "with the same visitor ID")
    }
    func testExtendVisitorExpiry() {
        let visitor = visitors.getVisitorInfo()
        let capturedExpiryOne = visitor["expires"] as! Date
        let subsequentVisitor = visitors.getVisitorInfo(shouldExtendExisting: true)
        let capturedExpiryTwo = subsequentVisitor["expires"] as! Date
        XCTAssert(capturedExpiryOne < capturedExpiryTwo,
                  "Given an existing visitor, a call to VisitorManager.getVisitorInfo with shouldExtendExisting:true " +
                  "should return an object with a later expiry than the preexisting one")
    }
}
