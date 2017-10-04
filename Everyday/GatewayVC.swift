//
//  GatewayVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/30/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import LocalAuthentication
import FBSDKLoginKit
import Parse
import ProgressHUD
import NotificationBannerSwift

import ParseFacebookUtilsV4

class GatewayVC: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var emailLogin: UIButton!
    
    @IBOutlet weak var touchIDbtn: UIButton!
    
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountBtn(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func facebookBtn(_ sender: Any) {
  
       
    }
    
    @IBAction func emailBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func touchIDbtn(_ sender: Any) {
        
        authenticateUsingTouchID()
    }
    
    //MARK: - FUNCTIONS

    
        //TOUCHID SETTINGS
    func authenticateUsingTouchID() {
        
        let authContext = LAContext()
        let authReason = "Sign in with your Touch ID"
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) in
                
                if success {
                    print("Authentication Successful")
                    
                    DispatchQueue.main.async (execute: {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! homeVC
                        self.present(vc, animated: true, completion: nil)
                    })
                    
                } else {
                    if let error = error {
                        DispatchQueue.main.async(execute: {
                            if #available(iOS 11.0, *) {
                                self.reportTouchIDError(error: error as NSError)
                            } else {
                                // Fallback on earlier versions
                            }
                        })
                    }
                }
            })
            
        } else {
            //we have an error
            print(authError?.localizedDescription as Any)
        }
    }
    
    func reportTouchIDError (error: NSError) {
        
        
        switch error.code {
        case LAError.authenticationFailed.rawValue:
            print("Authentication Failed")
        case LAError.passcodeNotSet.rawValue:
            print("Passwode not set")
        case LAError.systemCancel.rawValue:
            print("Authentication canceled by the system")
        case LAError.userCancel.rawValue:
            print("User canceled authentication")
        case LAError.biometryNotEnrolled.rawValue:
            print("User has not enrolled any fingerprint")
        case LAError.biometryNotAvailable.rawValue:
            print("Touch ID is not available")
        case LAError.userFallback.rawValue:
            print("User tapped enter password")
        default:
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
}
