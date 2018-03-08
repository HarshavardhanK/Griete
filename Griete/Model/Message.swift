//
//  Message.swift
//  Griete
//  This is the model class that represents the blueprint for a message

import Foundation
import os.log


class Message: NSObject, NSCoding {
    
    //TODO: Messages need a messageBody and a sender variable
    var sender: String = "ABC"
    var messageBody: String = "Hey"
    var timeStamp: String = ""
    
    init(sender: String, message: String, time: String) {
        self.sender = sender
        self.messageBody = message
        self.timeStamp = time
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeConditionalObject(sender, forKey: "sender")
        aCoder.encodeConditionalObject(messageBody, forKey: "message")
        aCoder.encodeConditionalObject(timeStamp, forKey: "time")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let sender = aDecoder.decodeObject(forKey: "sender") as? String else {
            print("Cant decode")
            return nil
        }
        
        let message = aDecoder.decodeObject(forKey: "message") as! String
        let time = aDecoder.decodeObject(forKey: "time") as! String
        
        self.init(sender: sender, message: message, time: time)
    }
    
}
