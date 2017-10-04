//
//  LoginVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/30/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD
import NotificationBannerSwift

class LoginVC: UIViewController, UITextFieldDelegate  {

       // MARK: - Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var loginBtn: CustomizableButton!
    @IBOutlet weak var createNewAccoutnBtn: CustomizableButton!
    
    @IBOutlet weak var usernameTxt: UITextField!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTxt: UITextField!  {
        didSet{
            passwordTxt.delegate = self
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Functions
    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func hideForgotDetailButton(isHidden: Bool){
        self.forgotBtn.isHidden = isHidden
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       
        if (textField == usernameTxt)
        {
            passwordTxt.becomeFirstResponder()
            return true
        }
            
        else if (textField == passwordTxt)
        {
            passwordTxt.resignFirstResponder()
            
            return true
        }
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        hideForgotDetailButton(isHidden: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue: 80)
        hideForgotDetailButton(isHidden: false)
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSetNotAllowed = CharacterSet.punctuationCharacters
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
            return false
        } else {
            return true
        }
     
    }
    

    // MARK: - Actions

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginBtn(_ sender: Any) {
        
        print("sign in pressed")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            let banner = StatusBarNotificationBanner(title: "One or more fields have not been filled. Please try again.", style: .danger)
            banner.show()
            
           
            ProgressHUD.dismiss()
            return
        }
        
        let fieldTextLength1 = usernameTxt.text!.characters.count
        let fieldTextLength2 = passwordTxt.text!.characters.count
        if  fieldTextLength1 < 4 || fieldTextLength2  < 4 {
            let banner = StatusBarNotificationBanner(title: "Login failed! Wrong password or username.", style: .danger)
            banner.show()
           
            ProgressHUD.dismiss()

            return
        }
        
        // login functions
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user, error) -> Void in
            if error == nil {
                
                // remember user or save in App Memory did the user login or not
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                ProgressHUD.show("Please wait...", interaction: false)
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                // show alert message
                let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                banner.show()
                
                ProgressHUD.dismiss()
              
                
            }
        }
        
    }
    
    
    @IBAction func createNewAccountBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func forgotBtn(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.present(vc, animated: true, completion: nil)
    }
    

}
