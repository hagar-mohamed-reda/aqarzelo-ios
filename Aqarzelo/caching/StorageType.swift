//
//  StorageType.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
enum StorageType {
    case cache
    case permanent

    var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
        case .cache: return .cachesDirectory
        case .permanent: return .documentDirectory
        }
    }

    var folder: URL {
        let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true).first!
        let subfolder = "com.nsscreencast.TopRepos.json_storage"
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }

    func clearStorage() {
        try? FileManager.default.removeItem(at: folder)
    }
}
