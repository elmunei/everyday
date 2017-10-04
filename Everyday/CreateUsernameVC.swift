//
//  CreateUsernameVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 10/4/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import NotificationBannerSwift
import CoreLocation
import ProgressHUD

class CreateUsernameVC: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var usernameTxt: UITextField!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUsernameVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUsernameVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(CreateUsernameVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
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
    

    //MARK: - Actions
    
    // clicked next button
    @IBAction func nextBtn_click(_ sender: AnyObject) {
        
        // if fields are empty
        if (usernameTxt.text!.isEmpty) {
            ProgressHUD.dismiss()
            
            // show alert message
            
            let banner = StatusBarNotificationBanner(title: "Username cannot be empty. Please try again.", style: .danger)
            banner.show()
            
            
            return
        }
        
    
    
    if (usernameTxt.text!.characters.count < 4) {
    
    // show alert message
    
    let banner = StatusBarNotificationBanner(title: "Username cannot be less than 4 characters", style: .danger)
    banner.show()
    ProgressHUD.dismiss()
    
    return
    
    }
        
        
        // send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        
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
        
        if (textField == usernameTxt)
        {
            usernameTxt.becomeFirstResponder()
            return true
        }
            
      
            
        else if (textField == usernameTxt)
        {
            usernameTxt.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        animateView(up: true, moveValue: 200)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
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

}
