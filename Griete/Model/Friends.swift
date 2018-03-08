//
//  Friends.swift
//  Griete
//  Created by Harshavardhan K on 04/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import Foundation
import os.log


class Friends  {
    
    var messages: [Message] = [Message]()
    var name: String = ""
    var recentMessage: Message!
    
    init(name: String) {
        
        let message = Message(sender: "abc", message: "Using Griete!", time: "10:10")
        messages.append(message)
        
        self.name = name
        //self.messages = messages
        self.recentMessage = messages[messages.count - 1]
    }
    
    
    
    
}
