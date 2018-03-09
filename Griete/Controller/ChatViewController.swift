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
    
    var friend: Friends!
    var databaseChildReferenceForChat: String = ""
    var finalText: Message?
    
    
    // Declare instance variables here
    var messages: [Message] = [Message]()

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor.clear
        messageTableView.backgroundView = UIImageView(image: UIImage(named: "ChatBackground"))
        
        //Database child reference
        //Something here is not working. FIX LATER
        let email = (Auth.auth().currentUser?.email)!
        print(email)
        let emailIndexWithoutEnding = email.index(email.endIndex, offsetBy: -10)
        let finalEmail = email.prefix(upTo: emailIndexWithoutEnding)
        print(finalEmail)
        databaseChildReferenceForChat = friend.name + finalEmail
        print(databaseChildReferenceForChat)
        
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
        cell.avatarImageView.image = UIImage(named: "egg")
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
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.38) {
            
            self.heightConstraint.constant = 50 + 258 // 258 is the height of the keyboard
            self.view.layoutIfNeeded()

        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextfield.resignFirstResponder()
        
        UIView.animate(withDuration: 0.50) {
            
            self.heightConstraint.constant = 50  // 258 is the height of the keyboard
            self.view.layoutIfNeeded()
            
        }
        
        reloadData()
        
    }

    //MARK: - Send & Recieve from Firebase

    @IBAction func sendPressed(_ sender: AnyObject) {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let timeStamp = "\(hour):\(minutes)"
        print(timeStamp)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let message = Message(sender: (Auth.auth().currentUser?.email)!, message: messageTextfield.text!, time: timeStamp)

        let messagesDB = Database.database().reference().child(friend.name)
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!, "TimeStamp": timeStamp]
        
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
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    private func loadMessages() {
        messages = friend.messages
        reloadData()
    }
    
    private func retrieveMessages() {
        
        let messagesDB = Database.database().reference().child(friend.name)
        //observe for event type child added
        messagesDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let timeStamp = snapshotValue["TimeStamp"] ?? "\(10):\(10)"
            
            let message = Message(sender: sender, message: text, time: timeStamp)
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
        
    }
    
    private func reloadData(){
        
        messageTableView.reloadData()
        
        DispatchQueue.global(qos: .background).async {
            
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                
                if self.messageTableView.contentSize.height > self.messageTableView.frame.size.height {
                    
                    let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
                    self.messageTableView.setContentOffset(scrollPoint, animated: true)

                }
                
            }
            
        }
        
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
