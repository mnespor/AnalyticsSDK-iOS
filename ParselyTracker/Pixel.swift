//
//  pixel.swift
//  AnalyticsSDK
//
//  Created by Chris Wisecarver on 5/17/18.
//  Copyright © 2018 Parse.ly. All rights reserved.
//

import Foundation
import SwiftHTTP
import os.log

class Pixel {
    
    func beacon(event: Event, shouldNotSetLastRequest: Bool) {
        os_log("Fired beacon", log: OSLog.default, type: .debug)
        // start forming dictionary
        let rand = Date().millisecondsSince1970
        var data: Dictionary<String,Any?> = ["idsite": Parsely.sharedInstance.apikey, "data": ["ts": rand]]
        // add session data
        let session = Session().get(extendSession: true)
        data = data.merging(session, uniquingKeysWith: { (old, _new) in old })
        // add in the event toDict itself
//        data = data.merging(event.toDict(), uniquingKeysWith: { (old, _new) in old })
        // visitor info
        let visitorInfo = Parsely.sharedInstance.visitorManager.getVisitorInfo(shouldExtendExisting: true)
        data["parsely_uuid"] = visitorInfo["id"]
        // TODO parsely_site_uuid??
        if (shouldNotSetLastRequest) {
            Parsely.sharedInstance.lastRequest = data
        }
        // TODO: should we just enqueue dicts? this has a duplicate of the event inside data.
//        let event = Event(
//            data["action"] as! String,
//            url: event.url,
//            urlref: event.urlref,
//            data: data as Dictionary<String, Any>)
        event.data = data as Dictionary<String, Any> // assign updated values
        // TODO: get around the problem that we enrich events here
        // todo: handle idsite appropriately at top-level
        Parsely.sharedInstance.eventQueue.push(event)
    }
}
