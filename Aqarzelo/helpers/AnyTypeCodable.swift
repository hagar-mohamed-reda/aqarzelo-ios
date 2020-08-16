//
//  AnyTypeCodable.swift
//  Doctoraak
//
//  Created by hosam on 4/30/20.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit


struct AnyType {
    private(set) var string:String?
     private(set) var int:Int?
     private(set) var double:Double?
     private(set) var float:Float?
    
    init(value: String?) {
        self.string = value
    }
    init(value: Int?) {
           self.int = value
       }
    init(value: Double?) {
           self.double = value
       }
    init(value: Float?) {
           self.float = value
       }
}

extension AnyType :Decodable {
    
    init(from decoder:Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(String.self) {
            self.string = value
        }else if let value = try? container.decode(Double.self) {
            self.double = value
        }else if let value = try? container.decode(Int.self) {
            self.int = value
        }else if let value = try? container.decode(Float.self) {
            self.float = value
        }else {
            throw DecodingError.typeMismatch(AnyType.self, .init(codingPath: [],debugDescription: ("Can't find any matched type")))
        }
        
    }
    
}

extension AnyType:Encodable {
    
    func encode(to encode:Encoder)  throws {
        var container =  encode.singleValueContainer()

        if let value = string {
            try container.encode(value)
        }else if let value = double {
            try container.encode(value)
        }else if let value = int {
            try container.encode(value)
        }else if let value = float {
            try container.encode(value)
        }else {
           try container.encodeNil()
        }
    }
    
}
