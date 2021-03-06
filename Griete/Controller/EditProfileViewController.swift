//
//  EditProfileViewController.swift
//  Griete
//
//  Created by Harshavardhan K on 10/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var user: Friends!
    let userDefaults = UserDefaults.standard
    
    //MARK: Profile Picture IBOutlets

    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBAction func saveUserName(_ sender: Any) {
        user = Friends(name: userNameTextField.text!, email: " ")
        saveCurrentUser(username: user.name)
    }
    
    @IBAction func setProfilePicture(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        print(user.name)
        let profileDB = Database.database().reference().child(user.name + "-profile")
        let profileObject: Dictionary<String, Any> = ["ProfilePicture": user.profilePicture!, "Username": user.name]
        profileDB.setValue(profileObject)
        print("Successfully set!")
        
        SVProgressHUD.dismiss()
    }
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameTextField.delegate = self
        loadUser()
        
        if let thisUser = user {
            userNameTextField.placeholder = thisUser.name
            
        } else {
            userNameTextField.placeholder = "Username"
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "RegisterLoginBackground")!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Profile Picture
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }
    
    
     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profilePictureImageView.image = selectedImage
        user.profilePicture = profilePictureImageView.image
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        userNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveCurrentUser(username: String) {
        
        let thisUser = Friends(name: username, email: "emailAddress")
       // user.name = username
        let encodedUser: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        
        userDefaults.set(encodedUser, forKey: "thisUser")
        userDefaults.synchronize()
        
        print(user.name)
        
    }

    
    func loadUser() {
        
        let userDecoded = userDefaults.object(forKey: "thisUser") as! Data
        user = NSKeyedUnarchiver.unarchiveObject(with: userDecoded) as! Friends
        
        print(user.emailAddress)
    }

}
