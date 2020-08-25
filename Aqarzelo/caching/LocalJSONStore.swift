//
//  LocalJSONStore.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

let cacheCurrentUserCodabe: LocalJSONStore<UserModel> = LocalJSONStore(storageType: .cache, filename: "sdsssasad.json")
let cacheMessagesUserCodabe: LocalJSONStore<[UserIdsModel]> = LocalJSONStore(storageType: .cache, filename: "sdsssaddsad.json")
let cacheMessagessssUserCodabe: LocalJSONStore<[GetPostModel]> = LocalJSONStore(storageType: .cache, filename: "sdsssasdsddsad.json")
let cacheFavoriteAqarsCodabe: LocalJSONStore<[AqarModel]> = LocalJSONStore(storageType: .cache, filename: "sdsssasdsddsad.json")




class LocalJSONStore<T> where T : Codable {
    
    let storageType: StorageType
    let filename: String
    
    init(storageType: StorageType, filename: String) {
        self.storageType = storageType
        self.filename = filename
        ensureFolderExists()
    }
    
    func save(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            
            try data.write(to: fileURL)
        } catch let e {
            print("ERROR: \(e)")
        }
    }
    
    func deleteFile(_ object: T) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            //                try data.
        } catch let e {
            print("ERROR: \(e)")
        }
    }
    
    var storedValue: T? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: data)
        } catch let e {
            print("ERROR: \(e)")
            return nil
        }
    }
    
    private var folder: URL {
        return storageType.folder
    }
    
    private var fileURL: URL {
        return folder.appendingPathComponent(filename)
    }
    
    private func ensureFolderExists() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: folder.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return
            }
            
            try? FileManager.default.removeItem(at: folder)
        }
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
    }
}



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
