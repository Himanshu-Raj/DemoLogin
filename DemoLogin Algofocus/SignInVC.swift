//
//  ViewController.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 29/12/17.
//  Copyright © 2017 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Variable Declaration
     var dict : [String : AnyObject]!
    
    // var user : UserDetails!
    var getName : String!
    var getFirstName : String!
    var getLastName : String!
    var getEmailId : String!
    var getBirthday : String!
    var getGender : String!
    var getNativeLocation : String!
    var getProfilePic : String!
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Method from UITextFieldDelegate to manage keypad taps.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // MARK: IBActions for various button actions
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let accessToken = FBSDKAccessToken.current()
        if accessToken != nil {
            print("User Already LoggedIn")
            let alert = UIAlertController(title: "User Already logged in..!!", message: "Log out previous user to continue further..!!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Log out!", style: UIAlertActionStyle.default, handler: { (action ) in
                self.logoutUser() }))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Not loggedIn")
              self.fbLogin()
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        // Alert to show that sign in is disabled for now for this app. Use FB login.
        let alert = UIAlertController(title: "SignIn Disabled", message: "Please tap Facebook Login button to continue..!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Sure", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    // MARK: Functions required to get data from FB API call and extract required parameters
    func fbLogin() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email", "user_location", "user_birthday"], from: self) { (result, error) -> Void in
            
            if error != nil {
                print("Occured Error Description : " + (error?.localizedDescription)!)
                self.dismiss(animated: true, completion: nil)
            } else if (result?.isCancelled)! {
                print("User Cancelled the login action")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.extractDetails()
            }
        }
    }
    
    func extractDetails() {
         FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, email, gender, location, birthday, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                print(fbDetails)
                                if let fullName  = fbDetails["name"] as? String {
                                   print("Full Name is : " + fullName )
                                    self.getName = fullName
                                }
                
                                if let fName  = fbDetails["first_name"] as? String {
                                    print("First_Name is : " + fName )
                                    self.getFirstName = fName
                                }
                
                                if let lName  = fbDetails["last_name"] as? String {
                                    print("Last_Name is : " + lName )
                                    self.getLastName = lName
                                }
                
                                if let eId  = fbDetails["email"] as? String {
                                    print("Email Id is : " + eId )
                                    self.getEmailId = eId
                                }
                
                                if let gen  = fbDetails["gender"] as? String {
                                    print("Gender is : " + gen )
                                    self.getGender = gen
                                }
                
                                if let birthday  = fbDetails["birthday"] as? String {
                                    print("birthday is : " + birthday )
                                    self.getBirthday = birthday
                                }
                
                                if let picture = fbDetails["picture"] as? NSDictionary {
                                    if let data = picture["data"] as? NSDictionary{
                                        if let profilePicture = data["url"] as? String {
                                            print("Profile picture url is : " + profilePicture)
                                            self.getProfilePic = profilePicture
                                        }
                                    }
                                }
                
                                if let location = fbDetails["location"] as? NSDictionary {
                                        if let locationContents = location["name"] as? String {
                                                print("Location is: \(locationContents) ")
                                                self.getNativeLocation = locationContents
                                    }
                                }
                
                // Navigate to next VC.
                 let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "userDetailsDisplayVC") as! UserDetailsDisplayVC
                        userDetailsVC.setName = self.getName
                        userDetailsVC.setFirstName = self.getFirstName
                        userDetailsVC.setLastName = self.getLastName
                        userDetailsVC.setEmailId = self.getEmailId
                        userDetailsVC.setGender = self.getGender
                        userDetailsVC.setBirthday = self.getBirthday
                        userDetailsVC.setNativeLocation = self.getNativeLocation
                        userDetailsVC.setProfilePic = self.getProfilePic
                // userDetailsVC.setCurrentLocation = self.getCurrentLocation
                
                 self.navigationController?.pushViewController(userDetailsVC, animated: true)
                
            } else  {
                print(error?.localizedDescription ?? "Details Not found")
            } })
    }
    
        func logoutUser() {
            let manager : FBSDKLoginManager = FBSDKLoginManager()
            manager.logOut()
    
            // These will also forget user details if they get saved while login, so that next it's a fresh login
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
    }
}
