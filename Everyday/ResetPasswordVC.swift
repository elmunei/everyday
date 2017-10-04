//
//  ResetPasswordVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/30/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController, UITextFieldDelegate {

    //Mark: - Outlets
    
    
    @IBOutlet weak var resetPwd: CustomizableTextfield!{
        didSet{
            resetPwd.delegate = self
        }
    }
    
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }

    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    
    @IBAction func resetBtn(_ sender: Any) {

        // if fields are empty
        if (resetPwd.text!.isEmpty) {
            
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "Email address field cannot be empty. Please try again.")
            
            
            return
        }
    
        // if incorrect email according to regex
        if !validateEmail(resetPwd.text!) {
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Incorrect email format", subTitle: "please provide a valid email address")
            return
        }
        
        lbl.text = "A reset password link has been sent to \(String(describing: self.resetPwd.text!)) \n 😎"
        
        
        
        
    }


    @IBAction func cancelBtn(_ sender: Any) {
        
        self.resetPwd.text = ""
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (textField == resetPwd)
    {
        resetPwd.resignFirstResponder()
        return true
    }
    
    
    return false
}


func textFieldDidBeginEditing(_ textField: UITextField) {
    animateView(up: true, moveValue: 80)
    
    
}

func textFieldDidEndEditing(_ textField: UITextField) {
    animateView(up: false, moveValue:
        80)
    
}

// Move the View Up & Down when the Keyboard appears
func animateView(up: Bool, moveValue: CGFloat){
    
    let movementDuration: TimeInterval = 0.3
    let movement: CGFloat = (up ? -moveValue : moveValue)
    UIView.beginAnimations("animateView", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(movementDuration)
    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    UIView.commitAnimations()
    
    
}

    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }

}



