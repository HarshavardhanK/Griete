//
//  Friends.swift
//  Griete
//  Created by Harshavardhan K on 04/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import Foundation
import os.log


struct PropertyKey {
    
    static let messages = "message"
    static let name = "name"
    static let recentMessage = "recentMessage"
}

class Friends: NSObject, NSCoding {
    
    var messages: [Message] = [Message]()
    var name: String = ""
    var recentMessage = "Hey there!"
    
    init(name: String) {
        
        let message = Message(sender: "abc", message: "Using Griete!", time: "0:0")
        messages.append(message)
        
        self.name = name
        //self.messages = messages
        self.recentMessage = messages[messages.count - 1].messageBody
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(messages, forKey: PropertyKey.messages)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(recentMessage, forKey: PropertyKey.recentMessage)
    }

    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let messages = aDecoder.decodeObject(forKey: PropertyKey.messages) as? [Message] else {
            
            os_log("Unable to decode message", log: OSLog.default, type: .debug)
            return nil
        }
        
        let recentMessage = aDecoder.decodeObject(forKey: PropertyKey.recentMessage) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
    
        
        self.init(name: name)
        self.messages = messages

    }
    
    
    //MARK: Path to archiving file
    static var filePath = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = filePath.appendingPathComponent("friends")
    
    
}
