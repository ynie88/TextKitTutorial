//
//  ViewType.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 9/12/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct JSONConstants {
    struct viewType {
        static let type = "type"
        static let name = "name"
        static let id = "id"
        static let content = "content"
    }
}

enum Type {
    case TextField
    case ImageView
    case Label
}

struct ViewType:Mappable {
    var type:Type!
    var name:String?
    var id:String!
    var content:String?
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    mutating func mapping(map: Map) {
        type    <- map[JSONConstants.viewType.type]
        name    <- map[JSONConstants.viewType.name]
        id      <- map[JSONConstants.viewType.id]
        content <- map[JSONConstants.viewType.content]
    }
}