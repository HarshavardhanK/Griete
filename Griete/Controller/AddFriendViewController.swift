//
//  AddFriendViewController.swift
//  Griete
//
//  Created by Harshavardhan K on 10/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController, UITextFieldDelegate {
    
    let userDefaults = UserDefaults.standard
    //var user: Friends!
    var friend: Friends!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        print(friend.emailAddress)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        nameTextField.delegate = self

        // Do any additional setup after loading the view.
        //loadUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Add Friend UITextField Delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        if textField.tag == 1 {
           friend.name = textField.text!
        } else {
            friend.emailAddress = textField.text!
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}


extension Character {
    
    var asciiValue: Int {
        
        get {
            
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
        
    }
}
