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
    var username: String = ""

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
        
        fetchUserName(emailAddress: emailTextfield.text!)
        
    }
    
    private func saveCurrentUser(emailAddress: String) {
        
        print("Username in saveUsr", username)
        
        let thisUser = Friends(name: username, email: emailAddress)
        let encodedUser: Data = NSKeyedArchiver.archivedData(withRootObject: thisUser)
        
        userDefaults.set(encodedUser, forKey: "thisUser")
        userDefaults.synchronize()
        
        //print(thisUser.name)
        
        //print(thisUser.emailAddress)
        
        
    }
    
    private func fetchUserName(emailAddress: String) {
        
        let usersDB = Database.database().reference().child("users")
        let cleanMail = cleanEmailAddress(email: emailAddress)
        //print("Cleaned", cleanMail)
        
        usersDB.observe(.childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            print("Username is", snapshotValue[cleanMail]!)
            
            if let userName = snapshotValue[cleanMail] {
                self.username = userName
            } else {
                print("Not fetching")
            }
            
            self.saveCurrentUser(emailAddress: emailAddress)
            
            SVProgressHUD.dismiss()
        }
        
        
    }

}  
