//
//  ViewController.swift
//  Griete
//
//  Created by Harshavardhan K on 04/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//
import UIKit

import Firebase
import SVProgressHUD
import ChameleonFramework

import os.log

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //currentTime
    var currentTime: Int = 0
    
    var friend: Friends!
    var databaseChildReferenceForChat: String = ""
    var finalText: Message?
    var messageSent: Bool = false
    var sentTime: String = ""
    
    //MARK: User Defaults
    var userDefaults = UserDefaults.standard
    var user: Friends!
    // Declare instance variables here
    var messages: [Message] = [Message]()

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getCurrentTime()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
       // loadMessages()
        
        navigationItem.title = friend.name
        
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor.clear
        messageTableView.backgroundView = UIImageView(image: UIImage(named: "ChatBackground"))
        
        //Database child reference
        
       // loadUser()
        
        var ref: String {
            
            let combinedName = friend.name
            var this = ""
            
            for c in combinedName {
                this += String(c)
            }
            
            return this
        }
        
        databaseChildReferenceForChat = {
            
            var rref = Array(ref)
            rref.sort(by: {$0 < $1})
            
            return String(rref)

        }()
        
        print(ref)
        print(databaseChildReferenceForChat)
        
        retrieveMessages()
        
        reloadData()

    }

    //MARK: Scroll down to bottom delegate method
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == lastRowIndex - 1 {
            tableView.scrollToBottom(animated: true)
        }
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //let messageArray = ["What", "The", "Fuck"]
        cell.messageBody.text = messages[indexPath.row].messageBody
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "default-profile")
        cell.timeStamp.text = messages[indexPath.row].timeStamp
        cell.backgroundColor = UIColor.clear
       
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            //Messages we went
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.38) {
            
            self.heightConstraint.constant = 50 + 258 // 258 is the height of the keyboard
            self.view.layoutIfNeeded()
            
            self.reloadData()

        }
        
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextfield.resignFirstResponder()
        
        UIView.animate(withDuration: 0.50) {
            
            self.heightConstraint.constant = 50  // 258 is the height of the keyboard
            self.view.layoutIfNeeded()
            
             self.reloadData()
        }
        
    }

    //MARK: - Send & Recieve from Firebase

    @IBAction func sendPressed(_ sender: AnyObject) {
        
        let date = Date()
        let calendar = Calendar.current
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        var seconds = String(calendar.component(.second, from: date))
        
        var day = String(calendar.component(.day, from: date))
        var month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        
        messageSent = true
        
        minutes = cleanDate(time: minutes)
        hour = cleanDate(time: hour)
        seconds = cleanDate(time: seconds)
        
        day = cleanDate(time: day)
        month = cleanDate(time: month)
        
        let thisDay = day + month + year

        sentTime = thisDay + hour + minutes + seconds
        print(sentTime)

        let timeStamp = "\(hour):\(minutes):\(seconds)"
        print(timeStamp)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false

        let messagesDB = Database.database().reference().child(databaseChildReferenceForChat)
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!, "TimeStamp": timeStamp, "sentTime":sentTime]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            
            (error, reference) in
            
            if error != nil {
                print(error)
                
            } else {
                
            }
        }
        
        self.messageTextfield.isEnabled = true
        self.sendButton.isEnabled = true
        messageTextfield.text = ""
        
        reloadData()
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    private func loadMessages() {
        messages = friend.messages
        reloadData()
    }
    
    private func retrieveMessages() {
        
        let messagesDB = Database.database().reference().child(databaseChildReferenceForChat)
        //observe for event type child added
        messagesDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let timeStamp = snapshotValue["TimeStamp"] ?? "10:10:10"
            var messageSentTime: String
            
            if let SentTime = snapshotValue["sentTime"]  {
                messageSentTime = SentTime
            } else {
                messageSentTime = "02042018101010"
            }
            
            print(messageSentTime)
            
            let message = Message(sender: sender, message: text, time: timeStamp, sentTime: messageSentTime)
            self.messages.append(message)
            
            self.finalText = self.messages[self.messages.count - 1]
           // print("Final text is", self.finalText)
            
            self.configureTableView()
            self.reloadData()
            
            print(text, sender)
        }
        
        friend.messages = messages
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            print(error)
        }
        
        userDefaults.removeObject(forKey: "currentUser")
        userDefaults.synchronize()
        
    }
    
    private func reloadData(){
        
        messageTableView.reloadData()
        
        DispatchQueue.global(qos: .background).async {
            
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                
                if self.messageTableView.contentSize.height > self.messageTableView.frame.size.height {
                    
                    let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height - self.heightConstraint.constant)
                    self.messageTableView.setContentOffset(scrollPoint, animated: true)
                    
                    self.view.layoutIfNeeded()

                }
                
            }
            
        }
        
    }
    
    //MARK: Load user in ChatViewController
    func loadUser() {
        
        let userDecoded = userDefaults.object(forKey: "thisUser") as! Data
        user = NSKeyedUnarchiver.unarchiveObject(with: userDecoded) as! Friends
        
        print(user.name)
    }
    
    private func cleanDate(time: String) -> String {
        
        var cleanTime: String = ""
        
        if Int(time)! / 10 < 1 {
            cleanTime = "0" + String(time)
            
        } else {
            return time
        }
        
        return cleanTime

    }
    
    private func getCurrentTime() {
        
        let date = Date()
        let calendar = Calendar.current
        
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        var seconds = String(calendar.component(.second, from: date))
        
        var day = String(calendar.component(.day, from: date))
        var month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        
        minutes = cleanDate(time: minutes)
        hour = cleanDate(time: hour)
        seconds = cleanDate(time: seconds)
        
        day = cleanDate(time: day)
        month = cleanDate(time: month)
        
        let thisDay = day + month + year
        
        currentTime = Int(thisDay + hour + minutes + seconds)!
        
    }
    
    
} // class ends here

extension UITableView {
    
    func scrollToBottom(animated: Bool = true) {
        
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        
        if (rows > 0) {
            
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}

extension Character {
    
    var asciiValue: Int {
        
        get {
            
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
        
    }
}
