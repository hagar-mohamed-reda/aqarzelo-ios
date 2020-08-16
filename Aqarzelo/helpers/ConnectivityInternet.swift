//
//  ConnectivityInternet.swift
//  Aqarzeoo
//
//  Created by hosam on 2/12/20.
//  Copyright © 2020 hosam. All rights reserved.
//

import Alamofire

struct ConnectivityInternet {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
