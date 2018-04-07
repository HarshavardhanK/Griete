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
    var currentTime: Int = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ChatBackground")!)
        //tableView.backgroundColor = UIColor.clear
        
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
        cell.profilePicture.image = chats[indexPath.row].profilePicture
        cell.backgroundColor = UIColor.clear

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
            
            currentTime = sourceViewController.currentTime
            
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
    
    @IBAction func unwindFromAddFriend(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? AddFriendViewController {
            
            let friend = sourceViewController.friend
            chats.append(friend!)
            
            saveChatList()
            
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
            
        } else if segue.identifier == "profile" {
            
            
            
        } else if segue.identifier == "addFriend" {
            
            
        }
    }
    
    
    func loadData() {
        
        if let actualChats = loadChatList() {
            chats = actualChats
           // print(chats[0].messages[0].messageBody)

        } else {
        
            let rum = Friends(name: "Ramathmika", email: "ramathmikavs1999@gmail.com")
        rum.recentMessage = Message(sender: "Harsha", message: "Sup", time: "12:45", sentTime: "0304115604")
            let mark = Friends(name: "Mark Zuckerberg", email: "something@fb.com")
            mark.recentMessage = Message(sender: "Harsha", message: "Hey", time: "13:45",sentTime: "0304115602")
            let roop = Friends(name: "Roopali", email: "roopsh@gmail.com")
            roop.recentMessage = Message(sender: "Roopali", message: "Hey there", time: "09:45", sentTime: "0304115607")
            
            chats.append(rum)
            chats.append(mark)
            chats.append(roop)
        }
        
    }
    
    private func sortChatList() {
        
         chats.sort(by: { (f1: Friends, f2: Friends) -> Bool in
            
            let time1 = Int(f1.recentMessage.sentTime)!
            let time2 = Int(f2.recentMessage.sentTime)!

            print(currentTime-time1, currentTime-time2)
            
            return currentTime-time1 < currentTime-time2
        })
        
     }
    
   
    private func modifyForChatFriend(friend: Friends)  {
        
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
    
    private func cleanDate(time: String) -> String {
        
        var cleanTime: String = ""
        
        if Int(time)! / 10 < 1 {
            cleanTime = "0" + String(time)
        }
        
        return cleanTime
        
    }
    
}





