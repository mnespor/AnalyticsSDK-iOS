//
//  SessionTests.swift
//  ParselyTrackerTests
//
//  Created by Chris Wisecarver on 11/5/18.
//  Copyright © 2018 Parse.ly. All rights reserved.
//

import XCTest
@testable import ParselyTracker
import Foundation

class SessionTests: XCTestCase {
    let sessionExtensionMessage:String = "Sequential calls to SessionManager.get within the session timeout that have " +
        "shouldExtendExisting:true should return a session object with the same session ID as the " +
    "preexisting session object"
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    let sessions = SessionManager()
    let emptyDict: [String: Any?] = [:]

    func testGet() {
        let url1 = "http://parsely-test.com/123"
        let url2 = "http://parsely-test.com/"
        let session = sessions.get(url: url1, urlref: "")
        XCTAssertFalse(session.isEmpty, "The first call to SessionManager.get should create a session object")
        let subsequentSession = sessions.get(url: url2, urlref: url1, shouldExtendExisting: true)
        XCTAssertEqual(session["session_id"] as! Int, subsequentSession["session_id"] as! Int,
                       "Sequential calls to SessionManager.get within the session timeout that have " +
                       "shouldExtendExisting:true should return a session object with the same session ID as the " +
                       "preexisting session object")
    }

    func testExpiry() {
        let url1 = "http://parsely-test.com/123"
        let session = sessions.get(url: url1, urlref: "")
        let subsequentSession = sessions.get(url: url1, urlref: "", shouldExtendExisting: true)
        XCTAssert(subsequentSession["expires"] as! Date > session["expires"] as! Date,
                  "Sequential calls to SessionManager.get within the session timeout that have " +
                  "shouldExtendExisting:true should return a session object with an extended expiry value " +
                  "compared to the original expiry of the session")

    }
}
