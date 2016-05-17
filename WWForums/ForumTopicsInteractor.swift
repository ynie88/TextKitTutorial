//
//  ForumTopicsInteractor.swift
//  WWForums
//
//  Created by Yuchen Nie on 5/17/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import WWRequestKit
import ObjectMapper

class ForumTopicsInteractor {
    func procureData(page:Int = 0) {
        let resource = ForumResource.ListTopics()
        resource.response { (response) in
            switch response.result {
            case .Success(let json):
                guard let json = json else {return}
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
                    let topics = Mapper<ForumsTopicsUsers>().map(jsonData)
                    
                    
                } catch (let error){
                    print(error)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}