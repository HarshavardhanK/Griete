//
//  Message.swift
//  Griete
//  This is the model class that represents the blueprint for a message

import Foundation
import os.log


class Message {
    
    //TODO: Messages need a messageBody and a sender variable
    var sender: String = "ABC"
    var messageBody: String = "Hey"
    var timeStamp: String = "10:10"
    
    init(sender: String, message: String, time: String) {
        self.sender = sender
        self.messageBody = message
        self.timeStamp = time
    }
    
}
