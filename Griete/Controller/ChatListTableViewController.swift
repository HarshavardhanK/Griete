//
//  ChatListTableViewController.swift
//  Griete
//
//  Created by Harshavardhan K on 04/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import UIKit
import Firebase

import os.log

class ChatListTableViewController: UITableViewController {
    
    var chats: [Friends] = [Friends]()
    var chat: Friends?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.separatorStyle = .none
        
        loadData()
        
       
        
       // sortChatList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        
        cell.nameLabel.text = chats[indexPath.row].name
        cell.recentTextLabel.text = chats[indexPath.row].recentMessage.messageBody

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

    // MARK: - Navigation
    
    @IBAction func unwindToChatList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ChatViewController {
            
            let recentMessage = sourceViewController.finalText
            chat = sourceViewController.friend
            chat?.recentMessage = recentMessage
           // print("unwound!")
            print(recentMessage?.messageBody)
            
            if let friend = chat {
                print("whats happening?")
                modifyForChatFriend(friend: friend)
                
            } else {
                print("Not working")
            }
            
            sortChatList()
            saveChatList()
           // loadData()
            
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToChat" {
            
            if let chatViewController = segue.destination as? ChatViewController {
                print("Segueing to chat view!")
                chatViewController.friend = chats[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    
    func loadData() {
        
        if let actualChats = loadChatList() {
            chats = actualChats
           // print(chats[0].messages[0].messageBody)
            
        } else {
            
            let rum = Friends(name: "Ramathmika")
            rum.recentMessage = Message(sender: "Harsha", message: "Sup", time: "12:45")
            let mark = Friends(name: "Mark Zuckerberg")
            mark.recentMessage = Message(sender: "Harsha", message: "Hey", time: "13:45")
            let roop = Friends(name: "Roopali")
            roop.recentMessage = Message(sender: "Roopali", message: "Hey there", time: "09:45")
            
            chats.append(rum)
            chats.append(mark)
            chats.append(roop)
        }
        
    }
    
    private func sortChatList() {
       
         chats.sort(by: { (f1: Friends, f2: Friends) -> Bool in
            
            let time1 = parseTimeStamp(timeStamp: f1.recentMessage.timeStamp)
            let time2 = parseTimeStamp(timeStamp: f2.recentMessage.timeStamp)
            print(time1, time2)
            
            return time1 > time2
        })
        
        for chat in chats {
            print(chat.name)
        }
        
     }
    
    private func parseTimeStamp(timeStamp: String) -> Int {
        
        let arr = Array(timeStamp)
        let breakPointIndex = arr.index(of: ":")
        let minutes = String(arr[breakPointIndex! + 1...breakPointIndex! + 2])
        let hours = String(arr[0...breakPointIndex! - 1])
        let timeString = hours + minutes
        let time = Int(timeString)
        
        return time!
    }
    
     func modifyForChatFriend(friend: Friends)  {
        
        var index = 0
        
        for i in 0..<chats.count {
            if chats[i].name == friend.name {
                index = i
                
            }
            
        }
        
       // print(index)
        chats[index] = friend
       // print(chats[index].recentMessage.messageBody)
        tableView.reloadData()
    }
    
    //MARK: saveChatList: Saves current chat list state
    private func saveChatList() {
        
        let successfulSave = NSKeyedArchiver.archiveRootObject(chats, toFile: Friends.archiveURL.path)
        
        if successfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadChatList() -> [Friends]? {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Friends.archiveURL.path) as? [Friends])
    }
    
}





