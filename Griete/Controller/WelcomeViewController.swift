//
//  WelcomeViewController.swift
//  Griete
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit



class WelcomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //signInHeightConstraint.constant = 0
        //resgisterHeightConstraint.constant = 0
        
       // animateButtons()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func animateButtons() {
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            self.resgisterHeightConstraint.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
//            self.signInHeightConstraint.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//
//    }
    
}
