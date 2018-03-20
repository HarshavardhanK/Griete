//
//  LogInViewController.swift
//  Griete
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var user: Friends!

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error)
                
            } else {
                SVProgressHUD.dismiss()
               // self.performSegue(withIdentifier: "goToChat", sender: self)

            }
        }
        
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
