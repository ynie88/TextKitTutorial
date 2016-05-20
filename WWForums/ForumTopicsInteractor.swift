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

protocol ForumsTopicsInteractorInput {}
protocol ForumsTopicsInteractorOutput {}

class ForumsTopicsInteractor: ForumsTopicsInteractorInput {
    var output:ForumsTopicsInteractorOutput!
    
    var topics: ForumsTopicModelView? = nil
    
    init(){
        procureData()
    }
    
    func procureData(page:Int = 0) {
        let resource = ForumResource.ListTopics()
        resource.response { [weak self] (response) in
            guard let _self = self else {fatalError()}
            switch response.result {
            case .Success(let json):
                guard let json = json else {return}
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
                    guard let topics = Mapper<ForumsTopicsUsers>().map(jsonData) else {return}
                    _self.topics = ForumsTopicModelView(topicsUsers: topics)
                    
                } catch (let error){
                    print(error)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}