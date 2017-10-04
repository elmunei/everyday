//
//  ProfilePhotoVC.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/30/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD
import NotificationBannerSwift

class ProfilePhotoVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var joinBtn: CustomizableButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // round avatar
        pp.layer.cornerRadius = pp.frame.size.width / 2
        pp.clipsToBounds = true
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(ProfilePhotoVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        pp.isUserInteractionEnabled = true
        pp.addGestureRecognizer(avaTap)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Functions

    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pp.image = info[UIImagePickerControllerEditedImage] as? UIImage
        //pp.focusOnFaces = true
        // pp.debugFaceAware = true
        lbl1.isHidden = false
        lbl1.text = "Nice pic, 👌"
        lbl2.isHidden = false
        lbl2.text = "Don't forget to add a little confetti to each day.\n 🎊 🎊 🎊"
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinBtn(_ sender: Any) {
        
        // if no pp
        if  pp.image! == UIImage(named: "addphoto")! {
            // Stop the spinner
            
            
            // show alert message
            
            // show alert message
            let banner = StatusBarNotificationBanner(title:"Please add a profile picture", style: .danger)
            banner.show()
           
            ProgressHUD.dismiss()
            return
        }
        
        // save image in information
        let user = PFUser.current()!
        let avaData = UIImageJPEGRepresentation(pp.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.saveInBackground (block: { (success, error) -> Void in
            
            // Run a spinner to show a task in progress
            ProgressHUD.show("Adding your cool picture 🤗", interaction: false)
            
            if success{
                
                
//                SwiftSpinner.hide()
                // hide keyboard
                self.view.endEditing(true)
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                ProgressHUD.dismiss()
                // call login func from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
                
                
            } else {
//                SwiftSpinner.hide()
                // show alert message
                
                
                // show alert message
                let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                banner.show()
                
                ProgressHUD.dismiss()
                
            }
            
        })
        
        
    }

}














