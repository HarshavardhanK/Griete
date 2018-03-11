//
//  Friends.swift
//  Griete
//  Created by Harshavardhan K on 04/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import Foundation
import os.log
import UIKit

struct PropertyKey {
    
    static let messages = "messages"
    static let name = "name"
    static let recentMessage = "recentMessage"
    static let profilePicture = "profilePicture"
}

class Friends: NSObject, NSCoding  {
    
    var messages: [Message] = [Message]()
    var name: String = ""
    var recentMessage: Message!
    var profilePicture: UIImage?
    
    init(name: String) {
        
        let message = Message(sender: "abc", message: "Using Griete!", time: "10:10")
        messages.append(message)
        
        self.name = name
        //self.messages = messages
        self.recentMessage = messages[messages.count - 1]
    }
    
    func setProfilePicture(pic: UIImage) {
        self.profilePicture = pic
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(messages, forKey: PropertyKey.messages)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(recentMessage, forKey: PropertyKey.recentMessage)
        aCoder.encode(profilePicture, forKey: PropertyKey.profilePicture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            fatalError("Cannot decode object!")
            return nil
        }
        
        let messages = aDecoder.decodeObject(forKey: PropertyKey.messages) as! [Message]
        let recentMessage = aDecoder.decodeObject(forKey: PropertyKey.recentMessage) as! Message
        
        if let profilePicture = aDecoder.decodeObject(forKey: PropertyKey.profilePicture) as? UIImage {
            self.profilePicture = profilePicture
            
        } else {
            self.profilePicture = UIImage(named: "default-profile")

        }
        
        self.messages = messages
        self.recentMessage = recentMessage
        self.name = name
    }
    
    static let archive = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = archive.appendingPathComponent("chatList")
    
    
}
