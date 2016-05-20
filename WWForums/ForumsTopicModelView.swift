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
        mergeUsersWithTopics()
        test()
    }
    
    func mergeUsersWithTopics() {
        for (index, topic) in forumTopicsUsers.topicsList.topics.enumerate() {
            let user = forumTopicsUsers.users[index]
            
            let topicPoster = topic.posters[0]
            let avatarURL = user.avatar.stringByReplacingOccurrencesOfString(ForumTopicsConstants.ModelViewConstants.BracketSize, withString: ForumTopicsConstants.ModelViewConstants.TargetSize)
            topicPoster.userName = user.userName
            topicPoster.avatarTemplate = avatarURL
        }
    }
    
    func test() {
        for (index, topic) in forumTopicsUsers.topicsList.topics.enumerate() {
            print("username: \(topic.posters[0].userName)")
            print("avatar: \(topic.posters[0].avatarTemplate)")
        }
    }
    
}

struct ForumTopicsConstants {
    struct ModelViewConstants {
        static let BracketSize     = "{size}"
        static let TargetSize      = "240"
    }
}