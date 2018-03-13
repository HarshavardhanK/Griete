//
//  RegisterViewController.swift
//  Griete
//


import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    var userDefaults = UserDefaults.standard

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        SVProgressHUD.show()
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                
            } else {
                SVProgressHUD.dismiss()
                
                //self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
        print(emailTextfield.text!)
        saveCurrentUser(emailAddress: emailTextfield.text!)
    
        
    }
    
    func saveCurrentUser(emailAddress: String) {
        
        let thisUser = Friends(name: "", email: emailAddress)
        let encodedUser: Data = NSKeyedArchiver.archivedData(withRootObject: thisUser)
        
        userDefaults.set(encodedUser, forKey: "currentUser")
        userDefaults.synchronize()
        
        print(thisUser.emailAddress)
        
    }
    
    
}
