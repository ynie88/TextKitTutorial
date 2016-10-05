//
//  DataType.swift
//  PrettyTextView
//
//  Created by Wesley Cope on 4/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation

let DetectedDataHandlerAttributeName    = "DetectedDataHandlerAttributeName"
let ImageAttributeName                  = "ImageAttributeName"
let CustomDataAttributeName             = "CustomDataAttributeName"

enum DetectedType : Int, CustomStringConvertible {
    case mention
    case hashTag
    case url
    case email
    case image
    case custom
    
    var description: String {
        switch self {
        case .mention:
            return "Mention"
        case .hashTag:
            return "HashTag"
        case .url:
            return "URL"
        case .email:
            return "Email"
        case .image:
            return "Image"
        case .custom:
            return "Custom"
        }
    }
}







