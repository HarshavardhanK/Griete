//
//  Message.swift
//  Griete
//  This is the model class that represents the blueprint for a message

import Foundation
import os.log

struct PropertyKey2 {
    
    static let sender = "sender"
    static let messageBody = "messageBody"
    static let timeStamp = "timeStamp"
    static let sentTime = "sentTime"
    
}

class Message: NSObject, NSCoding {
    
    //TODO: Messages need a messageBody and a sender variable
    var sender: String = "ABC"
    var messageBody: String = "Hey"
    var timeStamp: String = "10:10:10"
    var sentTime: String
    
    init(sender: String, message: String, time: String, sentTime: String) {
        
        self.sender = sender
        self.messageBody = message
        self.timeStamp = time
        self.sentTime = sentTime
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let sender = aDecoder.decodeObject(forKey: PropertyKey2.sender) as? String else {
            fatalError("Unable to decode Message object!")
            return nil
        }
        
        let messageBody = aDecoder.decodeObject(forKey: PropertyKey2.messageBody) as! String
        let timeStamp = aDecoder.decodeObject(forKey: PropertyKey2.timeStamp) as! String
        let sentTime = aDecoder.decodeObject(forKey: PropertyKey2.sentTime) as! String

        self.init(sender: sender, message: messageBody, time: timeStamp, sentTime: sentTime)
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(sender, forKey: PropertyKey2.sender)
        aCoder.encode(messageBody, forKey: PropertyKey2.messageBody)
        aCoder.encode(timeStamp, forKey: PropertyKey2.timeStamp)
        aCoder.encode(sentTime, forKey: PropertyKey2.sentTime)
    }
    
}
