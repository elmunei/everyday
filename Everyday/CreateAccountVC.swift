//
//  CreateAccountVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/30/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import ProgressHUD
import NotificationBannerSwift


class CreateAccountVC: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

     @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var fullNameTxt: UITextField!{
        didSet{
            fullNameTxt.delegate = self
        }
    }
    
    
    @IBOutlet weak var usernameTxt: UITextField!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.delegate = self
        }
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    // Variables
    var keyboard = CGRect()
    var locationTxt = ""
    
    // MARK: - Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location
        getLocation()
        locationManager.delegate = self
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Functions

    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // hide keyboard func
    @objc func hideKeyboard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.animateView(up: true, moveValue: 0)
        })
    }
    
    // show keyboard func
    @objc func showKeyboard(_ notification:Notification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
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
    
    //MARK: - Actions
    
    // clicked next button
    @IBAction func nextBtn_click(_ sender: AnyObject) {
        
        
        // if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullNameTxt.text!.isEmpty) {
            ProgressHUD.dismiss()
            
            // show alert message
            
            let banner = StatusBarNotificationBanner(title: "One or more fields have not been filled. Please try again.", style: .danger)
            banner.show()
            
            
            return
        }
        
        // if incorrect email according to regex
        if !validateEmail(emailTxt.text!) {
            // show alert message
            
            let banner = StatusBarNotificationBanner(title: "Incorrect email format please provide a valid email address", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()

            return
        }
        
        if (usernameTxt.text!.characters.count < 4) {
           
            // show alert message
            
            let banner = StatusBarNotificationBanner(title: "Username cannot be less than 4 characters", style: .danger)
            banner.show()
            ProgressHUD.dismiss()

            return
            
        }
        
        if (passwordTxt.text!.characters.count < 8) {
          
            // show alert message
            
            let banner = StatusBarNotificationBanner(title: "Password cannot be less than 6 characters", style: .danger)
            banner.show()
            ProgressHUD.dismiss()

            return
        }
        
        
        // send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullNameTxt.text?.lowercased()
        user["location"] = locationTxt.lowercased()
        user["tags"] = ""
        user["quote"] = ""
        user["gender"] = ""
        user["facebook"] = ""
        user["twitter"] = ""
        user["instagram"] = ""

        // save data in server
        user.signUpInBackground { (success, error) -> Void in
            
            ProgressHUD.show("loading...", interaction: false)

            
            if success {
                print("registered")
                
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                ProgressHUD.dismiss()

                
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePhotoVC") as! ProfilePhotoVC
                self.present(vc, animated: true, completion: nil)
                
                
                
                
            } else {
//                SwiftSpinner.hide()
                // show alert message
                
                let alert = SCLAlertView()
                _ = alert.showError("Error", subTitle: error!.localizedDescription)
                ProgressHUD.dismiss()

                return
                
            }
        }

        
        
    }
    
    //Textfield Delegates
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == fullNameTxt)
        {
            usernameTxt.becomeFirstResponder()
            return true
        }
            
        else if (textField == usernameTxt)
        {
            emailTxt.becomeFirstResponder()
            
            return true
        }
        else if (textField == emailTxt)
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
        lblTxt.isHidden = true
        animateView(up: true, moveValue: 200)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lblTxt.isHidden = false
        animateView(up: false, moveValue:
            200)
    }
    
    // MARK: Location Functions
    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if let placemarksData = placemarks {
                let locationData = placemarksData[0]
                // San Francisco, CA zip, United States
                let city = locationData.locality!
                //let state = locationData.administrativeArea!
                //let zipCode = locationData.postalCode!
                let country = locationData.country!
                let location = "\(city), \(country)"
                
                self.locationTxt = location
                print(location)
            } else {
                self.locationTxt = "unavailable"
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    
    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {

        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
