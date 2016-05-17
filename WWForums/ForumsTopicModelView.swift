//
//  ForumsTopicModelView.swift
//  WWForums
//
//  Created by Yuchen Nie on 5/17/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import WWRequestKit

struct ForumsTopicModelView {
    let forumTopicsUsers:ForumsTopicsUsers!
    var topics:[ForumTopic] = [ForumTopic]()
    
    init(topicsUsers:ForumsTopicsUsers){
        forumTopicsUsers = topicsUsers
    }
    
    func mergeUsersWithTopics() {
        
    }
    
}