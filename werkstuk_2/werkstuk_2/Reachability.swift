//
//  Reachability.swift
//  werkstuk_2
//
//  Created by student on 01/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Reachability: NSObject {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr:0), sin_zero: (0,0,0,0,0,0,0,0))
        zeroAddress.sin_len = UInt8 (MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachiblity = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, zeroSockAddress)
            }
            
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachiblity!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
    }
}
